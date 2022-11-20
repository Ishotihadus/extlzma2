# frozen_string_literal: true

require 'stringio'

module LZMA
  Decoder = Struct.new(:context, :inport, :readbuf, :workbuf, :status) do |klass|
    klass::BLOCKSIZE = 256 * 1024 # 256 KiB

    def initialize(context, inport)
      super(context, inport, String.new, StringIO.new(String.new), :ready)
    end

    def read(size = nil, buf = String.new)
      buf.clear
      size = size.to_i if size
      return buf if size == 0

      tmp = String.new
      while !eof && (size.nil? || size > 0)
        fetch or break if workbuf.eof?

        workbuf.read(size, tmp) or break
        buf << tmp
        size -= tmp.bytesize if size
      end

      buf
    end

    def eof
      !status && workbuf.eof?
    end

    alias_method :eof?, :eof

    def close
      self.status = nil
      workbuf.rewind
      workbuf.string.clear
      nil
    end

    private

    def fetch
      return nil unless status == :ready

      while workbuf.eof
        inport.read(self.class::BLOCKSIZE, readbuf) if readbuf.empty?

        workbuf.string.clear
        workbuf.rewind
        s = if readbuf.empty?
              context.code(nil, workbuf.string, self.class::BLOCKSIZE, LZMA::FINISH)
            else
              context.code(readbuf, workbuf.string, self.class::BLOCKSIZE, 0)
            end

        case s
        when LZMA::OK
          # pass
        when LZMA::STREAM_END
          self.status = :finished
          break
        else
          Utils.raise_err s
        end
      end

      self
    end
  end
end
