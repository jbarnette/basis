require "basis/template"
require "fileutils"

module Basis
  class Repo
    attr_reader :home

    def initialize home = "~/.basis"
      @home = File.expand_path home
    end

    def add url, name = nil
      name ||= File.basename(url, ".git").
        downcase.sub(/^basis[-_]/, "").tr "-", ":"

      if templates.keys.include? name
        raise "Template '#{name}' already exists!"
      end

      FileUtils.mkdir_p template_path
      git :clone, url, template_path(name)

      @templates = nil
    end

    def remove name
      FileUtils.rm_rf template_path(name)

      @templates = nil
    end

    def templates pattern = nil
      unless @templates
        @templates = {}

        Dir[template_path("*")].each do |d|
          next unless File.directory? d

          template = Basis::Template.new d
          @templates[File.basename d] = template
        end
      end

      Hash[@templates.select { |n, t| pattern.nil? || pattern =~ n }]
    end

    def update pattern = nil
      templates.each do |name, template|
        next unless pattern.nil? || pattern =~ name
        Dir.chdir(template.srcdir) { git :pull }
      end
    end

    private

    def git *args # FIX
      system "git", *args.map(&:to_s)
    end

    def template_path *args
      File.join @home, "templates", *args
    end
  end
end
