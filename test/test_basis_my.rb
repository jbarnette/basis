require "minitest/autorun"
require "basis/my"

class BasisMyTest < MiniTest::Unit::TestCase
  def setup
    @my = Basis::My.new "rake-remote_task"
  end
  
  def test_classname
    assert_equal "Rake::RemoteTask", @my.classname
  end
  
  def test_initialize
    m = Basis::My.new "foo"
    assert_equal "foo", m.name
  end

  def test_path
    assert_equal "rake/remote_task", @my.path
  end

  def test_to_h
    h = @my.to_h

    assert_equal @my.classname, h["my.classname"]
    assert_equal @my.name, h["my.name"]
    assert_equal @my.path, h["my.path"]
    assert_equal @my.underpath, h["my.underpath"]
  end

  def test_underpath
    assert_equal "rake_remote_task", @my.underpath
  end
end
