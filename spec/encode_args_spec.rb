# frozen_string_literal: true

require 'stringio'

RSpec.describe 'Encode Arguments' do
  context 'without arguments' do
    it 'is a kind of LZMA::Encoder' do
      expect(LZMA.encode).to be_a_kind_of(LZMA::Encoder)
    end
  end

  context 'with io argument' do
    it 'is a kind of LZMA::Encoder' do
      expect(LZMA.encode(StringIO.new(String.new))).to be_a_kind_of(LZMA::Encoder)
    end
  end

  context 'with block' do
    it 'is a kind of String' do
      expect(LZMA.encode(&:outport)).to be_a_kind_of(String)
    end
  end

  context 'with io argument and block' do
    it 'returns the block result' do
      io = StringIO.new(String.new)
      expect(LZMA.encode(io) {|_| io}).to be(io)
    end
  end

  context 'with compression level' do
    it 'is a kind of LZMA::Encoder' do
      expect(LZMA.encode(StringIO.new(String.new), 9)).to be_a_kind_of(LZMA::Encoder)
    end
  end
end
