// Hand-written binding-specific edge case tests for PDF rendering.
// Happy-path render tests are auto-generated from fixtures in e2e/.
// These tests cover error handling, validation, and lifecycle patterns
// that vary per language and can't be generated uniformly.

package dev.kreuzberg;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class RenderTest {

	private Path getTestPdf() {
		Path repoRoot = Path.of("").toAbsolutePath();
		// Walk up to find test_documents
		Path current = repoRoot;
		while (current != null) {
			Path candidate = current.resolve("test_documents/pdf/tiny.pdf");
			if (Files.exists(candidate)) {
				return candidate;
			}
			current = current.getParent();
		}
		return repoRoot.resolve("test_documents/pdf/tiny.pdf");
	}

	@Test
	void testRenderingMethodsExist() throws Exception {
		// Verify methods exist via reflection
		assertNotNull(Kreuzberg.class.getMethod("renderPdfPage", Path.class, int.class, int.class));
	}

	@Test
	void testRenderPdfPageNonexistentFile() {
		Path nonexistent = Path.of("/nonexistent/path/to/document.pdf");
		assertThrows(IOException.class, () -> {
			Kreuzberg.renderPdfPage(nonexistent, 0, 150);
		}, "Should throw IOException for nonexistent file");
	}

	@Test
	void testRenderPdfPageIndexOutOfBounds() {
		Path testPdf = getTestPdf();
		assumeTrue(Files.exists(testPdf),
				"Test PDF not found: " + testPdf.toAbsolutePath());

		assertThrows(Exception.class, () -> {
			Kreuzberg.renderPdfPage(testPdf, 9999, 150);
		}, "Should throw for out-of-bounds page index");
	}

	@Test
	void testRenderPdfPageNegativeIndex() {
		Path testPdf = getTestPdf();
		assumeTrue(Files.exists(testPdf),
				"Test PDF not found: " + testPdf.toAbsolutePath());

		assertThrows(IllegalArgumentException.class, () -> {
			Kreuzberg.renderPdfPage(testPdf, -1, 150);
		}, "Should throw IllegalArgumentException for negative page index");
	}

	@Test
	void testPdfPageIteratorClose() throws Exception {
		Path testPdf = getTestPdf();
		assumeTrue(Files.exists(testPdf),
				"Test PDF not found: " + testPdf.toAbsolutePath());

		var iter = Kreuzberg.PdfPageIterator.open(testPdf, 150);
		iter.close();
		// Double close should be safe
		iter.close();
		// After close, pageCount returns 0
		assertEquals(0, iter.pageCount(), "pageCount after close should be 0");
		// After close, hasNext returns false
		assertFalse(iter.hasNext(), "hasNext after close should be false");
	}

	@Test
	void testPdfPageIteratorNonexistentFile() {
		Path nonexistent = Path.of("/nonexistent/path/to/document.pdf");
		assertThrows(IOException.class, () -> {
			Kreuzberg.PdfPageIterator.open(nonexistent, 150);
		}, "Should throw IOException for nonexistent file");
	}
}
