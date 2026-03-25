// Hand-written binding-specific edge case tests for PDF rendering.
// Happy-path render tests are auto-generated from fixtures in e2e/.
// These tests cover error handling, validation, and lifecycle patterns
// that vary per language and can't be generated uniformly.

using System;
using System.Collections.Generic;
using System.IO;
using Xunit;

namespace Kreuzberg.Tests;

public class RenderTests : TestBase
{
    private static string GetTestPdfPath()
    {
        return NativeTestHelper.GetDocumentPath("pdf/tiny.pdf");
    }

    [Fact]
    public void RenderingMethodsExist()
    {
        Assert.NotNull(typeof(KreuzbergClient).GetMethod("RenderPdfPage"));
        Assert.NotNull(typeof(PdfPageIterator));
    }

    [Fact]
    public void RenderPdfPage_NonexistentFile_Throws()
    {
        Assert.Throws<KreuzbergException>(() =>
            KreuzbergClient.RenderPdfPage("/nonexistent/path/to/document.pdf", 0));
    }

    [Fact]
    public void RenderPdfPage_EmptyPath_ThrowsArgumentException()
    {
        Assert.Throws<ArgumentException>(() =>
            KreuzbergClient.RenderPdfPage(string.Empty, 0));
    }

    [Fact]
    public void RenderPdfPage_IndexOutOfBounds_Throws()
    {
        var path = GetTestPdfPath();

        Assert.ThrowsAny<Exception>(() =>
            KreuzbergClient.RenderPdfPage(path, 9999));
    }

    [Fact]
    public void RenderPdfPage_NegativeIndex_ThrowsArgumentOutOfRange()
    {
        var path = GetTestPdfPath();

        Assert.Throws<ArgumentOutOfRangeException>(() =>
            KreuzbergClient.RenderPdfPage(path, -1));
    }

    [Fact]
    public void PdfPageIterator_Dispose_IsSafe()
    {
        var path = GetTestPdfPath();

        var iter = PdfPageIterator.Open(path);
        iter.Dispose();
        // Double dispose should be safe
        iter.Dispose();
        // After dispose, PageCount returns 0
        Assert.Equal(0, iter.PageCount);
    }

    [Fact]
    public void PdfPageIterator_NonexistentFile_Throws()
    {
        Assert.Throws<KreuzbergException>(() =>
            PdfPageIterator.Open("/nonexistent/path/to/document.pdf"));
    }

    [Fact]
    public void PdfPageIterator_EmptyPath_ThrowsArgumentException()
    {
        Assert.Throws<ArgumentException>(() =>
            PdfPageIterator.Open(string.Empty));
    }
}
