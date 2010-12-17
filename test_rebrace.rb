require 'rebrace.rb'
require 'test/unit'

class TestRebracer < Test::Unit::TestCase
  def rebraceToString(input)
    output = ""
    Rebracer.new(input).rebrace { |line| output += line }
    return output
  end
  
  def test_simple
    input = <<-END_OF_CODE
      if (x == 1) {
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1) 
      {
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input))
  end
  
  def test_nochange
    input = <<-END_OF_CODE
      if (x == 1)
      {
        ++x;
      }
    END_OF_CODE
    expected = <<-END_OF_CODE
      if (x == 1)
      {
        ++x;
      }
    END_OF_CODE
    assert_equal(expected, rebraceToString(input))
  end
end