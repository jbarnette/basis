require "minitest/autorun"
require "basis/template"

class BasisTemplateTest < MiniTest::Unit::TestCase
  def test_initialize
    t = Basis::Template.new "foo/bar"
    assert_equal "#{File.expand_path '.'}/foo/bar", t.srcdir
  end
end
