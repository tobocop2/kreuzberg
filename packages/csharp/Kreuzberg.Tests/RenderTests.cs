using System;
using System.Collections.Generic;
using System.IO;
using Xunit;

namespace Kreuzberg.Tests;

public class RenderTests : TestBase
{
    private static readonly byte[] PngMagic = { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A };

    private static string GetTestPdfPath()
    {
        return NativeTestHelper.GetDocumentPath("pdf/tiny.pdf");
    }

    private static void AssertPngMagic(byte[] data)
    {
        Assert.True(data.Length >= 8, "Data too short for PNG header");
        for (int i = 0; i < 8; i++)
        {
            Assert.Equal(PngMagic[i], data[i]);
        }
    }

    [Fact]
    public void RenderPdfPages_HappyPath_ReturnsPngList()
    {
        var path = GetTestPdfPath();

        List<byte[]> pages = KreuzbergClient.RenderPdfPages(path);

        Assert.NotNull(pages);
        Assert.NotEmpty(pages);
        foreach (var page in pages)
        {
            Assert.NotEmpty(page);
            AssertPngMagic(page);
        }
    }

    [Fact]
    public void RenderPdfPage_HappyPath_ReturnsPng()
    {
        var path = GetTestPdfPath();

        byte[] page = KreuzbergClient.RenderPdfPage(path, 0);

        Assert.NotNull(page);
        Assert.NotEmpty(page);
        AssertPngMagic(page);
    }

    [Fact]
    public void RenderPdfPages_NonexistentFile_Throws()
    {
        Assert.ThrowsAny<Exception>(() =>
            KreuzbergClient.RenderPdfPages("/nonexistent/path/to/document.pdf"));
    }

    [Fact]
    public void RenderPdfPage_NonexistentFile_Throws()
    {
        Assert.ThrowsAny<Exception>(() =>
            KreuzbergClient.RenderPdfPage("/nonexistent/path/to/document.pdf", 0));
    }

    [Fact]
    public void RenderPdfPages_EmptyPath_ThrowsArgumentException()
    {
        Assert.Throws<ArgumentException>(() =>
            KreuzbergClient.RenderPdfPages(string.Empty));
    }

    [Fact]
    public void RenderPdfPage_EmptyPath_ThrowsArgumentException()
    {
        Assert.Throws<ArgumentException>(() =>
            KreuzbergClient.RenderPdfPage(string.Empty, 0));
    }
}
