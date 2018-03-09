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
			  puts "Block #{idx + 1}'s previous hash<#{blockArray[idx + 1].previousHash}> does not " +
				  "match block #{idx}'s end hash:<#{blk.endHash}>"
			  return nil
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
				puts "#{sender} does not have enough Billcoins for this transaction"
				return nil
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
		puts "Block #{blk.blockNumber} is out of order, expected #{idx}"
		return false
	end
		# Block numbers should be 0..lastBlockNumber
	}
	return true
  end

  def verify_time blockArray
	  blockArray.each_with_index { |blk, idx| break if idx + 1 == blockArray.length
		# Get seconds
		nextBlk = blockArray[idx + 1]
		seconds = blk.timeStamp.slice(/.+?(?=\.)/)
		seconds.delete! "." # Get rid of "."
		next_blk_seconds = nextBlk.timeStamp.slice(/.+?(?=\.)/)
		next_blk_seconds.delete! "." # Get rid of "."
		# Get nanoseconds
		nanoseconds = blk.timeStamp.slice(/\..*$/) # from . to end of the line
		nanoseconds.delete! "." # Get rid of "."
		next_blk_ns = nextBlk.timeStamp.slice(/\..*$/)
		next_blk_ns.delete! "." # Get rid of "."
		# Test seconds
		if seconds > next_blk_seconds
      puts "Current timestamp:#{blk.timeStamp} >= next timestamp:#{nextBlk.timeStamp}"
      return false
    # Seconds same test nano seconds
    elsif seconds == next_blk_seconds
      # Longer length means longer time
      if nanoseconds.length > next_blk_ns.length
        puts "Current timestamp:#{blk.timeStamp} >= next timestamp:#{nextBlk.timeStamp}"
        return false
      # If same length, compare values
      elsif nanoseconds.length == next_blk_ns.length
        if nanoseconds > next_blk_ns
          puts "Current timestamp:#{blk.timeStamp} >= next timestamp:#{nextBlk.timeStamp}"
          return false
        end
      end
    end
	  }
    return true
  end

  def verify_hash_value blockArray
    blockArray.each_with_index { |blk, idx| break if idx == blockArray.length
      block_number = blk.blockNumber
      previous_hash = blk.previousHash
      transactions = blk.transactions
      timestamp = blk.timeStamp

      #construct string for hashing
      total_string = block_number + "|" + previous_hash + "|" + transactions + "|" + timestamp
      total_string_pack = total_string.unpack('U*')

      value = 0

      total_string_pack.each_with_index { |x, idy| break if idy == total_string_pack.length
        value += (x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)
        value = value % 65536
      }

      value = value % 65536
      hash_value = value.to_s(16)
      if(blk.endHash.chomp != hash_value)
        puts "The hash value for line #{idx} is #{blk.endHash} but should be #{hash_value}"
        return false
      end
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