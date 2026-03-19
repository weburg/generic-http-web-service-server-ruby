require 'minitest/autorun'
require 'my_function'

class MyFunctionTest < Minitest::Test
  def test_my_function
    assert_includes my_function("Ruby"), "Ruby"
  end
end