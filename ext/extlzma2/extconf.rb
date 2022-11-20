# frozen_string_literal: true

require 'mkmf'

# needlist = []

dir_config('liblzma')

have_header('lzma.h')
have_library('lzma')

# abort "#{$0}: dependency files are not found (#{needlist.join(' ')})." unless needlist.empty?

staticlink = arg_config('--liblzma-static-link', false)

if staticlink
  # 静的ライブラリリンクを優先する
  $libs = ['-Wl,-llzma', $libs].join(' ')
end

if RbConfig::CONFIG['arch'] =~ (/mingw/) && (try_link 'void main(void){}', ' -static-libgcc ')
  $LDFLAGS << ' -static-libgcc '
end

$LDFLAGS << ' -Wl,-Bsymbolic ' if try_link 'void main(void){}', ' -Wl,-Bsymbolic '

create_makefile 'extlzma2/extlzma2'
