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

  def verify_rest_of_chain blockArray

	  hashMap = Hash.new

	  blockArray.each_with_index { |blk, idx| break if idx + 1 == blockArray.length # Don't overrun array
		  
		  # Check if our endHash == next block's previousHash
		  # If there's a hash mismatch, raise an exception
		  # Hacky newline removal
		  blk.endHash.delete!("\n")
		  blockArray[idx + 1].previousHash.delete!("\n")

		  unless blk.endHash.eql?(blockArray[idx + 1].previousHash)
			  raise "Block #{idx + 1}'s previous hash<#{blockArray[idx + 1].previousHash}> does not " + 
				  "match block #{idx}'s end hash:<#{blk.endHash}>"
		  end
	  
		  # Check for valid transaction amounts
		  buffer = blockArray[idx].transactions
		  while not buffer.empty?
			sender = buffer.chomp!(">")
			reciever = buffer.chomp!("(")
			amount = buffer.chomp!(")").to_i
			# Check transaction format
			raise "Billcoin sender is nil in block #{idx}" if sender.nil?
			raise "Billcoin reciever is nil in block #{idx}" if reciever.nil?
			raise "Billcoin amount is nil in block #{idx}: #{amount}" if amount.nil?

			if (not sender.eql? "SYSTEM") &&  (hashMap[sender].to_i - amount < 0)
				# Check if the sender has enough coins for the transaction
				# unless its the system
				raise "#{sender} does not have enough Billcoins for this transaction"
			end
			# Unless the system is giving billcoins, subtract the amount from
			# the sender's wallet
			hashMap[sender] = hashMap[sender].to_i - amount unless sender.eql? "SYSTEM"
			hashMap[reciever] = hashMap[reciever].to_i + amount

			# Break if there aren't more transactions
			break unless buffer.chomp!(":") != nil
		  end
	  }
	  return hashMap
  end

  def create_block someBlock
    if(someBlock.length != 5)
      return nil
    end
    returnBlock = Block.new(someBlock[0], someBlock[1], someBlock[2], someBlock[3], someBlock[4])
    return returnBlock
  end

end
