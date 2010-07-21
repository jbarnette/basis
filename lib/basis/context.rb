module Basis
  class Context
    attr_reader :my

    def initialize my, overrides
      @git       = Hash[`git config -lz`.split("\000").map { |e| e.split "\n" }]
      @my        = my
      @overrides = overrides || {}
    end

    def [] key
      @overrides[key] || @my.to_h[key] || @git[key]
    end

    def git key
      @git[key]
    end
  end
end
