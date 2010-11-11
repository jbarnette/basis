require "minitest/autorun"
require "basis/template"

class BasisTemplateTest < MiniTest::Unit::TestCase
  def test_initialize
    t = Basis::Template.new "test/fixtures/empty"
    assert_equal "#{File.expand_path '.'}/test/fixtures/empty", t.srcdir
  end
end
