"""Integration test for chunking — verifies the chunking feature is compiled in."""

import os
import tempfile

import pytest

from kreuzberg import ChunkingConfig, ExtractionConfig, extract_file_sync


@pytest.fixture()
def markdown_file():
    content = (
        "# Getting Started\n\n"
        "This is the introduction to the project with enough text to exceed the chunk limit.\n\n"
        "## Installation\n\n"
        "Follow these steps to install the software on your machine.\n\n"
        "## Usage\n\n"
        "Run the application with your configuration.\n"
    )
    with tempfile.NamedTemporaryFile(mode="w", suffix=".md", delete=False) as f:
        f.write(content)
        path = f.name
    yield path
    os.unlink(path)


def test_chunking_returns_chunks(markdown_file: str) -> None:
    """Chunking must produce actual chunks, not None."""
    config = ExtractionConfig(chunking=ChunkingConfig(max_chars=80))
    result = extract_file_sync(markdown_file, config=config)
    assert result.chunks is not None, "chunks is None — chunking feature likely not compiled"
    assert len(result.chunks) > 1


def test_prepend_heading_context(markdown_file: str) -> None:
    """With prepend_heading_context=True, chunks should contain heading paths."""
    config = ExtractionConfig(
        chunking=ChunkingConfig(
            max_chars=80,
            chunker_type="markdown",
            prepend_heading_context=True,
        )
    )
    result = extract_file_sync(markdown_file, config=config)
    assert result.chunks is not None, "chunks is None — chunking feature likely not compiled"
    contents = [c.content for c in result.chunks]
    assert any("Getting Started" in c for c in contents)
