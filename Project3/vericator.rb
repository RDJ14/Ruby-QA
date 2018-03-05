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

  def create_block someBlock
    if(someBlock.length != 5)
      return nil
    end
    returnBlock = Block.new(someBlock[0], someBlock[1], someBlock[2], someBlock[3], someBlock[4])
    return returnBlock
  end

end
