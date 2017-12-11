# frozen_string_literal: true

require 'helper'
require 'peddler/flat_file_parser'

class TestPeddlerFlatFileParser < MiniTest::Test
  def test_parses_data
    body = build_body("Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n",
                      encoding: Encoding::ASCII_8BIT)
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    assert_kind_of CSV::Table, parser.parse
  end

  def test_parses_data_a_line_at_a_time
    body = build_body("Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n",
                      encoding: Encoding::ASCII_8BIT)
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    counter = 0
    parser.parse { counter += 1 }
    assert counter > 0
  end

  def test_summarises
    body = build_body("Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n",
                      encoding: Encoding::ASCII_8BIT)
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    refute_empty parser.records_count
  end

  def test_summarises_non_english_reports
    body = build_body("Riepilogo elaborazione feed:\n\tNumero record elaborati\t\t1\n\tNumero record elaborati con successo\t\t1\n\n",
                      encoding: 'Cp1252')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    refute_empty parser.records_count
  end

  def test_validates
    body = build_body("Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n",
                      encoding: Encoding::ASCII_8BIT)
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    assert parser.valid?
  end

  def test_handles_reports_without_a_summary
    response = OpenStruct.new(body: "Foo\nBar\n")
    parser = Peddler::FlatFileParser.new(response, 'ISO-8859-1')
    refute_empty parser.content
  end

  def test_handles_japanese_flat_files
    body = build_body("Foo\nこんにちは\n", encoding: Encoding::SHIFT_JIS)
    parser = Peddler::FlatFileParser.new(build_mock_response(body), Encoding::WINDOWS_31J)
    assert_equal 'こんにちは', parser.parse[0]['Foo']
  end

  def test_handles_japanese_curly_braces
    body = build_body("Foo\n〝\n", encoding: Encoding::WINDOWS_31J)
    parser = Peddler::FlatFileParser.new(build_mock_response(body), Encoding::WINDOWS_31J)
    assert_equal '〝', parser.parse[0]['Foo']
  end

  def test_handles_latin_1_flat_files
    body = build_body("Foo\n™\n", encoding: 'Cp1252')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), Encoding::CP1252)
    assert_equal '™', parser.parse['Foo'][0]
  end

  def test_handles_undefined_characters
    body = "Foo\n\xFF\n".dup
    body.force_encoding(Encoding::ASCII_8BIT)
    parser = Peddler::FlatFileParser.new(build_mock_response(body), Encoding::ASCII_8BIT)
    assert_equal '�', parser.parse['Foo'][0]
  end

  def test_handles_utf8_flat_files
    body = "Foo\nfür\n"
    parser = Peddler::FlatFileParser.new(build_mock_response(body, ascii: false), Encoding::CP1252)
    assert_equal 'für', parser.parse['Foo'][0]
  end

  private

  def build_body(str, encoding:)
    str.dup.encode(encoding)
  end

  def build_mock_response(body, ascii: true)
    body.force_encoding(Encoding::ASCII_8BIT) if ascii
    headers = {
      'Content-MD5' => Digest::MD5.base64digest(body)
    }

    OpenStruct.new(body: body, headers: headers)
  end
end
