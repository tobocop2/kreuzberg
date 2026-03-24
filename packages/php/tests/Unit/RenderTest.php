<?php

declare(strict_types=1);

namespace Kreuzberg\Tests\Unit;

use Kreuzberg\Exceptions\KreuzbergException;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\TestCase;

use function Kreuzberg\render_pdf_page;
use function Kreuzberg\render_pdf_pages;

/**
 * Tests for PDF rendering API.
 */
final class RenderTest extends TestCase
{
    private const PNG_MAGIC = "\x89PNG\r\n\x1a\n";

    private static function getTestPdfPath(): string
    {
        $dir = __DIR__;
        while ($dir !== '/' && $dir !== '') {
            $candidate = $dir . '/test_documents/pdf/tiny.pdf';
            if (file_exists($candidate)) {
                return $candidate;
            }
            $dir = dirname($dir);
        }

        return '';
    }

    #[Test]
    public function it_renders_all_pages_of_a_valid_pdf_as_png(): void
    {
        $pdfPath = self::getTestPdfPath();
        if ($pdfPath === '' || !file_exists($pdfPath)) {
            $this->markTestSkipped('Test PDF not found');
        }

        $pages = render_pdf_pages($pdfPath);

        $this->assertIsArray($pages);
        $this->assertNotEmpty($pages);
        foreach ($pages as $pageBytes) {
            $this->assertIsString($pageBytes);
            $this->assertGreaterThan(0, strlen($pageBytes));
            $this->assertStringStartsWith(self::PNG_MAGIC, $pageBytes, 'Expected PNG magic bytes');
        }
    }

    #[Test]
    public function it_renders_a_single_page_of_a_valid_pdf_as_png(): void
    {
        $pdfPath = self::getTestPdfPath();
        if ($pdfPath === '' || !file_exists($pdfPath)) {
            $this->markTestSkipped('Test PDF not found');
        }

        $pageBytes = render_pdf_page($pdfPath, 0);

        $this->assertIsString($pageBytes);
        $this->assertGreaterThan(0, strlen($pageBytes));
        $this->assertStringStartsWith(self::PNG_MAGIC, $pageBytes, 'Expected PNG magic bytes');
    }

    #[Test]
    public function it_throws_for_nonexistent_file_pages(): void
    {
        $this->expectException(KreuzbergException::class);
        render_pdf_pages('/nonexistent/path/to/document.pdf');
    }

    #[Test]
    public function it_throws_for_nonexistent_file_page(): void
    {
        $this->expectException(KreuzbergException::class);
        render_pdf_page('/nonexistent/path/to/document.pdf', 0);
    }
}
