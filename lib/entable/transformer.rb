module Entable::Transformer
  def self.add_transformer name, transformer=nil, &block
    @@transformers ||= { }
    @@transformers[name.to_sym] = transformer || block
  end

  def self.apply_transform collection, transform_name
    @@transformers[transform_name.to_sym].call collection
  end
end
