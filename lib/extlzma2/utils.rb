# frozen_string_literal: true

module LZMA
  module Utils
    def self.crc32_digest(seq, init = 0)
      [Utils.crc32(seq, init)].pack('N')
    end

    def self.crc32_hexdigest(seq, init = 0)
      format('%08X', Utils.crc32(seq, init))
    end

    def self.crc64_digest(seq, init = 0)
      [Utils.crc64(seq, init)].pack('Q>')
    end

    def self.crc64_hexdigest(seq, init = 0)
      format('%016X', Utils.crc64(seq, init))
    end

    CRC32 = Struct.new(:state, :init) do
      def initialize(state = 0)
        state = state.to_i
        super(state, state)
      end

      def update(data)
        self.state = Utils.crc32(data, state)
        self
      end

      alias_method :<<, :update

      def finish
        self
      end

      def reset
        self.state = init
        self
      end

      def digest
        [state].pack('N')
      end

      def hexdigest
        format('%08x', state)
      end

      alias_method :to_s, :hexdigest

      def to_str
        "CRC32 <#{hexdigest}>"
      end

      alias_method :inspect, :to_str
    end

    CRC64 = Struct.new(:state, :init) do
      def initialize(state = 0)
        state = state.to_i
        super(state, state)
      end

      def update(data)
        self.state = Utils.crc64(data, state)
        self
      end

      alias_method :<<, :update

      def finish
        self
      end

      def reset
        self.state = init
        self
      end

      def digest
        [state].pack('Q>')
      end

      def hexdigest
        '%016x' % state
      end

      alias_method :to_s, :hexdigest

      def to_str
        "CRC64 <#{hexdigest}>"
      end

      alias_method :inspect, :to_str
    end

    def raise_err(lzma_ret, mesg = nil)
      et = Utils.lookup_error(lzma_ret)
      raise et, mesg, caller
    end
  end
end
