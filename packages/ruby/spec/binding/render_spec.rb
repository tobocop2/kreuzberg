# Hand-written binding-specific edge case tests for PDF rendering.
# Happy-path render tests are auto-generated from fixtures in e2e/.
# These tests cover error handling, validation, and lifecycle patterns
# that vary per language and can't be generated uniformly.

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'PDF Rendering' do
  it 'exposes rendering methods' do
    expect(Kreuzberg).to respond_to(:render_pdf_page)
    expect(Kreuzberg).to respond_to(:render_pdf_pages_iter)
  end

  describe '.render_pdf_page' do
    it 'raises an error for a nonexistent file' do
      expect {
        Kreuzberg.render_pdf_page('/nonexistent/path/to/document.pdf', 0)
      }.to raise_error(Kreuzberg::Errors::IOError)
    end

    it 'raises an error for an out-of-bounds page index' do
      pdf_path = test_document_path('pdf/tiny.pdf')
      skip 'Test PDF not available' unless File.exist?(pdf_path)

      expect {
        Kreuzberg.render_pdf_page(pdf_path, 9999)
      }.to raise_error(StandardError)
    end
  end

  describe '.render_pdf_page with negative index' do
    it 'raises ArgumentError for a negative page index' do
      pdf_path = test_document_path('pdf/tiny.pdf')
      skip 'Test PDF not available' unless File.exist?(pdf_path)

      expect {
        Kreuzberg.render_pdf_page(pdf_path, -1)
      }.to raise_error(ArgumentError)
    end
  end

  describe '.render_pdf_pages_iter' do
    it 'raises an error for a nonexistent file' do
      expect {
        Kreuzberg.render_pdf_pages_iter('/nonexistent/path/to/document.pdf') { |_, _| }
      }.to raise_error(Kreuzberg::Errors::IOError)
    end
  end
end
