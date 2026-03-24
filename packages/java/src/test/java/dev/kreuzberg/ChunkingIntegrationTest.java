package dev.kreuzberg;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class ChunkingIntegrationTest {

    @TempDir
    Path tempDir;

    @Test
    void chunkingReturnsChunksForMarkdown() throws IOException, KreuzbergException {
        Path file = tempDir.resolve("test.md");
        Files.writeString(file, "# Hello\n\nWorld paragraph here.\n\n## Sub\n\nMore content.\n");

        ExtractionConfig config = ExtractionConfig.builder()
                .chunking(ChunkingConfig.builder().maxChars(50).build())
                .build();
        ExtractionResult result = Kreuzberg.extractFileSync(file.toString(), config);

        assertThat(result.getChunks())
                .as("chunks should not be null — chunking feature likely not compiled")
                .isNotNull();
    }
}
