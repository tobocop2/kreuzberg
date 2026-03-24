package kreuzberg_test

import (
	"os"
	"path/filepath"
	"testing"

	kreuzberg "github.com/kreuzberg-dev/kreuzberg/packages/go/v4"
)

func TestChunking_ReturnsChunks(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "test.md")
	content := "# Hello\n\nWorld paragraph here with enough text.\n\n## Sub\n\nMore content here.\n"
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		t.Fatal(err)
	}

	maxChars := 50
	config := &kreuzberg.ExtractionConfig{
		Chunking: &kreuzberg.ChunkingConfig{
			MaxChars: &maxChars,
		},
	}
	result, err := kreuzberg.ExtractFileSync(path, config)
	if err != nil {
		t.Fatal(err)
	}
	if result.Chunks == nil {
		t.Fatal("chunks is nil — chunking feature likely not compiled")
	}
	if len(result.Chunks) < 1 {
		t.Errorf("expected at least 1 chunk, got %d", len(result.Chunks))
	}
}
