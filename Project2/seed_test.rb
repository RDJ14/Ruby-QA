require "minitest/autorun"

require_relative "seed"

class TestSeed < Minitest::Test

  def setup
    @seed = Seed::new
  end
  # Unit test for getSeedValue(string[])
  # Equivalence classes
  # string[0] = (Not an Integer) -> returns 0
  # string[0] = "-2147483648..2147483647" -> returns the entered value as an int

  #If a non integer value is entered, 0 is returned
  def test_non_int_val
      assert_equal 0, @seed.getSeedValue(["Not an Integer"])
  end

  #If a positive integer value is entered that value is returned
  def test_positive_int_val
      assert_equal 12345, @seed.getSeedValue(["12345"])
  end

  #If the max integer value is entered that value should be returned
  # EDGE CASE
  def test_positive_max_val
      assert_equal 2147483647, @seed.getSeedValue(["2147483647"])
  end
end
