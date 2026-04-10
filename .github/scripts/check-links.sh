#!/usr/bin/env bash
# check-links.sh — Check all GitHub URLs in category files and remove dead entries
# Usage: bash .github/scripts/check-links.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CATEGORIES_DIR="$REPO_ROOT/categories"
KNOWN_REPOS="$REPO_ROOT/data/known-repos.json"
DEAD_LOG="/tmp/dead-links.log"
DEAD_COUNT_FILE="/tmp/dead-link-count"

# ---------------------------------------------------------------------------
# init
# ---------------------------------------------------------------------------
> "$DEAD_LOG"
total_dead=0

# ---------------------------------------------------------------------------
# check_url <url>  →  returns 0 if alive, 1 if dead
# ---------------------------------------------------------------------------
check_url() {
  local url="$1"
  local status

  status=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 10 "$url" 2>/dev/null || echo "000")

  if [[ "$status" -ge 400 ]] || [[ "$status" == "000" ]]; then
    # Retry once
    sleep 1
    status=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 10 "$url" 2>/dev/null || echo "000")
    if [[ "$status" -ge 400 ]] || [[ "$status" == "000" ]]; then
      return 1
    fi
  fi
  return 0
}

# ---------------------------------------------------------------------------
# Process each category file
# ---------------------------------------------------------------------------
for file in "$CATEGORIES_DIR"/*.md; do
  [[ -f "$file" ]] || continue
  filename="$(basename "$file")"

  # Extract GitHub URLs from table rows (lines starting with |)
  # Match https://github.com/... URLs inside markdown links or bare
  mapfile -t urls < <(
    grep "^|" "$file" \
      | grep -oE 'https://github\.com/[^)>" ]+' \
      | sort -u
  )

  if [[ ${#urls[@]} -eq 0 ]]; then
    continue
  fi

  echo "Checking $filename (${#urls[@]} URLs)..."

  # First pass: collect dead URLs
  declare -a dead_urls=()

  for url in "${urls[@]}"; do
    sleep 0.5  # rate limiting

    if ! check_url "$url"; then
      echo "  DEAD: $url"
      dead_urls+=("$url")
      echo "[$filename] $url" >> "$DEAD_LOG"
    else
      echo "  OK:   $url"
    fi
  done

  # Second pass: remove rows containing dead URLs (URL-based, not line-number-based)
  if [[ ${#dead_urls[@]} -gt 0 ]]; then
    echo "  Removing ${#dead_urls[@]} dead entries from $filename..."

    tmp_file="$(mktemp)"
    cp "$file" "$tmp_file"

    for url in "${dead_urls[@]}"; do
      # Use | as sed delimiter since URLs contain /
      # Remove any table row containing this URL
      sed -i.bak "\|$url|d" "$tmp_file"
    done
    rm -f "$tmp_file.bak"

    mv "$tmp_file" "$file"
    total_dead=$(( total_dead + ${#dead_urls[@]} ))
  fi

  unset dead_urls
done

# ---------------------------------------------------------------------------
# Update data/known-repos.json — remove entries with dead URLs
# ---------------------------------------------------------------------------
if command -v jq &>/dev/null && [[ -f "$KNOWN_REPOS" ]] && [[ -s "$DEAD_LOG" ]]; then
  echo "Updating $KNOWN_REPOS..."

  tmp_repos="$(mktemp)"

  # Collect dead URLs into a bash array
  declare -a dead_urls=()
  while IFS= read -r line; do
    dead_url="${line#* }"
    dead_url="${dead_url%%[[:space:]]*}"
    if [[ -n "$dead_url" ]]; then
      dead_urls+=("$dead_url")
    fi
  done < "$DEAD_LOG"

  # Collect dead URLs into a JSON array
  dead_urls_json=$(jq -n --args '$ARGS.positional' -- "${dead_urls[@]}")
  # Filter in one pass
  jq --argjson dead "$dead_urls_json" '.repos |= map(select(.url as $u | ($dead | index($u)) == null))' "$KNOWN_REPOS" > "$tmp_repos" && mv "$tmp_repos" "$KNOWN_REPOS" || {
    echo "Warning: failed to update known-repos.json" >&2
    rm -f "$tmp_repos"
  }
fi

# ---------------------------------------------------------------------------
# Write summary
# ---------------------------------------------------------------------------
echo "$total_dead" > "$DEAD_COUNT_FILE"

echo ""
echo "============================="
echo "Total dead links removed: $total_dead"
echo "============================="

if [[ "$total_dead" -gt 0 ]]; then
  echo ""
  echo "Dead links:"
  cat "$DEAD_LOG"
fi
