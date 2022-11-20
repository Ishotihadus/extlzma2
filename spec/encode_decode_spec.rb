# frozen_string_literal: true

require 'securerandom'

RSpec.describe 'Encode and Decode' do
  SAMPLES = {
    'empty' => '',
    '\\0 (small size)' => "\0".b * 400,
    '\\0 (big size)' => "\0".b * 12_000_000,
    '\\xaa (small size)' => "\xaa".b * 400,
    '\\xaa (big size)' => "\xaa".b * 12_000_000,
    'random (small size)' => SecureRandom.bytes(400),
    'random (big size)' => SecureRandom.bytes(12_000_000)
  }.freeze

  SAMPLES.each do |name, sample|
    context name do
      it 'successfully compresses and decompresses' do
        compressed = LZMA.encode(sample)
        decompressed = LZMA.decode(compressed)
        expect(decompressed).to eq(sample)
      end
    end
  end
end
