#!/usr/bin/env python3
import markdown
from weasyprint import HTML

INPUT = "../ocr/paginas_193-201_256-258.md"
OUTPUT = "../pdf/paginas_193-201_256-258.pdf"

with open(INPUT, "r", encoding="utf-8") as f:
    md_text = f.read()

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
      color: #666;
    }}
  }}
  body {{
    font-family: 'Georgia', 'Times New Roman', serif;
    font-size: 12pt;
    line-height: 1.6;
    color: #1a1a1a;
  }}
  h1 {{
    font-size: 22pt;
    text-align: center;
    margin-top: 1.5em;
    margin-bottom: 0.3em;
    color: #2c3e50;
    page-break-before: auto;
  }}
  h2 {{
    font-size: 16pt;
    border-bottom: 2px solid #2c3e50;
    padding-bottom: 4pt;
    margin-top: 1.5em;
    color: #2c3e50;
  }}
  h3 {{
    font-size: 13pt;
    margin-top: 1.2em;
    color: #34495e;
  }}
  hr {{
    border: none;
    border-top: 1px solid #ccc;
    margin: 1.5em 0;
  }}
  table {{
    border-collapse: collapse;
    width: 100%;
    margin: 1em 0;
  }}
  th, td {{
    border: 1px solid #999;
    padding: 6pt 10pt;
    text-align: left;
  }}
  th {{
    background-color: #2c3e50;
    color: white;
    font-weight: bold;
  }}
  tr:nth-child(even) {{
    background-color: #f2f2f2;
  }}
  blockquote {{
    border-left: 3px solid #2c3e50;
    margin-left: 0;
    padding-left: 1em;
    color: #555;
    font-style: italic;
  }}
  em {{
    color: #555;
  }}
  strong {{
    color: #1a1a1a;
  }}
  p {{
    text-align: justify;
    margin-bottom: 0.6em;
  }}
  ul, ol {{
    margin-left: 1.5em;
  }}
</style>
</head>
<body>
{html_body}
</body>
</html>
"""

HTML(string=html_full).write_pdf(OUTPUT)
print(f"PDF gerado: {OUTPUT}")
