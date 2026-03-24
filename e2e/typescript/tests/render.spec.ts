// Tests for PDF rendering API.

import { existsSync } from "node:fs";
import { renderPdfPageSync, renderPdfPagesSync } from "@kreuzberg/node";
import { describe, expect, it } from "vitest";
import { resolveDocument } from "./helpers.js";

const PNG_MAGIC = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

describe("pdf rendering", () => {
	it("renderPdfPagesSync renders all pages as PNG buffers", () => {
		const documentPath = resolveDocument("pdf/tiny.pdf");
		if (!existsSync(documentPath)) {
			console.warn("Skipping: test PDF not found at", documentPath);
			return;
		}

		const pages = renderPdfPagesSync(documentPath);

		expect(Array.isArray(pages)).toBe(true);
		expect(pages.length).toBeGreaterThanOrEqual(1);
		for (const page of pages) {
			expect(Buffer.isBuffer(page)).toBe(true);
			expect(page.length).toBeGreaterThan(0);
			expect(page.subarray(0, 8).equals(PNG_MAGIC)).toBe(true);
		}
	});

	it("renderPdfPageSync renders a single page as PNG buffer", () => {
		const documentPath = resolveDocument("pdf/tiny.pdf");
		if (!existsSync(documentPath)) {
			console.warn("Skipping: test PDF not found at", documentPath);
			return;
		}

		const page = renderPdfPageSync(documentPath, 0);

		expect(Buffer.isBuffer(page)).toBe(true);
		expect(page.length).toBeGreaterThan(0);
		expect(page.subarray(0, 8).equals(PNG_MAGIC)).toBe(true);
	});

	it("renderPdfPagesSync throws for nonexistent file", () => {
		expect(() => {
			renderPdfPagesSync("/nonexistent/path/to/document.pdf");
		}).toThrow();
	});

	it("renderPdfPageSync throws for nonexistent file", () => {
		expect(() => {
			renderPdfPageSync("/nonexistent/path/to/document.pdf", 0);
		}).toThrow();
	});
});
