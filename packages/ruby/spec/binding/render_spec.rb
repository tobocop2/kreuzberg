# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'PDF Rendering' do
  describe '.render_pdf_pages' do
    it 'renders all pages of a valid PDF as PNG bytes' do
      pdf_path = test_document_path('pdf/tiny.pdf')

      begin
        pages = Kreuzberg.render_pdf_pages(pdf_path)

        expect(pages).to be_an(Array)
        expect(pages).not_to be_empty
        pages.each do |page_bytes|
          expect(page_bytes).to be_a(String)
          expect(page_bytes.length).to be > 0
          expect(page_bytes.bytes[0..7]).to eq([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
        end
      rescue Kreuzberg::Errors::IOError
        skip 'Test PDF not available'
      end
    end

    it 'raises an error for a nonexistent file' do
      expect {
        Kreuzberg.render_pdf_pages('/nonexistent/path/to/document.pdf')
      }.to raise_error(Kreuzberg::Errors::IOError)
    end
  end

  describe '.render_pdf_page' do
    it 'renders a single page of a valid PDF as PNG bytes' do
      pdf_path = test_document_path('pdf/tiny.pdf')

      begin
        page_bytes = Kreuzberg.render_pdf_page(pdf_path, 0)

        expect(page_bytes).to be_a(String)
        expect(page_bytes.length).to be > 0
        expect(page_bytes.bytes[0..7]).to eq([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
      rescue Kreuzberg::Errors::IOError
        skip 'Test PDF not available'
      end
    end

    it 'raises an error for a nonexistent file' do
      expect {
        Kreuzberg.render_pdf_page('/nonexistent/path/to/document.pdf', 0)
      }.to raise_error(Kreuzberg::Errors::IOError)
    end
  end
end
