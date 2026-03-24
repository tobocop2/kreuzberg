test_that("render_pdf_pages renders a valid PDF to PNG bytes", {
  repo_root <- normalizePath(file.path(getwd(), "..", "..", "..", ".."), mustWork = FALSE)
  pdf_path <- file.path(repo_root, "test_documents", "pdf", "tiny.pdf")

  if (!file.exists(pdf_path)) {
    skip(paste("Test PDF not found at", pdf_path))
  }

  pages <- render_pdf_pages(pdf_path)

  expect_true(is.list(pages))
  expect_true(length(pages) >= 1L)
  for (page_bytes in pages) {
    expect_true(is.raw(page_bytes))
    expect_true(length(page_bytes) > 0L)
    # Check PNG magic bytes
    expect_equal(page_bytes[1:8], as.raw(c(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a)))
  }
})

test_that("render_pdf_page renders a single page to PNG bytes", {
  repo_root <- normalizePath(file.path(getwd(), "..", "..", "..", ".."), mustWork = FALSE)
  pdf_path <- file.path(repo_root, "test_documents", "pdf", "tiny.pdf")

  if (!file.exists(pdf_path)) {
    skip(paste("Test PDF not found at", pdf_path))
  }

  page_bytes <- render_pdf_page(pdf_path, 0L)

  expect_true(is.raw(page_bytes))
  expect_true(length(page_bytes) > 0L)
  # Check PNG magic bytes
  expect_equal(page_bytes[1:8], as.raw(c(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a)))
})

test_that("render_pdf_pages errors on nonexistent file", {
  expect_error(render_pdf_pages("/nonexistent/path/to/document.pdf"))
})

test_that("render_pdf_page errors on nonexistent file", {
  expect_error(render_pdf_page("/nonexistent/path/to/document.pdf", 0L))
})
