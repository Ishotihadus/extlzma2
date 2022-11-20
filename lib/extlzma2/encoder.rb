# frozen_string_literal: true

require 'stringio'

module LZMA
  Encoder = Struct.new(:context, :outport, :writebuf, :workbuf, :status) do |klass|
    klass::BLOCKSIZE = 256 * 1024 # 256 KiB

    def initialize(context, outport)
      super(context, outport, StringIO.new(String.new), String.new, [1])
      self.class.method(:finalizer_regist).call(self, context, outport, writebuf, workbuf, status)
    end

    def write(buf)
      writebuf.rewind
      writebuf.string.clear
      writebuf << buf
      until writebuf.string.empty?
        s = context.code(writebuf.string, workbuf, self.class::BLOCKSIZE, 0)
        Utils.raise_err s unless s == 0
        outport << workbuf
        workbuf.clear
      end

      self
    end

    alias_method :<<, :write

    def close
      raise "already closed stream - #{inspect}" if eof?

      self.class.method(:finalizer_close).call(context, outport, workbuf)

      status[0] = nil

      nil
    end

    def eof
      !status[0]
    end

    alias_method :eof?, :eof

    class << self
      private

      def finalizer_regist(obj, context, outport, writebuf, workbuf, status)
        ObjectSpace.define_finalizer(obj, finalizer_make(context, outport, writebuf, workbuf, status))
      end

      def finalizer_make(context, outport, writebuf, workbuf, status)
        proc do
          if status[0]
            until writebuf.string.empty?
              s = context.code(writebuf.string, workbuf, self::BLOCKSIZE, 0)
              Utils.raise_err s unless s == LZMA::OK
              outport << workbuf
              workbuf.clear
            end

            finalizer_close(context, outport, workbuf)

            status[0] = nil
          end
        end
      end

      def finalizer_close(context, outport, workbuf)
        loop do
          workbuf.clear
          s = context.code(nil, workbuf, self::BLOCKSIZE, LZMA::FINISH)
          outport << workbuf
          break if s == LZMA::STREAM_END

          Utils.raise_err s unless s == LZMA::OK
        end
      end
    end
  end
end
