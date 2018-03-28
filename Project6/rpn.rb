# Main



class Interpreter

  # HashMap for storing variables, can check if they've been declared
  variables = Hash.new
  tokenStack

  def read_file filename
	raise "#{filename} not found" unless File.exist?(filename)
    file = File.open(filename,"r")
	file.foreach(&:add_to_stack) # Calls function per line
  end

  def add_to_stack line
	# Pushes tokens from line onto stack
	line.downcase! # Make line case insensitive
    while not line.isEmpty?
	  tokenStack.push(line.chomp!(' ')) # Push space-delimited tokens
    end
  end

  def declare_var var
  end

  def calculate
  
  end

  def print

  end
  
  def let

  end
  
end
