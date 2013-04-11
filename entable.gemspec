# -*- coding: utf-8; mode: ruby  -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'entable/version'

Gem::Specification.new do |gem|
  gem.name          = "entable"
  gem.version       = Entable::VERSION
  gem.authors       = ["conanite"]
  gem.email         = ["conan@conandalton.net"]
  gem.description   = %q{Generate HTML tables which popular spreadsheet software packages know how to read }
  gem.summary       = %q{LibreOffice and Microsoft Office are both able to open a HTML file and interpret the contents of the <table> element as a worksheet.

This gem generates such a HTML file, given a collection and a configuration. For each column, the configuration specifies the column header text, and how to extract the data for each cell in that column.}

  gem.homepage      = "https://github.com/conanite/entable"

  gem.add_development_dependency 'rspec', '~> 2.9'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
