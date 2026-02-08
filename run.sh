#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRAPER="$SCRIPT_DIR/google-maps-scraper/google-maps-scraper"
RESULTS_DIR="$SCRIPT_DIR/results"

if [ -z "$1" ]; then
  echo "Usage: ./run.sh <city>"
  echo "Example: ./run.sh Paris"
  echo "         ./run.sh \"New York\""
  exit 1
fi

CITY="$1"
SAFE_CITY=$(echo "$CITY" | tr ' ' '_')

QUERY_FILE=$(mktemp)
echo "gym in $CITY" > "$QUERY_FILE"

OUTPUT_FILE="$RESULTS_DIR/${SAFE_CITY}.csv"

echo "Scraping gyms in $CITY..."
echo "Query: gym in $CITY"
echo "Output: $OUTPUT_FILE"
echo ""

"$SCRAPER" \
  -input "$QUERY_FILE" \
  -results "$OUTPUT_FILE" \
  -depth 10 \
  -lang en \
  -exit-on-inactivity 3m

rm -f "$QUERY_FILE"

if [ -f "$OUTPUT_FILE" ]; then
  COUNT=$(tail -n +2 "$OUTPUT_FILE" | wc -l | tr -d ' ')
  echo ""
  echo "Done! Found $COUNT gyms in $CITY"
  echo "Results saved to: $OUTPUT_FILE"
else
  echo "No results file generated."
  exit 1
fi
