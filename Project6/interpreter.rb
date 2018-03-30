class TokenStack
  def initialize
    @tokenStack = Array.new
  end
  def push token
    @tokenStack.push(token)
  end
  def pop 
    return @tokenStack.pop
  end
  def reset
    @tokenStack = Array.new
  end
  def bottom
    return @tokenStack[0]
  end
end


class Interpreter

  def initialize repl, args # For using RPN++ in repl mode
    @repl_mode = false
    @variables = Hash.new
    @tokenStack = Array.new
    @operators = ['+', '-', '/', '*']
    @lineNumber = 0
    @repl_mode = repl
	if repl
      loop do
        print "> " # Print avoids the newline
	    input = gets.chomp
        break if input.downcase.eql? "quit"
        add_to_stack(0, input, Array.new)
      end
	else
      # Read file array if we're REPLing
	  error(0, "Invalid arguments") if (self.read_all_files(args)).nil?
	end
  end

  def read_all_files filename_array
    return nil unless filename_array.is_a? Array
    filename_array.each { |f|
		error(lineNumber, "#{f} not found") unless File.exist?(f)
		read_file(f) }
  end

  def read_file filename
    error(lineNumber, "Arguments are not valid filenames") unless filename.is_a? String
    file = File.open(filename,"r")
	file.each_line {|line| break if line.empty?
                 @lineNumber = @lineNumber + 1
				 add_to_stack(@lineNumber, line, Array.new)} # Calls function per line
  end

  def add_to_stack lineNumber, line, tokenStack
	# Pushes tokens from line onto stack
    lineNumber = lineNumber + 1
	line.downcase! # Make line case insensitive
	tokenArray = line.split # Split into array
	tokenArray.each { |token|
	  tokenStack.push(token) # Push space-delimited tokens
	  if @operators.include? tokenStack[-1]
        # Do binary op if we reached an operator
	    # Push result onto top of stack
		result = binary_operation(lineNumber, tokenStack)
	    tokenStack.push(result)
	  end
	}
    evaluate(lineNumber, tokenStack)
  end

  def binary_operation lineNumber, tokenStack
    # Top of stack is an operator
	# Second from top is RHS, third is LHS
	op = tokenStack.pop
	rhs = tokenStack.pop.to_i
	lhs = tokenStack.pop.to_i
	error(lineNumber, "Operator #{op} applied to empty stack") if lhs.nil? or rhs.nil?
    if rhs.is_a? String
      unless @variables.has_key? rhs
	  error(lineNumber, "Variable #{rhs} is not initialized")
      end
	  rhs = @variables[rhs] if rhs.match(/[a-z]/) # Dereference variable
    end
    if lhs.is_a? String
      unless @variables.has_key? lhs
	  error(lineNumber, "Variable #{lhs} is not initialized")
      end
      lhs = @variables[lhs] if lhs.match(/[a-z]/) # Dereference variable
    end
	case op
	  when '+'
		  result = lhs + rhs
	  when '-'
		  result = lhs - rhs
	  when '/'
		  result = lhs / rhs
	  when '*'
		  result = lhs * rhs
	end
	return result
  end
  
  def evaluate lineNumber, tokenStack
	# Check for keywords here since binary operations 
    # should have been simplified by now
	error(lineNumber, "Could not evaluate expression") if tokenStack.empty?
	if tokenStack[0].is_a? String and tokenStack[0].match(/print/)
	  # PRINT instruction
	  error(lineNumber, "Operator PRINT applied to empty stack") if tokenStack.size < 2
      result = tokenStack.pop # should be tokenStack[1]
      unless result.class < Numeric or result.match(/[a-z]/) # if result is some type of number
        error(lineNumber, "Invalid operand \"#{result}\"")
      end
	  result = @variables[result] if result.is_a? String and result.match(/[a-z]/) # Dereference variable
      if tokenStack.size > 2
	    error(lineNumber, "#{tokenStack.size - 1} elements left on stack" )
      end
      puts result
	elsif tokenStack[0].is_a? String and tokenStack[0].match(/let/)
	  # LET instruction
      result = tokenStack.pop # tokenStack[2]
	  error(lineNumber, "Operator LET applied to empty stack") if tokenStack.size < 2
	  newVar = tokenStack.pop # tokenStack[1]
	  error(lineNumber, "Could not evaluate expression") unless tokenStack[0].match(/[a-z]/)
	  if tokenStack.size > 2
	    error(lineNumber, "#{tokenStack.size - 1} elements left on stack" )
	  end 
	  @variables[newVar] = result # Put new variable into hash table
	elsif tokenStack[0].is_a? String and tokenStack[0].match(/quit/)
      # QUIT instruction
      exit
	elsif tokenStack[0].is_a? String and tokenStack[0].match(/[^0-9a-z]/)
      # INVALID instruction
      # Anything that isnt a number or letter
	  error(lineNumber, "Invalid keyword #{tokenStack[0]}")
	else
      # If there isn't a keyword, then the bottom of the stack should
	  # be a number 
	  error(lineNumber, "#{tokenStack.size} elements left on stack") unless tokenStack.size == 1
      result = tokenStack[0] 
	end
	if @repl_mode == true
	  puts result # REPL output
	end
  end

  def error lineNumber, message
    if not @repl_mode
      puts "Line #{lineNumber}: " + message
	else 
      puts message
    end
    exit
  end
end
