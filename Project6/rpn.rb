# Main



class Interpreter

  # HashMap for storing variables, can check if they've been declared
  @repl_mode = false
  @variables = Hash.new
  @tokenStack = Array.new
  @operators = ['+', '-', '/', '*']
  @lineNumber = 0

  def read_file filename
   	error "#{filename} not found" unless File.exist?(filename)
    file = File.open(filename,"r")
	file.foreach(&:add_to_stack) # Calls function per line
  end

  def add_to_stack
	# Pushes tokens from line onto stack
    @lineNumber = @lineNumber + 1
	line.downcase! # Make line case insensitive
    while not line.isEmpty?
	  nextToken = line.chomp!(' ')
	  @tokenStack.push(nextToken) # Push space-delimited tokens
	  if operators.include? @tokenStack[-1]
        # Do binary op if we reached an operator
	    # Push result onto top of stack
	    @tokenStack.push(binary_operation(@lineNumber, @tokenStack))  
	  end
    end

    evalute(@tokenStack)
  end

  def binary_operation lineNumber, tokenStack
    # Top of stack is an operator
	# Second from top is RHS, third is LHS
	op = tokenStack.pop
	rhs = tokenStack.pop
	lhs = tokenStack.pop
    error "Line #{lineNumber}: Invalid operand #{rhs}" unless rhs.is_i? OR rhs.match(/[a-z]/)
    error "Line #{lineNumber}: Invalid operand #{lhs}" unless lhs.is_i? OR lhs.match(/[a-z]/)
	error "Line #{lineNumber}: Variable #{rhs} is not initialized" unless variables.has_key? rhs
	error "Line #{lineNumber}: Variable #{lhs} is not initialized" unless variables.has_key? lhs
    rhs = variables[rhs] if rhs.match(/[a-z]/) # Dereference variable
    lhs = variables[lhs] if lhs.match(/[a-z]/) # Dereference variable
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
  
  def evaluate tokenStack

	# Check for keywords here since binary operations 
    # should have been simplified by now
	error "Line #{lineNumber}: Could not evaluate expression" if tokenStack.isEmpty?
	if tokenStack[0].match(/print/)
	  # Make sure printVar is valid
      printVar = tokenStack[1]
      unless printVar.is_i? OR printVar.match(/[a-z]/)
        error "Line #{lineNumber}: Invalid operand #{printVar}" 
      end
      printVar = variables[printVar] if printVar.match(/[a-z]/) # Dereference variable
      puts printVar
	elsif tokenStack[0].match(/let/)
	  # Make sure letVar is valid
      letVar = tokenStack[1]
	  error "Line #{lineNumber}: Could not evaluate expression" unless letVar.match(/[a-z]/)
	elsif tokenStack[0].match(/quit/)
      exit
	end
	if @repl_mode == true
	  puts = tokenStack[0] if(tokenStack[0].is_a? Integer) # For REPL usage
	end
  end

  def error message
    puts message
    exit
  end
end
