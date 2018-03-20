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
    v = Vericator.new()
    block = "1|1|Testing>ad&*@|test"
	split = v.split_block(block)

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

  # Unit tests for vericator::verify_order
  # SUCCESS CASE: Block number of blocks are in ascending,successive order
  # FAILURE CASE: Block number of blocks are in any other order
  def test_verify_order_valid
    v = Vericator.new()
	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	blockTwo = Minitest::Mock.new
	def blockZero.blockNumber; 0; end
	def blockOne.blockNumber; 1; end
	def blockTwo.blockNumber; 2; end

	blockArray = [blockZero, blockOne, blockTwo]
	assert v.verify_order(blockArray)
  end

  def test_verify_order_invalid
    v = Vericator.new()

	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	blockTwo = Minitest::Mock.new
	def blockZero.blockNumber; 0; end
	def blockOne.blockNumber; 2; end
	def blockTwo.blockNumber; 1; end

	blockArray = [blockZero, blockOne, blockTwo]
	refute v.verify_order(blockArray)
  end
  # Unit tests for vericator::verify_matching_hashes
  # SUCCESS CASE: A block's end hash matches the next block's previous hash
  # FAILURE CASE: A block's end hash does not match the next block's previous hash
  def test_verify_hashes_matching
    v = Vericator.new()
	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	def blockZero.endHash; "2f53"; end
	def blockOne.previousHash; "2f53"; end

	blockArray = [blockZero, blockOne]
	assert v.verify_matching_hashes(blockArray)
  end
  def test_verify_hashes_not_matching
    v = Vericator.new()
	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	def blockZero.endHash; "2f53"; end
	def blockOne.previousHash; "5ac2"; end
	
	blockArray = [blockZero, blockOne]
	refute v.verify_matching_hashes(blockArray)
  end

  # Unit tests for vericator::verify_wallet_amounts
  # SUCCESS CASE: A sender does not send more coins than they have
  # FAILURE CASE: A sender sends more coins than they have
  def test_verify_wallets_valid
    v = Vericator.new()
	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	def blockZero.transactions; "SYSTEM>Bob(100):Bob>Julia(12)"; end
	def blockOne.transactions; "Julia>Emma(2):Bob>Emma(5)"; end
	
	blockArray = [blockZero, blockOne]
	refute_nil v.verify_wallet_amounts(blockArray) # Sends nil on failure
  end
  def test_verify_wallets_invalid
    v = Vericator.new()
	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	def blockZero.transactions; "SYSTEM>Bob(100):Bob>Julia(120)"; end
	def blockOne.transactions; "Julia>Emma(500):Bob>Emma(5)"; end
	
	blockArray = [blockZero, blockOne]
	assert_nil v.verify_wallet_amounts(blockArray) # Sends nil on failure
  end
  # Unit tests for vericator::verify_hash_value
  # SUCCESS CASE: The end hash is a correct hash of the blockchain
  # SUCCESS CASE: The end hash is an incorrect hash of the blockchain
  def test_verify_hashes_valid
    v = Vericator.new()
	blockZero = Minitest::Mock.new
	# Don't include the end hash as it hasn't been made yet
	def blockZero.blockNumber; 0; end
	def blockZero.previousHash; 0; end
	def blockZero.transactions; "SYSTEM>Henry(100)"; end
	def blockZero.timeStamp; "1518892051.737141000"; end
	def blockZero.endHash; "1c12"; end
	def blockZero.hashableString; "0|0|SYSTEM>Henry(100)|1518892051.737141000"; end
	
	blockOne = Minitest::Mock.new
	def blockOne.blockNumber; 3; end
	def blockOne.previousHash; "c72d"; end
	def blockOne.transactions; "SYSTEM>Henry(100)"; end
	def blockOne.timeStamp; "1518892051.764563000"; end
	def blockOne.endHash; "7419"; end
	def blockOne.hashableString; "3|c72d|SYSTEM>Henry(100)|1518892051.764563000"; end
	blockArray = [blockZero,blockOne]
	assert v.verify_hash_value blockArray
  end
  def test_verify_hashes_invalid
    v = Vericator.new()
	blockZero = Minitest::Mock.new
	# Don't include the end hash as it hasn't been made yet
	def blockZero.blockNumber; 0; end
	def blockZero.previousHash; 0; end
	def blockZero.transactions; "SYSTEM>Henry(100)"; end
	def blockZero.timeStamp; "1518892051.737141000"; end
	def blockZero.endHash; "2f50"; end
	def blockZero.hashableString; "0|0|SYSTEM>Henry(100)|1518892051.737141000"; end
	
	blockOne = Minitest::Mock.new
	def blockOne.blockNumber; 3; end
	def blockOne.previousHash; "c72d"; end
	def blockOne.transactions; "SYSTEM>Henry(100)"; end
	def blockOne.timeStamp; "1518892051.764563000"; end
	def blockOne.endHash; "7419"; end
	def blockOne.hashableString; "3|c72d|SYSTEM>Henry(100)|1518892051.764563000"; end
	blockArray = [blockZero,blockOne]
	refute v.verify_hash_value blockArray
  end
  # Unit tests for vericator::verify_time
  # SUCCESS CASE: Each succeeding timestamp has a later time than the previous one
  # FAILURE CASE: A succeeding timestamp has an earlier time than the previous one
  def test_verify_time_valid
    v = Vericator.new()

	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	blockTwo = Minitest::Mock.new

	def blockZero.timeStamp; "10.500"; end
	def blockOne.timeStamp; "11.500"; end
	def blockTwo.timeStamp; "11.700"; end
	
	
	blockArray = [blockZero, blockOne, blockTwo]
	assert v.verify_time(blockArray)
  end
  def test_verify_time_invalid
    v = Vericator.new()

	blockZero = Minitest::Mock.new
	blockOne = Minitest::Mock.new
	blockTwo = Minitest::Mock.new

	def blockZero.timeStamp; "10.500"; end
	def blockOne.timeStamp; "9.500"; end
	def blockTwo.timeStamp; "9.700"; end
	
	blockArray = [blockZero, blockOne, blockTwo]
	refute v.verify_time(blockArray)
  end
end
