require_relative "TokenStack"

class Interpreter

  def initialize repl, args # For using RPN++ in repl mode
    @debug = false
    @operators = ['+', '-', '/', '*']
    @lineNumber = 0
    @repl_mode = repl
	if repl
      stack = TokenStack.new
      loop do
        print "> " # Print avoids the newline
        stackify_input(@lineNumber + 1, gets.chomp, stack)
      end
	else
      # Read file array if we're REPLing
      # Throw error if the file arguments are invalid
	  error(0, "Invalid arguments") if (self.read_all_files(args)).nil?
	end
  end

  def read_all_files filename_array
    return nil unless filename_array.is_a? Array
    filename_array.each { |f|
		error(0, "File \"#{f}\" not found") unless File.exist?(f)
		read_file(f) }
  end

  def read_file filename
    error(0, "Arguments are not valid filenames") unless filename.is_a? String
    file = File.open(filename,"r")
    stack = TokenStack.new # Variables and tokens are reset per file (program)
	file.each_line {|line| break if line.empty?
         stackify_input(@lineNumber + 1, line, stack)} # Calls function per line
  end

  def stackify_input lineNumber, line, stack
	line.downcase! # Make line case insensitive
    line.split.each { |token| # Array-ified line
	  stack.push(token) # Push space-delimited tokens
      if @operators.include? stack.top
        # Do binary op if we reached an operator
		result = binary_operation(lineNumber, stack) # Push result onto top of stack
	    stack.push(result)
      end }
    # Once binary operations are simplified, we can evaluate the stack
    evaluate(lineNumber, stack) 
    stack.reset # Reset since we're going to a new line
  end

  def binary_operation lineNumber, stack
    # Top of stack is an operator
	# Second from top is RHS, third is LHS
	op = stack.pop
	rhs = stack.pop
	lhs = stack.pop
    error(lineNumber, "#{stack.size} elements in stack after evaluation" ) unless @operators.include? op
	error(lineNumber, "Operator #{op} applied to empty stack") if lhs.nil? or rhs.nil?
    if rhs.is_a? String
      error(lineNumber, "Variable #{rhs} is not initialized") if stack.getVar(rhs).nil?
      rhs = stack.getVar(rhs) # Dereference variable
    end
    if lhs.is_a? String
      error(lineNumber, "Variable #{lhs} is not initialized") if stack.getVar(lhs).nil?
      lhs = stack.getVar(lhs) # Dereference variable
    end
	case op
	  when '+'
		  result = lhs + rhs
          puts "DEBUG: #{result} = #{lhs} + #{rhs}" if @debug
	  when '-'
		  result = lhs - rhs
          puts "DEBUG: #{result} = #{lhs} - #{rhs}" if @debug
	  when '/'
		  result = lhs / rhs
	  when '*'
		  result = lhs * rhs
	end
	return result
  end
  
  def evaluate lineNumber, stack
	# Check for keywords here since binary operations 
    # should have been simplified by now
	if stack.bottom.is_a? String and stack.bottom.match(/print/)
	  # PRINT instruction
      error(lineNumber, "Operator PRINT applied to empty stack") if stack.size != 1
      result = stack.pop # should be stack[1]
      unless result.class < Numeric or result.match(/[a-z]/) # if result is some type of number
        error(lineNumber, "Invalid operand \"#{result}\"")
      end
      result = stack.getVar(result) if result.is_a? String # Dereference variable
      if stack.size > 1
	    error(lineNumber, "#{stack.size} elements in stack after evaluation" )
      end
      puts result if not @repl_mode
	elsif stack.bottom.is_a? String and stack.bottom.match(/let/)
	  # LET instruction
      result = stack.pop # stack[2]
	  error(lineNumber, "Operator LET applied to empty stack") if stack.size != 1
	  newVar = stack.pop # stack[1]
	  if stack.size > 1
	    error(lineNumber, "#{stack.size} elements in stack after evaluation" )
	  end
      stack.addVar(newVar, result) # Put new variable into hash table
	elsif stack.bottom.is_a? String and stack.bottom.match(/quit/)
      # QUIT instruction
      exit
	elsif stack.bottom.is_a? String and stack.bottom.match(/[^0-9a-z]/)
      # INVALID instruction
      # Anything that isnt a number or letter
	  error(lineNumber, "Invalid keyword #{stack.bottom}")
	else
	  error(lineNumber, "Could not evaluate expression") if stack.empty?
      # If there isn't a keyword, then the bottom of the stack should
	  # be a number 
	  error(lineNumber, "#{stack.size} elements in stack after evaluation") unless stack.size == 1
      result = stack.bottom 
	end
	if @repl_mode == true
	  puts result # REPL output
	end
  end

  def error lineNumber, message
    if @repl_mode or lineNumber == 0
      # Line 0 is an error that occured before interpretation
      puts message
    else 
      puts "Line #{lineNumber}: " + message
    end
    exit
  end
end
