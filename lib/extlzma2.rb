# frozen_string_literal: true

require_relative 'extlzma2/aux'
require_relative 'extlzma2/decoder'
require_relative 'extlzma2/encoder'
require_relative 'extlzma2/filter'
require_relative 'extlzma2/stream'
require_relative 'extlzma2/utils'
require_relative 'extlzma2/extlzma2'
require_relative 'extlzma2/version'

module LZMA
  #
  # call-seq:
  #   encode(string_data, preset = LZMA::PRESET_DEFAULT, opts = {}) -> encoded_xz_data
  #   encode(string_data, filter...) -> encoded_xz_data
  #   encode(output_stream = nil, preset = LZMA::PRESET_DEFAULT, opts = {}) -> stream_encoder
  #   encode(output_stream, filter...) -> stream_encoder
  #   encode(output_stream = nil, preset = LZMA::PRESET_DEFAULT, opts = {}) { |encoder| ... } -> yield return value
  #   encode(output_stream, filter...) { |encoder| ... } -> yield return value
  #
  # データを圧縮、または圧縮器を生成します。
  #
  # 圧縮されたデータ列は xz ファイルフォーマットとなるため、コマンドラインの xz などで伸張させることが可能です。
  #
  # [RETURN encoded_xz_data]
  #   xz データストリームとしての String インスタンスです。
  # [RETURN stream_encoder]
  #   xz データストリームを生成する圧縮器を返します。
  # [RETURN output_stream]
  #   引数として渡した <tt>output_stream</tt> そのものを返します。
  # [string_data]
  #   圧縮元となるデータを String インスタンスで渡します。
  #   liblzma はエンコーディング情報を無視し、そのままのバイト列をバイナリデータと見立て処理を行います。
  # [preset = LZMA::PRESET_DEFAULT]
  #   圧縮プリセット値を指定します (圧縮レベルのようなものです)。詳細は LZMA::Filter::LZMA2.new を見てください。
  # [opts]
  #   LZMA::Filter::LZMA2.new に渡される可変引数です。詳細は LZMA::Filter::LZMA2.new を見てください。
  # [filter]
  #   LZMA::Filter で定義されているクラスのインスタンスを指定します。最大4つまで指定することが出来ます。
  # [output_stream]
  #   圧縮データの受け皿となるオブジェクトを指定します。
  #
  #   <tt>.<<</tt> メソッドが呼ばれます。
  # [YIELD RETURN]
  #   無視されます。
  # [YIELD encoder]
  #   圧縮器が渡されます。
  #
  # [EXCEPTIONS]
  #   (NO DOCUMENT)
  #
  def self.encode(src = nil, *args, &block)
    Aux.encode(src, Stream.encoder(*args), &block)
  end

  #
  # call-seq:
  #   decode(string_data) -> decoded data
  #   decode(string_data, filter...) -> decoded data
  #   decode(input_stream) -> decoder
  #   decode(input_stream, filter...) -> decoder
  #   decode(input_stream) { |decoder| ... }-> yield return value
  #   decode(input_stream, filter...) { |decoder| ... }-> yield return value
  #
  # 圧縮されたデータを伸張します。
  #
  # [RETURN decoded data]
  #   xz データストリームとしての String インスタンスです。
  # [RETURN decoder]
  # [RETURN yield return value]
  # [string_data]
  #   圧縮されたデータを与えます。圧縮されたデータの形式は xz と lzma です。これらはあらかじめ区別する必要なく与えることが出来ます。
  # [options]
  #   LZMA::Filter::LZMA2.new に渡される可変引数です。詳細は LZMA::Filter::LZMA2.new を見てください。
  # [EXCEPTIONS]
  #   (NO DOCUMENT)
  #
  def self.decode(src, *args, &block)
    Aux.decode(src, Stream.auto_decoder(*args), &block)
  end

  #
  # call-seq:
  #   LZMA.raw_encode(src) -> encoded data
  #   LZMA.raw_encode(src, filter...) -> encoded data
  #   LZMA.raw_encode(outport = nil) -> encoder
  #   LZMA.raw_encode(outport, filter...) -> encoder
  #   LZMA.raw_encode(outport = nil) { |encoder| ... } -> yield return value
  #   LZMA.raw_encode(outport, filter...)  { |encoder| ... } -> yield return value
  #
  # データを圧縮します。圧縮されたデータ列は生の lzma1/lzma2 のデータ列であるため、伸張する際に適切なフィルタを与える必要があります。
  #
  # xz ファイルフォーマットヘッダや整合値を持たないため、これらが不要な場合は有用かもしれません。
  #
  # [RETURN encoded data]
  #   生の lzma1/lzma2 のデータ列となる String インスタンスです。
  # [src]
  #   圧縮元となるデータを String インスタンスで渡します。
  # [filter]
  #   LZMA::Filter のインスタンスを与えます。最大4つまで指定可能です。
  #
  #   省略時は lzma2 フィルタが指定されたとみなします。
  # [EXCEPTIONS]
  #   (NO DOCUMENT)
  #
  def self.raw_encode(src, *args, &block)
    Aux.encode(src, Stream.raw_encoder(*args), &block)
  end

  #
  # call-seq:
  #   LZMA.raw_decode(encoded_data) -> decoded data
  #   LZMA.raw_decode(encoded_data, filter...) -> decoded data
  #   LZMA.raw_decode(inport) -> raw decoder
  #   LZMA.raw_decode(inport, filter...) -> raw decoder
  #   LZMA.raw_decode(inport) { |decoder| ... } -> yield return value
  #   LZMA.raw_decode(inport, filter...) { |decoder| ... } -> yield return value
  #
  # 圧縮されたデータを伸張します。圧縮した際に用いたフィルタをそのままの順番・数で与える必要があります。
  #
  # [RETURN decoded data]
  #   伸張されたデータ列となる String インスタンスです。
  # [src]
  #   圧縮された生の lzma1/lzma2 の String インスタンスを渡します。
  # [options]
  #   LZMA::Filter のインスタンスを与えます。最大4つまで指定可能です。
  #
  #   省略時は lzma2 フィルタが指定されたとみなします。
  # [EXCEPTIONS]
  #   (NO DOCUMENT)
  #
  def self.raw_decode(src, *args, &block)
    Aux.decode(src, Stream.raw_decoder(*args), &block)
  end

  def self.lzma1(*args)
    LZMA::Filter::LZMA1.new(*args)
  end

  def self.lzma2(*args)
    LZMA::Filter::LZMA2.new(*args)
  end

  def self.delta(*args)
    LZMA::Filter::Delta.new(*args)
  end
end
