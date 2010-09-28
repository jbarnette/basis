require "erubis"
require "fileutils"

module Basis
  class Template
    attr_reader :srcdir
    attr_reader :origin

    def initialize srcdir
      @srcdir = File.expand_path srcdir

      Dir.chdir @srcdir do
        remote  = `git remote -v`.split(/\s/)[1]
        rev     = `git rev-parse HEAD`
        @origin = "#{remote}@#{rev}"
      end

      if File.exist?(template = "#@srcdir/.basis/template.rb")
        src = IO.read template
        extend eval("Module.new do;#{src};end", nil, template, 1)
      end
    end

    def description
      "An awesome template."
    end

    def render destdir, context
      FileUtils.mkdir_p File.join(destdir, ".basis")

      File.open File.join(destdir, ".basis", "origin"), "wb" do |f|
        f.puts origin
      end

      Dir.glob("#{srcdir}/**/*", File::FNM_DOTMATCH).each do |src|
        next unless File.file? src

        rel = src.gsub(/^#{srcdir}\//, "")
        next if /^\.basis/ =~ rel || /^\.git\// =~ rel

        target = "#{destdir}/#{rel}"

        target.gsub!(/\[([a-z_][a-z0-9_]*(\.[a-z_][a-z0-9_]*)*)\]/i) do |expr|
          context[$1] || expr
        end

        FileUtils.mkdir_p File.dirname(target)

        # FIX: prompt for overwrite?

        contents = File.read src

        if contents =~ /\[%.*%\]/
          File.open target, "wb" do |f|
            erb = Erubis::Eruby.new contents,
            :filename => rel, :pattern => '\[% %\]'

            f.write erb.evaluate(context)
          end
        else
          FileUtils.copy src, target
        end

        # FIX: file perms
      end
    end
  end
end
