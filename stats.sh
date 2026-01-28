#!/bin/bash
echo "SCENE TOTALS:"
total=0
for scene in $(find . -name "ch*-sc*.md" | sort); do
  wc=$(pandoc --strip-comments -t plain "$scene" | wc -w)
  echo "  $scene: $wc words"
  total=$((total + wc))
done

echo ""
echo "NOVEL TOTAL: $total words"
