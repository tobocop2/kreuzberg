package kreuzberg

import (
	"testing"
)

// pngMagic is the 8-byte header present in all valid PNG files.
var pngMagic = []byte{0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A}

func TestRenderPdfPagesHappyPath(t *testing.T) {
	dir := t.TempDir()
	path, err := writeValidPDFToFile(dir, "test.pdf")
	if err != nil {
		t.Fatalf("failed to write test PDF: %v", err)
	}

	pages, err := RenderPdfPages(path, 150)
	if err != nil {
		t.Fatalf("RenderPdfPages failed: %v", err)
	}

	if len(pages) < 1 {
		t.Fatal("expected at least one page")
	}

	for i, page := range pages {
		if len(page) == 0 {
			t.Fatalf("page %d is empty", i)
		}
		if len(page) < 8 {
			t.Fatalf("page %d too short to contain PNG header", i)
		}
		for j := 0; j < 8; j++ {
			if page[j] != pngMagic[j] {
				t.Fatalf("page %d does not have PNG magic bytes", i)
			}
		}
	}
}

func TestRenderPdfPageHappyPath(t *testing.T) {
	dir := t.TempDir()
	path, err := writeValidPDFToFile(dir, "test.pdf")
	if err != nil {
		t.Fatalf("failed to write test PDF: %v", err)
	}

	page, err := RenderPdfPage(path, 0, 150)
	if err != nil {
		t.Fatalf("RenderPdfPage failed: %v", err)
	}

	if len(page) == 0 {
		t.Fatal("rendered page is empty")
	}
	if len(page) < 8 {
		t.Fatal("rendered page too short to contain PNG header")
	}
	for j := 0; j < 8; j++ {
		if page[j] != pngMagic[j] {
			t.Fatal("rendered page does not have PNG magic bytes")
		}
	}
}

func TestRenderPdfPagesNonexistentFile(t *testing.T) {
	_, err := RenderPdfPages("/nonexistent/path/to/document.pdf", 150)
	if err == nil {
		t.Fatal("expected error for nonexistent file")
	}
}

func TestRenderPdfPageNonexistentFile(t *testing.T) {
	_, err := RenderPdfPage("/nonexistent/path/to/document.pdf", 0, 150)
	if err == nil {
		t.Fatal("expected error for nonexistent file")
	}
}

func TestRenderPdfPagesEmptyPath(t *testing.T) {
	_, err := RenderPdfPages("", 150)
	if err == nil {
		t.Fatal("expected error for empty path")
	}
}

func TestRenderPdfPageEmptyPath(t *testing.T) {
	_, err := RenderPdfPage("", 0, 150)
	if err == nil {
		t.Fatal("expected error for empty path")
	}
}
