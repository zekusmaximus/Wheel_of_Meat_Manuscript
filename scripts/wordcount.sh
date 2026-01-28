#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

# Only count scene files inside act directories
SCENE_FILES=$(find act*/ -type f -name "sc*.md") 

scene_wc() {
  local file="$1"
  pandoc "$file" --from markdown --to plain --wrap=none | wc -w | tr -d ' '
}

echo "=== SCENE WORD COUNTS ==="
declare -A CHAPTER_TOTALS
declare -A ACT_TOTALS
BOOK_TOTAL=0

for f in $SCENE_FILES; do
  wc=$(scene_wc "$f")
  echo "$f: $wc"

  # Extract act and chapter from path
  act=$(echo "$f" | cut -d/ -f1)
  chapter=$(echo "$f" | cut -d/ -f2)

  CHAPTER_TOTALS["$act/$chapter"]=$(( ${CHAPTER_TOTALS["$act/$chapter"]:-0} + wc ))
  ACT_TOTALS["$act"]=$(( ${ACT_TOTALS["$act"]:-0} + wc ))
  BOOK_TOTAL=$(( BOOK_TOTAL + wc ))
done

echo
echo "=== CHAPTER TOTALS ==="
for ch in "${!CHAPTER_TOTALS[@]}"; do
  printf "%s: %d\n" "$ch" "${CHAPTER_TOTALS[$ch]}"
done | sort

echo
echo "=== ACT TOTALS ==="
for act in "${!ACT_TOTALS[@]}"; do
  printf "%s: %d\n" "$act" "${ACT_TOTALS[$act]}"
done | sort

echo
echo "=== BOOK TOTAL ==="
echo "$BOOK_TOTAL"
