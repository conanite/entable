module Entable::Transformer
  def self.add_transformer name, transformer=nil, &block
    @@transformers ||= { }
    @@transformers[name.to_sym] = transformer || block
  end

  def self.apply_transform collection, transform_name
    transformer = @@transformers[transform_name.to_sym]
    raise "Unknown transformer name #{transform_name.inspect}" if transformer.nil?
    transformer.call collection
  end
end
