#!/usr/bin/env python3
"""Builds the Word versions of the design docs.

textutil keeps the source HTML's hard line-wraps as soft breaks, which reads
as strange spacing in Word. This script collapses intra-paragraph newlines
(everything except <br>) before converting, so Word gets clean flowing
paragraphs.

Usage: python3 docs/build_docs.py   (from the game/ directory)
"""
import re
import subprocess
import tempfile
from pathlib import Path

DOCS = {
    "master.html": "/Users/zipples/Documents/DoD/DoD Master Document.docx",
    "changelog.html": "/Users/zipples/Documents/DoD/DoD Changelog.docx",
}

# The Word exports read in Arial at size 14 (user preference, 2026-07-09).
# Headings stay proportionally larger but switch to Arial too. textutil maps
# CSS px 1:1 to Word points (pt units get inflated by 4/3), so 14px = size 14.
FONT_STYLE = (
    "<style>"
    "body, p, li, td, th, dd, dt { font-family: Arial, Helvetica, sans-serif;"
    " font-size: 14px; }"
    "h1, h2, h3, h4 { font-family: Arial, Helvetica, sans-serif; }"
    "code { font-family: Arial, Helvetica, sans-serif; font-size: 14px; }"
    "</style>"
)

here = Path(__file__).parent
for src_name, out_path in DOCS.items():
    src = (here / src_name).read_text()
    # Join hard-wrapped lines into single-line paragraphs; <br> stays.
    flat = re.sub(r"\n(?!<)", " ", src)
    flat = re.sub(r"[ \t]{2,}", " ", flat)
    flat = flat.replace("</head>", FONT_STYLE + "</head>", 1)
    with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False) as tmp:
        tmp.write(flat)
        tmp_path = tmp.name
    subprocess.run(["textutil", "-convert", "docx", "-output", out_path,
                    tmp_path], check=True)
    Path(tmp_path).unlink()
    print(f"built {out_path}")
