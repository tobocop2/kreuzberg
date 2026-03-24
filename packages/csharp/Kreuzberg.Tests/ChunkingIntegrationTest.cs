using System;
using System.IO;
using Xunit;

namespace Kreuzberg.Tests;

public class ChunkingIntegrationTest : TestBase
{
    [Fact]
    public void Chunking_ReturnsChunks_ForMarkdown()
    {
        var path = Path.GetTempFileName() + ".md";
        File.WriteAllText(path, "# Hello\n\nWorld paragraph here.\n\n## Sub\n\nMore content.\n");

        try
        {
            var config = new ExtractionConfig
            {
                Chunking = new ChunkingConfig { MaxChars = 50 }
            };
            var result = KreuzbergClient.ExtractFileSync(path, config);

            Assert.NotNull(result.Chunks); // chunking feature likely not compiled if null
        }
        finally
        {
            File.Delete(path);
        }
    }
}
