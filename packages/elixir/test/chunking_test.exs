defmodule ChunkingTest do
  use ExUnit.Case

  @tag :integration
  test "chunking returns chunks for markdown file" do
    dir = System.tmp_dir!()
    path = Path.join(dir, "test_chunking.md")
    File.write!(path, "# Hello\n\nWorld paragraph here.\n\n## Sub\n\nMore content.\n")

    config = %{chunking: %{max_chars: 50}}
    {:ok, result} = Kreuzberg.extract_file(path, config)
    File.rm!(path)

    assert result.chunks != nil, "chunks is nil — chunking feature likely not compiled"
  end
end
