# frozen_string_literal: true

module LZMA
  class Filter
    def self.lzma1(*args)
      LZMA1.new(*args)
    end

    def self.lzma2(*args)
      LZMA2.new(*args)
    end

    def self.delta(*args)
      Delta.new(*args)
    end
  end
end
