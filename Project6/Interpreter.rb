require_relative "TokenStack"

class Interpreter

  def initialize repl, filename # For using RPN++ in repl mode
    @debug = false
    @operators = ['+', '-', '/', '*']
    @keywords = ['print', 'let', 'quit']
    @lineNumber = 0
    @repl_mode = repl
	if repl
      repl(TokenStack.new, 0)
	else
      # Read file array if we're REPLing
      # Throw error if the file arguments are invalid
	  read_file(filename)
	end
  end

  def repl stack, lineNumber
      loop do
        print "> " # Print avoids the newline
        stackify_input(lineNumber + 1, gets.chomp, stack)
      end
  end

  def read_file filename
	error("File \"#{filename}\" not found") unless File.exist?(filename)
    file = File.open(filename,"r")
    stack = TokenStack.new # Variables and tokens are reset per file (program)
	file.each_line {|line| 
      # Calls function per line
      @lineNumber = @lineNumber + 1
      # line.lstrip.empty? Checks if there is any non-whitespace characters
      stackify_input(@lineNumber, line, stack) unless line.lstrip.empty?}
  end

  def stackify_input lineNumber, line, stack
    line.split.each { |token| # Array-ified line
      unless (token.length == 1 and token.match?(/[[:alpha:]]/)) or token.match?(/[[:digit:]]+/) or @keywords.include? token  or @operators.include? token
        # The token is not a number, keyword, or single char
        error(4, stack, lineNumber, "Unknown keyword #{token}")
      end
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
    error(3, stack, lineNumber, "#{stack.size} elements in stack after evaluation" ) unless @operators.include? op
	error(2, stack, lineNumber, "Operator #{op} applied to empty stack") if lhs.nil? or rhs.nil?
    if rhs.is_a? String
      error(1, stack, lineNumber, "Variable #{rhs} is not initialized") if stack.getVar(rhs).nil?
      rhs = stack.getVar(rhs) # Dereference variable
    end
    if lhs.is_a? String
      error(1, stack, lineNumber, "Variable #{lhs} is not initialized") if stack.getVar(lhs).nil?
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
	if stack.bottom.is_a? String and stack.bottom.eql?('print')
	  # PRINT instruction
      error(3, stack, lineNumber, "Operator PRINT applied to empty stack") if stack.size != 1
      result = stack.pop # should be stack[1]
      unless result.class < Numeric or result.match?(/[a-z]/) # if result is some type of number
        error(5, stack, lineNumber, "Invalid operand \"#{result}\"")
      end
      result = stack.getVar(result) if result.is_a? String # Dereference variable
      if stack.size > 1
	    error(3, stack, lineNumber, "#{stack.size} elements in stack after evaluation" )
      end
      puts result if not @repl_mode
	elsif stack.bottom.is_a? String and stack.bottom.eql?('let')
	  # LET instruction
      result = stack.pop # stack[2]
	  error(3, stack, lineNumber, "Operator LET applied to empty stack") if stack.size != 1
	  newVar = stack.pop # stack[1]
	  if stack.size > 1
	    error(3, stack, lineNumber, "#{stack.size} elements in stack after evaluation" )
	  end
      stack.addVar(newVar, result) # Put new variable into hash table
	elsif stack.bottom.is_a? String and stack.bottom.eql?('quit')
      # QUIT instruction
      exit
	else
	  error(5, stack, lineNumber, "Could not evaluate expression") if stack.empty?
      # If there isn't a keyword, then the bottom of the stack should
	  # be a number 
	  error(3, stack, lineNumber, "#{stack.size} elements in stack after evaluation") unless stack.size == 1
      result = stack.bottom 
	end
	if @repl_mode == true
	  puts result # REPL output
	end
  end

  def error  message
    puts message
    exit
  end
  def error errorCode, stack, lineNumber, message
    puts "Line #{lineNumber}: " + message
    abort("Exit with error code:#{errorCode}") unless @repl_mode
    stack.reset # Clean up our stack
    repl(stack, lineNumber)
  end
end
