# frozen_string_literal: true

require 'stringio'

RSpec.describe 'Decode Arguments' do
  context 'without arguments' do
    it 'raises ArgumentError' do
      expect {LZMA.decode}.to raise_error(ArgumentError)
    end
  end

  context 'with an invalid argument' do
    it 'raises NoMethodError' do
      expect {LZMA.decode(nil).read}.to raise_error(NoMethodError)
    end
  end

  context 'with invalid string' do
    it 'raises LZMA::BufError' do
      expect {LZMA.decode('').read}.to raise_error(LZMA::BufError)
    end
  end
end
