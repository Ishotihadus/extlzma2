# frozen_string_literal: true

require_relative 'lib/extlzma2/version'

Gem::Specification.new do |spec|
  spec.name = 'extlzma2'
  spec.version = LZMA::VERSION
  spec.authors = ['Ishotihadus']
  spec.email = ['hanachan.pao@gmail.com']

  spec.summary = 'A Ruby binding of liblzma'
  spec.description = 'A Ruby binding of liblzma that is compatible with Ruby 3.2'
  spec.homepage = 'https://github.com/Ishotihadus/extlzma2'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ['lib']
  spec.extensions = ['ext/extlzma2/extconf.rb']
end
