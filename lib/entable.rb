require "entable/version"

module Entable
  def self.add_transformer name, transformer=nil, &block
    Entable::Transformer.add_transformer name, transformer, &block
  end

  def self.add_wrapper name, &block
    Entable::Wrapper.add_wrapper name, &block
  end
end

require 'entable/xls_export'
require 'entable/html_builder'
require 'entable/transformer'
require 'entable/wrapper'
