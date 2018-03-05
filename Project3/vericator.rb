require_relative "Block"


class Vericator

  def initialize()
  end

  def verify_arg inputArray
    if(inputArray.length != 1)
      return false
    end
    fileName = inputArray[0]
    fileArray = fileName.split('.')
    if(fileArray.length != 2)
      return false
    end
    if(fileArray[1].eql? "txt")
      return true
    else
      return false
    end
  end

  def read_file fileName
    fileLines = File.readlines(fileName)
    return fileLines
    rescue
      puts "The file #{fileName} could not be opened. Are you sure it exists?"
      exit
  end

  def split_block block
    splitBlock = block.split('|')
    return splitBlock
  end

  def verify_starting_block block
    if((block.blockNumber) != "0")
      return "Invalid block number for Genesis Block"
    elsif((block.previousHash) != "0")
      return "Invalid previous hash for Genesis Block"
    else
      return true
    end
  end

  def verify_rest_of_chain blockAr
	  blockAr.each_with_index { |blk, idx| break if idx + 1 == blockAr.length # Don't overrun array
		  # Check if our endHash == next block's previousHash
		  # If there's a hash mismatch, raise an exception
		  if blk[idx].endHash != blk[idx + 1].previousHash
			  raise "Block #{idx + 1}'s previous hash (#{blk[idx + 1].previousHash}) does not " + 
				  "match block #{idx}'s end hash (#{blk[idx].endHash})"
		  end
	  
	  	  # Check if the transaction itself is valid
	  }
	  return true
  end

  def create_block someBlock
    if(someBlock.length != 5)
      return nil
    end
    returnBlock = Block.new(someBlock[0], someBlock[1], someBlock[2], someBlock[3], someBlock[4])
    return returnBlock
  end

end
