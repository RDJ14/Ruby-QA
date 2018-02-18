require "minitest/autorun"

require_relative "seed"


# Unit test for getSeedValue(string[])
# Equivalence classes
# string[0] = (Not an Integer) -> returns 0
# string[0] = "-2147483648..2147483647" -> returns the entered value as an int

#If a non integer value is entered, 0 is returned
def test_non_int_val
    assert_equals 0, getSeedValue(["Not an Integer"])
end

#If a positive integer value is entered that value is returned
def test_positive_int_val
    assert_equals 12345, getSeedValue(["12345"])
end

#If the max integer value is entered that value should be returned
# EDGE CASE
def test_positive_max_val
    assert_equals 2147483647, getSeedValue["2147483647"]
end
