"""Tests for PDF rendering API."""
from __future__ import annotations

import pytest

from kreuzberg import render_pdf_page, render_pdf_pages

from . import helpers

PNG_MAGIC = b"\x89PNG\r\n\x1a\n"


def test_render_pdf_pages_happy_path() -> None:
    """Rendering all pages of a valid PDF returns a list of PNG-encoded bytes."""
    document_path = helpers.resolve_document("pdf/tiny.pdf")
    if not document_path.exists():
        pytest.skip(f"Missing test document at {document_path}")

    pages = render_pdf_pages(document_path)

    assert isinstance(pages, list)
    assert len(pages) >= 1
    for page_bytes in pages:
        assert isinstance(page_bytes, bytes)
        assert len(page_bytes) > 0
        assert page_bytes[:8] == PNG_MAGIC, "Expected PNG magic bytes"


def test_render_pdf_page_happy_path() -> None:
    """Rendering a single page of a valid PDF returns PNG-encoded bytes."""
    document_path = helpers.resolve_document("pdf/tiny.pdf")
    if not document_path.exists():
        pytest.skip(f"Missing test document at {document_path}")

    page_bytes = render_pdf_page(document_path, 0)

    assert isinstance(page_bytes, bytes)
    assert len(page_bytes) > 0
    assert page_bytes[:8] == PNG_MAGIC, "Expected PNG magic bytes"


def test_render_pdf_pages_nonexistent_file() -> None:
    """Rendering a nonexistent file raises an error."""
    with pytest.raises(Exception):
        render_pdf_pages("/nonexistent/path/to/document.pdf")


def test_render_pdf_page_nonexistent_file() -> None:
    """Rendering a single page from a nonexistent file raises an error."""
    with pytest.raises(Exception):
        render_pdf_page("/nonexistent/path/to/document.pdf", 0)
