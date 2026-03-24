<?php

declare(strict_types=1);

namespace Kreuzberg\Tests;

use Kreuzberg\Config\ChunkingConfig;
use Kreuzberg\Config\ExtractionConfig;
use Kreuzberg\Kreuzberg;
use PHPUnit\Framework\TestCase;

class ChunkingIntegrationTest extends TestCase
{
    public function testChunkingReturnsChunksForMarkdown(): void
    {
        $path = tempnam(sys_get_temp_dir(), 'kreuzberg_') . '.md';
        file_put_contents($path, "# Hello\n\nWorld paragraph here.\n\n## Sub\n\nMore content.\n");

        try {
            $config = new ExtractionConfig(
                chunking: new ChunkingConfig(maxChars: 50)
            );
            $result = Kreuzberg::extractFileSync($path, $config);

            $this->assertNotNull($result->chunks, 'chunks is null — chunking feature likely not compiled');
        } finally {
            unlink($path);
        }
    }
}
