module Entable::Wrapper
  def self.add_wrapper name, &block
    @@wrappers ||= { }
    @@wrappers[name.to_sym] = block
  end

  def self.apply_wrapper name, items, *args
    wrapper = @@wrappers[name.to_sym]
    items.map { |item| wrapper.call(item, *args) }
  end
end
