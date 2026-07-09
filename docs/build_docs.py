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

here = Path(__file__).parent
for src_name, out_path in DOCS.items():
    src = (here / src_name).read_text()
    # Join hard-wrapped lines into single-line paragraphs; <br> stays.
    flat = re.sub(r"\n(?!<)", " ", src)
    flat = re.sub(r"[ \t]{2,}", " ", flat)
    with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False) as tmp:
        tmp.write(flat)
        tmp_path = tmp.name
    subprocess.run(["textutil", "-convert", "docx", "-output", out_path,
                    tmp_path], check=True)
    Path(tmp_path).unlink()
    print(f"built {out_path}")
