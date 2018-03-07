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

  def verify_hashes blockArray

	  # idx + 1 so we don't overrun array
	  blockArray.each_with_index { |blk, idx| break if idx + 1 == blockArray.length 
		  # Check if our endHash == next block's previousHash
		  # If there's a hash mismatch, raise an exception
		  # Hacky newline removal
		  blk.endHash.delete!("\n")
		  blockArray[idx + 1].previousHash.delete!("\n")

		  unless blk.endHash.eql?(blockArray[idx + 1].previousHash)
			  raise "Block #{idx + 1}'s previous hash<#{blockArray[idx + 1].previousHash}> does not " + 
				  "match block #{idx}'s end hash:<#{blk.endHash}>"
		  end
	  }

	  return true
  end
  def verify_wallet_amounts blockArray

	  hashMap = Hash.new
	
	  # idx + 1 so we don't overrun array
	  blockArray.each_with_index { |blk, idx| break if idx + 1 == blockArray.length 
		  
		  # Check for valid transaction amounts
		  transactions = blockArray[idx].transactions.split(":") # Split by transaction
		  transactions.each { |thisTransaction| # work on each transaction
			
		  	sender = thisTransaction.slice(/.*>/) # Isolate sender's name
			sender.delete! ">" # Remove the ">"
			reciever = thisTransaction.slice(/>.*\(/) # Isolate to ">receiver("
			reciever.delete! "(" # Got rid of "("
			reciever.delete! ">" # Got rid of ">"
			amount = thisTransaction.slice(/\(.*\)/) # Isolated to "(amount)"
			amount.delete! "("
			amount.delete! ")"
			# Check transaction format
			raise "Billcoin sender is nil in block #{idx}" if sender.nil?
			raise "Billcoin reciever is nil in block #{idx}" if reciever.nil?
			raise "Billcoin amount is nil in block #{idx}: #{amount}" if amount.nil?

			if (not sender.eql? "SYSTEM") &&  (hashMap[sender].to_i - amount.to_i < 0)
				# Check if the sender has enough coins for the transaction
				# unless its the system
				raise "#{sender} does not have enough Billcoins for this transaction"
			end
			# Unless the system is giving billcoins, subtract the amount from
			# the sender's wallet
			hashMap[sender] = hashMap[sender].to_i - amount.to_i unless sender.eql? "SYSTEM"
			hashMap[reciever] = hashMap[reciever].to_i + amount.to_i

		  } # end of transactions.each
	  } # end of blockArray.each_with_index
	  return hashMap
  end

  def verify_order blockArray
		blockArray.each_with_index { |blk, idx| 
	  	unless blk.blockNumber.to_i.eql? idx
			raise "Block #{blk.blockNumber} is out of order, expected #{idx}"
		end
			# Block numbers should be 0..lastBlockNumber
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
