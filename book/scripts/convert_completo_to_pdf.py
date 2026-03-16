#!/usr/bin/env python3
"""Convert sipcp_completo.md to a nicely formatted PDF."""
import markdown
from weasyprint import HTML
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
INPUT = SCRIPT_DIR / "../ocr/sipcp_completo.md"
OUTPUT = SCRIPT_DIR / "../pdf/sipcp_completo.pdf"

OUTPUT.parent.mkdir(parents=True, exist_ok=True)

md_text = INPUT.read_text(encoding="utf-8")
html_body = markdown.markdown(md_text, extensions=["tables", "extra"])

html_full = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<style>
  @page {{
    size: A4;
    margin: 2.5cm 2cm;
    @bottom-center {{
      content: counter(page);
      font-size: 10pt;
      color: #999;
    }}
  }}
  body {{
    font-family: 'Georgia', 'Times New Roman', serif;
    font-size: 12pt;
    line-height: 1.7;
    color: #1a1a1a;
  }}
  h1 {{
    font-size: 22pt;
    text-align: center;
    margin-top: 2em;
    margin-bottom: 0.3em;
    color: #1a1a1a;
    letter-spacing: 2pt;
    text-transform: uppercase;
    page-break-before: auto;
  }}
  h2 {{
    font-size: 16pt;
    margin-top: 1.5em;
    margin-bottom: 0.8em;
    color: #2c3e50;
    border-bottom: 2px solid #2c3e50;
    padding-bottom: 4pt;
  }}
  h3 {{
    font-size: 14pt;
    margin-top: 1.5em;
    margin-bottom: 0.5em;
    color: #2c3e50;
  }}
  h4 {{
    font-size: 12pt;
    text-align: center;
    margin-top: 0.3em;
    color: #444;
    font-style: italic;
    font-weight: normal;
  }}
  hr {{
    border: none;
    border-top: 1px solid #ddd;
    margin: 1.5em 0;
  }}
  p {{
    text-align: justify;
    margin-bottom: 0.7em;
    text-indent: 2em;
  }}
  h1 + p, h2 + p, h3 + p, h4 + p, hr + p {{
    text-indent: 2em;
  }}
  blockquote {{
    border-left: 3px solid #2c3e50;
    margin: 1.5em 0;
    padding: 0.8em 1.2em;
    background-color: #f8f9fa;
    font-size: 11pt;
    color: #333;
  }}
  blockquote p {{
    text-indent: 0;
    margin-bottom: 0.4em;
  }}
  table {{
    border-collapse: collapse;
    width: 90%;
    margin: 1.5em auto;
  }}
  th, td {{
    border: 1px solid #666;
    padding: 8pt 12pt;
    text-align: left;
    font-size: 11pt;
  }}
  th {{
    background-color: #2c3e50;
    color: white;
    font-weight: bold;
  }}
  tr:nth-child(even) {{
    background-color: #f5f5f5;
  }}
  ul, ol {{
    margin-left: 2em;
    margin-bottom: 0.7em;
  }}
  li {{
    margin-bottom: 0.3em;
  }}
  /* HTML comments (page markers) are invisible in output */
</style>
</head>
<body>
{html_body}
</body>
</html>
"""

HTML(string=html_full).write_pdf(str(OUTPUT))
print(f"PDF gerado: {OUTPUT} ({OUTPUT.stat().st_size / 1024:.0f} KB)")
