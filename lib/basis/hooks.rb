module Basis
  module Hooks
    def self.fire name, *args
      hooks[name].each { |h| h.call *args }
    end

    def self.hooks
      @hooks ||= Hash.new { |h, k| h[k] = [] }
    end

    def self.on name, &block
      hooks[name] << block
    end
  end
end
