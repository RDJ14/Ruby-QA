require "minitest/autorun"
require_relative "vericator"

class TestVerifier < Minitest::Test

  # Unit Test for verify_arg
  #
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

  def test_one_argument
    array = ["test.txt"]
    v = Vericator.new()
    assert (v.verify_arg(array))
  end

  # Unit test for read_file
  #
  def test_read_file

  end

  # Unit test for verify_starting_block
  #
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
