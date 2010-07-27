require "hoe"

Hoe.plugin :doofus, :git, :isolate

Hoe.spec "basis" do
  developer "John Barnette", "jbarnette@gmail.com"

  require_ruby_version ">= 1.8.7"
  
  self.extra_rdoc_files = Dir["*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
  self.testlib          = :minitest

  extra_deps << ["erubis", "~> 2.0"]
  extra_deps << ["open4",  "~> 1.0"]
end
