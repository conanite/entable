module Entable::Wrapper
  def self.add_wrapper name, klass, &block
    @@wrappers ||= { }
    @@wrappers[name.to_sym] = klass || block
  end

  def self.apply_wrapper name, items, *args
    wrapper = @@wrappers[name.to_sym]
    if wrapper.respond_to? :call
      items.map { |item| wrapper.call(item, *args) }
    elsif wrapper.is_a? Class
      items.map { |item| wrapper.new(*item, *args) }
    else
      raise "Unknown wrapper name #{name.inspect}"
    end
  end
end
