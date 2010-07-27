require "basis"
require "basis/template"
require "fileutils"
require "open4"

module Basis
  class Repo
    attr_reader :home

    def initialize home = "~/.basis"
      @home = File.expand_path home
    end

    def add url, name = nil
      name ||= File.basename(url, ".git").downcase.sub(/^basis[-_]/, "")

      if templates.keys.include? name
        raise Basis::Oops, "Template '#{name}' already exists!"
      end

      FileUtils.mkdir_p template_path
      git :clone, url, template_path(name)

      @templates = nil
    end

    def remove name
      FileUtils.rm_rf template_path(name)

      @templates = nil
    end

    def rename old, new
      unless File.directory? template_path(old)
        raise Basis::Oops, "Unknown template: #{old}"
      end

      FileUtils.mv template_path(old), template_path(new)
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

    def git *args
      out, err = nil

      status = Open4.popen4 "git", *args.map(&:to_s) do |pid, sin, sout, serr|
        out = sout.read.chomp
        err = serr.read.chomp
      end

      raise Basis::Oops, err if 0 != status.exitstatus
    end

    def template_path *args
      File.join @home, "templates", *args
    end
  end
end
