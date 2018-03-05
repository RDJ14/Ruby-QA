

class Block

  def self.create_block someBlock
      if(someBlock.length != 5)
        return nil
      end
      returnBlock = Block.new(someBlock[0], someBlock[1], someBlock[2], someBlock[3], someBlock[4])
      return returnBlock
  end

  def initialize(blockNumber, previousHash, transactions, timeStamp, endHash)
    @blockNumber = blockNumber
    @previousHash = previousHash
    @transactions = transactions
    @timeStamp = timeStamp
    @endHash = endHash
  end
  
  def print blockArray
    # TODO implement printing
  end


  attr_reader :blockNumber
  attr_reader :previousHash
  attr_reader :transactions
  attr_reader :timeStamp
  attr_reader :endHash

end
