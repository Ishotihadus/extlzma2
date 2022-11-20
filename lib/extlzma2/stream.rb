# frozen_string_literal: true

module LZMA
  class Stream
    def self.encoder(*args, **opts)
      if args.empty?
        Encoder.new(Filter::LZMA2.new(LZMA::PRESET_DEFAULT), **opts)
      elsif args.size == 1 && args[0].is_a?(Numeric)
        Encoder.new(Filter::LZMA2.new(args[0]), **opts)
      else
        Encoder.new(*args, **opts)
      end
    end

    def self.decoder(*args)
      if args.empty?
        Decoder.new(Filter::LZMA2.new(LZMA::PRESET_DEFAULT))
      elsif args.size == 1 && args[0].is_a?(Numeric)
        Decoder.new(Filter::LZMA2.new(args[0]))
      else
        Decoder.new(*args)
      end
    end

    def self.auto_decoder(*args)
      AutoDecoder.new(*args)
    end

    def self.raw_encoder(*args)
      if args.empty?
        RawEncoder.new(Filter::LZMA2.new(LZMA::PRESET_DEFAULT))
      elsif args.size == 1 && args[0].is_a?(Numeric)
        RawEncoder.new(Filter::LZMA2.new(args[0]))
      else
        RawEncoder.new(*args)
      end
    end

    def self.raw_decoder(*args)
      if args.empty?
        RawDecoder.new(Filter::LZMA2.new(LZMA::PRESET_DEFAULT))
      elsif args.size == 1 && args[0].is_a?(Numeric)
        RawDecoder.new(Filter::LZMA2.new(args[0]))
      else
        RawDecoder.new(*args)
      end
    end
  end
end
