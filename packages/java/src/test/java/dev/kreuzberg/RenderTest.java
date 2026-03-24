package dev.kreuzberg;

import static org.junit.jupiter.api.Assertions.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

/** Tests for PDF rendering API. */
class RenderTest {

	private static final byte[] PNG_MAGIC = {
		(byte) 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A
	};

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

	private static void assertPngMagic(byte[] data) {
		assertTrue(data.length >= 8, "Data too short for PNG header");
		for (int i = 0; i < 8; i++) {
			assertEquals(PNG_MAGIC[i], data[i], "PNG magic byte mismatch at index " + i);
		}
	}

	@Test
	void testRenderPdfPagesHappyPath() throws IOException, KreuzbergException {
		Path testPdf = getTestPdf();
		if (!Files.exists(testPdf)) {
			return; // skip if test document unavailable
		}

		List<byte[]> pages = Kreuzberg.renderPdfPages(testPdf, 150);

		assertNotNull(pages, "Pages list should not be null");
		assertFalse(pages.isEmpty(), "Should render at least one page");
		for (byte[] page : pages) {
			assertTrue(page.length > 0, "Page should not be empty");
			assertPngMagic(page);
		}
	}

	@Test
	void testRenderPdfPageHappyPath() throws IOException, KreuzbergException {
		Path testPdf = getTestPdf();
		if (!Files.exists(testPdf)) {
			return; // skip if test document unavailable
		}

		byte[] page = Kreuzberg.renderPdfPage(testPdf, 0, 150);

		assertNotNull(page, "Page should not be null");
		assertTrue(page.length > 0, "Page should not be empty");
		assertPngMagic(page);
	}

	@Test
	void testRenderPdfPagesNonexistentFile() {
		Path nonexistent = Path.of("/nonexistent/path/to/document.pdf");
		assertThrows(IOException.class, () -> {
			Kreuzberg.renderPdfPages(nonexistent, 150);
		}, "Should throw IOException for nonexistent file");
	}

	@Test
	void testRenderPdfPageNonexistentFile() {
		Path nonexistent = Path.of("/nonexistent/path/to/document.pdf");
		assertThrows(IOException.class, () -> {
			Kreuzberg.renderPdfPage(nonexistent, 0, 150);
		}, "Should throw IOException for nonexistent file");
	}
}
