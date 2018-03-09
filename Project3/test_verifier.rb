require "minitest/autorun"
require_relative "vericator"

class TestVerifier < Minitest::Test

  # Unit Test for verify_arg
  # SUCCESS CASES: An array with one element that is a .txt file
  # FAILURE CASES: An array of 0 elements
  # =>             An array of 2...inf elemenets
  # =>             An array with 1 element that is not a .txt file
  def test_no_argument
    array = []
    v = Vericator.new()
    refute v.verify_arg(array)
  end

  def test_many_arguments
    array = ["1", "2", "3"]
    v = Vericator.new()
    refute (v.verify_arg(array))
  end

  def test_one_valid_argument
    array = ["test.txt"]
    v = Vericator.new()
    assert (v.verify_arg(array))
  end

  def test_one_invalid_argument
    array = ["test.pdf"]
    v = Vericator.new()
    refute (v.verify_arg(array))
  end

  # Unit test for split_block
  # SUCCESS CASE: The passed in string is split based on the '|' delimiter
  # FAILURE CASE: The passed string is not split properly
  def test_split_block
    block = "1|1|Testing>ad&*@|test"
    split = split_block(block)

    assert_equal split.length, 4
    assert_equal split[0], "1"
    assert_equal split[3], "test"
  end

  # Unit test for verify_starting_block
  # SUCCESS CASES: The block number and previous hash are both 0
  # FAILURE CASES: The block number is not 0, or the previous hash is not 0
  def test_correct_block
    v = Vericator.new()
    b = Minitest::Mock.new("Block")

    def b.blockNumber; 0; end
    def b.previousHash; 0; end

    assert v.verify_starting_block(b)
  end

  def test_incorrect_hash
    v = Vericator.new()
    b = Minitest::Mock.new("Block")

    def b.blockNumber; "0"; end
    def b.previousHash; "21sx"; end

    assert_equal "Invalid previous hash for Genesis Block", v.verify_starting_block(b)
  end

  def test_incorrect_block_number
    v = Vericator.new()
    b = Minitest::Mock.new("Block")

    def b.blockNumber; "-1"; end
    def b.previousHash; "0"; end

    assert_equal "Invalid block number for Genesis Block", v.verify_starting_block(b)
  end


end
