#!/usr/bin/env python3
import markdown
from weasyprint import HTML

INPUT = "../ocr/conteudo_limpo.md"
OUTPUT = "../pdf/conteudo_limpo.pdf"

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
    margin: 3cm 2.5cm;
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
    font-size: 20pt;
    text-align: center;
    margin-top: 2em;
    margin-bottom: 0.4em;
    color: #1a1a1a;
    letter-spacing: 2pt;
    text-transform: uppercase;
  }}
  h2 {{
    font-size: 15pt;
    text-align: center;
    margin-top: 1em;
    margin-bottom: 1em;
    color: #1a1a1a;
    letter-spacing: 1pt;
  }}
  h3 {{
    font-size: 13pt;
    margin-top: 1.5em;
    margin-bottom: 0.5em;
    color: #1a1a1a;
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
    border-top: 1px solid #ccc;
    margin: 2em 0;
  }}
  p {{
    text-align: justify;
    margin-bottom: 0.7em;
    text-indent: 2em;
  }}
  h1 + p, h2 + p, h3 + p, h4 + p, hr + p {{
    text-indent: 2em;
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
    background-color: #333;
    color: white;
    font-weight: bold;
  }}
  tr:nth-child(even) {{
    background-color: #f5f5f5;
  }}
  em {{
    font-size: 10pt;
    color: #444;
  }}
  ul, ol {{
    margin-left: 2em;
    margin-bottom: 0.7em;
  }}
  li {{
    margin-bottom: 0.3em;
  }}
  strong {{
    font-weight: bold;
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
