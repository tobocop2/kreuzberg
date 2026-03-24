# frozen_string_literal: true

require 'tempfile'

RSpec.describe 'Chunking integration' do
  it 'returns chunks for markdown file' do
    file = Tempfile.new(['test', '.md'])
    file.write("# Hello\n\nWorld paragraph here.\n\n## Sub\n\nMore content.\n")
    file.close

    config = Kreuzberg::Config::Extraction.new(
      chunking: Kreuzberg::Config::Chunking.new(max_chars: 50)
    )
    result = Kreuzberg.extract_file_sync(file.path, config: config)

    expect(result.chunks).not_to be_nil, 'chunks is nil — chunking feature likely not compiled'
  ensure
    file.unlink
  end
end
