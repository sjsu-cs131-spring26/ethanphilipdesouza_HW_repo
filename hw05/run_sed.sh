#!/usr/bin/env bash
set -euo pipefail

INPUT_TSV="/mnt/scratch/CS131_jelenag/amazon_reviews_full.tsv"

echo "HW05: starting..."

PRODUCT_ID=$(cat product_id.txt)

echo "[1/3] Extract review_body..."

tail -n +2 "$INPUT_TSV" \
| cut -f4,14 \
| sed -n "s/^${PRODUCT_ID}\t//p" \
> review_body_raw.txt


echo "[2/3] Clean text..."

cat review_body_raw.txt \
| sed -E 's/<[^>]+>//g' \
| sed -E 's/[[:punct:]]//g' \
| sed -E 's/\b(and|or|if|in|it|the|a|an|is|to|for|on|my|this|you|of|i)\b//Ig' \
| sed -E 's/^[[:space:]]+|[[:space:]]+$//g' \
| sed -E 's/[[:space:]]+/ /g' \
> review_body_clean.txt


echo "[3/3] Tokenize and count..."

cat review_body_clean.txt \
| tr '[:upper:]' '[:lower:]' \
| tr -cs '[:alnum:]' '\n' \
| sort \
| uniq -c \
| sort -nr \
| sed -E 's/^[[:space:]]*([0-9]+)[[:space:]]+(.*)$/\2\t\1/' \
> tokens_top.tsv

echo "Done."
