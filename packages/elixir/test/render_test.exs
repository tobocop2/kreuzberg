defmodule KreuzbergTest.RenderTest do
  use ExUnit.Case

  @png_magic <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>

  defp get_test_pdf_path do
    repo_root = get_repo_root()

    possible_paths = [
      Path.join([repo_root, "test_documents", "pdf", "tiny.pdf"]),
      Path.join([repo_root, "test_documents", "tiny.pdf"])
    ]

    Enum.find_value(possible_paths, :error, fn path ->
      if File.exists?(path), do: {:ok, path}
    end)
  end

  defp get_repo_root do
    cwd = File.cwd!()
    Path.join([cwd, "..", "..", ".."])
  end

  describe "render_pdf_pages/2" do
    test "renders all pages of a valid PDF as PNG bytes" do
      case get_test_pdf_path() do
        {:ok, path} ->
          {:ok, pages} = Kreuzberg.render_pdf_pages(path)

          assert is_list(pages)
          assert length(pages) >= 1

          Enum.each(pages, fn page_bytes ->
            assert is_binary(page_bytes)
            assert byte_size(page_bytes) > 0
            assert <<@png_magic, _rest::binary>> = page_bytes
          end)

        :error ->
          IO.puts("Skipping render_pdf_pages test: test PDF not found")
      end
    end

    test "returns error for nonexistent file" do
      result = Kreuzberg.render_pdf_pages("/nonexistent/path/to/document.pdf")
      assert {:error, _reason} = result
    end
  end

  describe "render_pdf_page/3" do
    test "renders a single page of a valid PDF as PNG bytes" do
      case get_test_pdf_path() do
        {:ok, path} ->
          {:ok, page_bytes} = Kreuzberg.render_pdf_page(path, 0)

          assert is_binary(page_bytes)
          assert byte_size(page_bytes) > 0
          assert <<@png_magic, _rest::binary>> = page_bytes

        :error ->
          IO.puts("Skipping render_pdf_page test: test PDF not found")
      end
    end

    test "returns error for nonexistent file" do
      result = Kreuzberg.render_pdf_page("/nonexistent/path/to/document.pdf", 0)
      assert {:error, _reason} = result
    end
  end
end
