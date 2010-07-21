require "minitest/autorun"
require "basis/context"
require "basis/my"

class BasisContextTest < MiniTest::Unit::TestCase
  def setup
    my       = Basis::My.new "hello"
    @context = Basis::Context.new my, "my.name" => "HI!", "new" => "new"
  end

  def test_git # only works if your git is properly set up at test-time
    refute_nil @context.git("user.name")
    assert_equal @context.git("user.name"), @context["user.name"]
  end

  def test_indexer
    assert_equal "HI!", @context["my.name"]
    assert_equal "new", @context["new"]
    assert_equal "Hello", @context["my.classname"]
  end

  def test_my
    assert_equal "hello", @context.my.name
  end
end
