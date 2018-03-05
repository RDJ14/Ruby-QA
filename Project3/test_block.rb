require "minitest/autorun"
require_relative "block"

class TestBlock < Minitest::Test

  # Unit Tests for create_block
  #
  def test_create_block
    array = ["0", "0", "Test>Test(100)", "1518892051.737141000", "1s2a"]
    block = Block.create_block(array)

    assert_equal "0", block.blockNumber
    assert_equal "0", block.previousHash
    assert_equal "Test>Test(100)", block.transactions
    assert_equal  "1518892051.737141000", block.timeStamp
    assert_equal  "1s2a", block.endHash
  end

  def test_create_bad_block_few_args

    array = ["0", "0"]
    block = Block.create_block(array)

    assert_nil(block)
  end

  def test_create_bad_block_more_args
    array = ["0", "0"< "test", "4", "5", "tooMany"]
    block = Block.create_block(array)

    assert_nil(block)
  end


end
