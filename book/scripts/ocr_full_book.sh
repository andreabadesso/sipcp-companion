#!/usr/bin/env bash
# OCR the full SIPCP book PDF into per-page text files and a combined markdown.
#
# The scan has each PDF page as an open-book spread (two book pages side-by-side),
# rotated 90° — so we rotate 270° then split left/right to get individual pages.
#
# Left half = even book page, Right half = odd book page.
#
# Usage:
#   nix shell nixpkgs#poppler-utils nixpkgs#tesseract nixpkgs#imagemagick \
#     --command bash book/scripts/ocr_full_book.sh
#
# Requires: pdftoppm (poppler-utils), tesseract (with por), convert/identify (imagemagick)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BOOK_DIR="$(dirname "$SCRIPT_DIR")"
PDF="$BOOK_DIR/pdf/SKM_C25826031616170.pdf"
PAGES_DIR="$BOOK_DIR/ocr/pages"
COMBINED="$BOOK_DIR/ocr/sipcp_completo.md"
TMP_DIR="$BOOK_DIR/.tmp/ocr_work"

mkdir -p "$PAGES_DIR" "$TMP_DIR"

TOTAL=$(pdfinfo "$PDF" | grep "^Pages:" | awk '{print $2}')
echo "Processing $TOTAL sheets (each = 2 book pages) from: $PDF"
echo ""

BOOK_PAGE=0

for i in $(seq 1 "$TOTAL"); do
  PADDED=$(printf "%03d" "$i")

  # Extract page image
  echo -n "[Sheet $PADDED/$TOTAL] Extracting... "
  pdftoppm -jpeg -r 300 -f "$i" -l "$i" "$PDF" "$TMP_DIR/raw"
  RAW=$(ls "$TMP_DIR"/raw-*.jpg 2>/dev/null | head -1)

  # Rotate 270° (counter-clockwise 90°)
  convert "$RAW" -rotate 270 "$TMP_DIR/rotated.jpg"
  rm -f "$RAW"

  # Split into left (even page) and right (odd page)
  W=$(identify -format "%w" "$TMP_DIR/rotated.jpg")
  H=$(identify -format "%h" "$TMP_DIR/rotated.jpg")
  HALF=$((W / 2))

  convert "$TMP_DIR/rotated.jpg" -crop "${HALF}x${H}+0+0" +repage "$TMP_DIR/left.jpg"
  convert "$TMP_DIR/rotated.jpg" -crop "${HALF}x${H}+${HALF}+0" +repage "$TMP_DIR/right.jpg"
  rm -f "$TMP_DIR/rotated.jpg"

  # OCR left half (even page)
  BOOK_PAGE=$((BOOK_PAGE + 1))
  BPADDED=$(printf "%03d" "$BOOK_PAGE")
  PAGE_TXT="$PAGES_DIR/page_${BPADDED}.txt"

  if [ -f "$PAGE_TXT" ] && [ -s "$PAGE_TXT" ]; then
    echo -n "L:skip "
  else
    echo -n "L:OCR... "
    tesseract "$TMP_DIR/left.jpg" "${PAGE_TXT%.txt}" -l por 2>/dev/null
  fi
  rm -f "$TMP_DIR/left.jpg"

  # OCR right half (odd page)
  BOOK_PAGE=$((BOOK_PAGE + 1))
  BPADDED=$(printf "%03d" "$BOOK_PAGE")
  PAGE_TXT="$PAGES_DIR/page_${BPADDED}.txt"

  if [ -f "$PAGE_TXT" ] && [ -s "$PAGE_TXT" ]; then
    echo "R:skip"
  else
    echo -n "R:OCR... "
    tesseract "$TMP_DIR/right.jpg" "${PAGE_TXT%.txt}" -l por 2>/dev/null
    echo "done."
  fi
  rm -f "$TMP_DIR/right.jpg"
done

# Build combined markdown
echo ""
echo "Building combined markdown..."

cat > "$COMBINED" << 'HEADER'
# SIPCP – Sistema Integrado de Programação e Controle da Produção
### Um Modelo Cibernético de Administração Industrial
#### Fernando Batalha Monteiro (1982)

> OCR automático gerado a partir do scan completo do livro.
> Pode conter erros de reconhecimento — revisar manualmente.

---

HEADER

TOTAL_PAGES=$((TOTAL * 2))
for p in $(seq 1 "$TOTAL_PAGES"); do
  BPADDED=$(printf "%03d" "$p")
  PAGE_TXT="$PAGES_DIR/page_${BPADDED}.txt"
  if [ -f "$PAGE_TXT" ]; then
    echo "" >> "$COMBINED"
    echo "## Página $p" >> "$COMBINED"
    echo "" >> "$COMBINED"
    cat "$PAGE_TXT" >> "$COMBINED"
    echo "" >> "$COMBINED"
    echo "---" >> "$COMBINED"
  fi
done

# Cleanup temp
rm -rf "$TMP_DIR"

echo ""
echo "Done! $TOTAL_PAGES book pages processed (from $TOTAL sheets)."
echo "  Per-page text: $PAGES_DIR/"
echo "  Combined markdown: $COMBINED"
