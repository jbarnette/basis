require "erubis"
require "fileutils"

module Basis
  class Template
    attr_reader :srcdir

    def initialize srcdir
      @srcdir = File.expand_path srcdir
    end

    def render destdir, context
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
