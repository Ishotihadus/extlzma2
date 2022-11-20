# frozen_string_literal: true

require 'stringio'

module LZMA
  module Aux
    def self.encode(src, encoder)
      if src.is_a?(String)
        s = Encoder.new(encoder, String.new)
        s << src
        s.close
        return s.outport
      end

      s = Encoder.new(encoder, (src || String.new))
      return s unless block_given?

      begin
        yield(s)
      ensure
        s.close
      end
    end

    def self.decode(src, decoder)
      return decode(StringIO.new(src), decoder, &:read) if src.is_a?(String)

      s = Decoder.new(decoder, src)
      return s unless block_given?

      begin
        yield(s)
      ensure
        begin
          s.close
        rescue StandardError
          nil
        end
      end
    end
  end
end
