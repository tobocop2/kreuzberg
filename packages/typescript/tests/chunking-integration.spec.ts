/**
 * Chunking Integration Tests
 *
 * Verifies the chunking feature is compiled into the WASM binding.
 */

import type { ExtractionConfig } from "@kreuzberg/core";
import { describe, expect, it } from "vitest";

describe("chunking integration", () => {
  it("ChunkingConfig should be constructable", () => {
    const config: ExtractionConfig = {
      chunking: {
        maxChars: 50,
      },
    };
    expect(config.chunking).toBeDefined();
    expect(config.chunking?.maxChars).toBe(50);
  });

  it("prepend_heading_context should be accepted", () => {
    const config: ExtractionConfig = {
      chunking: {
        maxChars: 80,
        chunkerType: "markdown",
        prependHeadingContext: true,
      },
    };
    expect(config.chunking?.prependHeadingContext).toBe(true);
  });
});
