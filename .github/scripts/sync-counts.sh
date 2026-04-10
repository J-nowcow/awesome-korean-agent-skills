#!/usr/bin/env bash
# sync-counts.sh — Count actual entries in each category file and update README tables
# Usage: bash .github/scripts/sync-counts.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CATEGORIES_DIR="$REPO_ROOT/categories"
README="$REPO_ROOT/README.md"
README_EN="$REPO_ROOT/README.en.md"

# ---------------------------------------------------------------------------
# count_entries <file>
# Counts data rows in a markdown table file.
# Rules:
#   - Line must start with |
#   - Exclude separator rows (e.g. |---|---|)
#   - Exclude header rows whose first cell is a known column-name keyword
# ---------------------------------------------------------------------------
count_entries() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo 0
    return
  fi

  grep "^|" "$file" \
    | grep -v "^|[-: |]*|$" \
    | grep -vE "^\| *(이름|레포|Name|Repo|스킬|카테고리|Category|Icon|Source|Label|아이콘|출처|도구|Tool|Skill)[[:space:]]*\|" \
    | wc -l \
    | tr -d ' '
}

# ---------------------------------------------------------------------------
# update_readme <readme_file>
# For each categories/*.md that appears in the readme, replaces the count.
# Pattern matched:
#   | [any text](categories/FILENAME.md) | any desc | OLD_NUMBER+ |
# Uses awk for safe in-place replacement (handles | in content correctly).
# ---------------------------------------------------------------------------
update_readme() {
  local readme="$1"
  local tmp
  tmp="$(mktemp)"

  # Build an awk script that processes all files in one pass
  local awk_script=""
  for category_file in "$CATEGORIES_DIR"/*.md; do
    local filename
    filename="$(basename "$category_file")"

    # Skip if this file is not referenced in the readme
    if ! grep -q "categories/${filename}" "$readme"; then
      continue
    fi

    local count
    count="$(count_entries "$category_file")"
    local fpath="categories/${filename}"

    # Apply replacement: find lines containing the category path, replace trailing count
    awk_script="${awk_script}
    index(\$0, \"${fpath}\") > 0 && match(\$0, /[0-9]+\\+ \\|[[:space:]]*\$/) {
      printf \"%s${count}+ |\\n\", substr(\$0, 1, RSTART-1)
      next
    }"
  done

  # If no entries to update, just copy and return
  if [[ -z "$awk_script" ]]; then
    return
  fi

  awk "${awk_script}
  { print }" "$readme" > "$tmp" && mv "$tmp" "$readme"
}

# ---------------------------------------------------------------------------
# update_date
# Updates "최근 업데이트: YYYY-MM-DD" in README.md only
# ---------------------------------------------------------------------------
update_date() {
  local today
  today="$(date +%Y-%m-%d)"
  local tmp
  tmp="$(mktemp)"
  awk -v today="$today" '{
    gsub(/최근 업데이트: [0-9]{4}-[0-9]{2}-[0-9]{2}/, "최근 업데이트: " today)
    print
  }' "$README" > "$tmp" && mv "$tmp" "$README"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
echo "[sync-counts] Updating README.md ..."
update_readme "$README"

echo "[sync-counts] Updating README.en.md ..."
update_readme "$README_EN"

echo "[sync-counts] Updating date in README.md ..."
update_date

echo "[sync-counts] Done."
