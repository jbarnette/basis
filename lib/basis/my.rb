module Basis
  class My
    attr_reader :classname
    attr_reader :name
    attr_reader :path
    attr_reader :underpath

    def initialize name
      @name      = name
      @path      = @name.tr "-", "/"
      @underpath = @path.tr "/", "_"

      @classname = @name.split("-").
        map { |a| a.split("_").map { |b| b.capitalize }.join }.join "::"
    end

    def to_h
      @hash ||= {
        "my.classname" => classname,
        "my.name"      => name,
        "my.path"      => path,
        "my.underpath" => underpath,
      }
    end
  end
end
