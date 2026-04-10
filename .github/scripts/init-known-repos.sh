#!/usr/bin/env bash
# init-known-repos.sh
# Extracts all GitHub repo URLs from categories/*.md, deduplicates them,
# and generates data/known-repos.json

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CATEGORIES_DIR="${REPO_ROOT}/categories"
OUTPUT_FILE="${REPO_ROOT}/data/known-repos.json"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Extracting GitHub URLs from ${CATEGORIES_DIR}/*.md ..."

# Extract all https://github.com/<owner>/<repo> URLs from markdown link targets.
# Pattern matches: (https://github.com/owner/repo) or (https://github.com/owner/repo/...)
# We strip anything after the second path segment to keep only owner/repo.
UNIQUE_URLS=$(
  grep -ohE 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(/[^)\" ]*)?'\
    "${CATEGORIES_DIR}"/*.md \
  | sed -E 's|(https://github\.com/[^/]+/[^/]+).*|\1|' \
  | sort -u
)

COUNT=$(echo "$UNIQUE_URLS" | wc -l | tr -d ' ')
echo "Found ${COUNT} unique repos."

# Build JSON array entries
FIRST=1
ENTRIES=""
while IFS= read -r url; do
  if [[ $FIRST -eq 1 ]]; then
    FIRST=0
  else
    ENTRIES+=","
  fi
  ENTRIES+=$(printf '\n    {"url": "%s", "last_scanned": "%s", "skills": []}' "$url" "$TIMESTAMP")
done <<< "$UNIQUE_URLS"

# Write output JSON
mkdir -p "$(dirname "${OUTPUT_FILE}")"
cat > "${OUTPUT_FILE}" <<EOF
{
  "repos": [${ENTRIES}
  ],
  "last_updated": "${TIMESTAMP}"
}
EOF

echo "Written to ${OUTPUT_FILE}"
echo "Validating JSON..."
python3 -c "import json, sys; json.load(open('${OUTPUT_FILE}')); print('JSON is valid.')"
