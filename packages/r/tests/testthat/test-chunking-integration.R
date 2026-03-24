test_that("chunking returns chunks for markdown", {
  tmp <- tempfile(fileext = ".md")
  writeLines("# Hello\n\nWorld paragraph here.\n\n## Sub\n\nMore content.", tmp)
  on.exit(unlink(tmp))

  config <- list(chunking = list(max_chars = 50L))
  result <- extract_file_sync(tmp, config = config)

  expect_false(is.null(result$chunks), info = "chunks is NULL — chunking feature likely not compiled")
})
