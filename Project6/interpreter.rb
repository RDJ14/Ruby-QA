class Interpreter

  # HashMap for storing variables, can check if they've been declared
  @repl_mode = false
  @variables = Hash.new
  @tokenStack = Array.new
  @operators = ['+', '-', '/', '*']
  @lineNumber = 0

  def initialize repl, args # For using RPN++ in repl mode
    @repl_mode = repl
	if repl
	self.read_all_files(args) # Read file array if we're REPLinga
	else
	  input = gets.chomp
      while not input.downcase.eql? "quit"
        add_to_stack(0, tokenStack)
      end
	end
  end

  def read_all_files filename_array
    unless filename_array.each {|f| f.is_a? String}
      error(lineNumber, "Arguments are not valid filenames")
    end
    filename_array.each {|f| read_file(f)}
  end

  def read_file filename
   	error(lineNumber, "#{filename} not found") unless File.exist?(filename)
    file = File.open(filename,"r")
	file.each_line {|i| @lineNumber = @lineNumber + 1
				 i.add_to_stack(@lineNumber, @tokenStack)} # Calls function per line
  end

  def add_to_stack lineNumber, tokenStack
	# Pushes tokens from line onto stack
    lineNumber = lineNumber + 1
	line.downcase! # Make line case insensitive
    while not line.isEmpty?
	  nextToken = line.chomp!(' ')
	  tokenStack.push(nextToken) # Push space-delimited tokens
	  if operators.include? tokenStack[-1]
        # Do binary op if we reached an operator
	    # Push result onto top of stack
	    tokenStack.push(binary_operation(lineNumber, tokenStack))  
	  end
    end
    evalute(tokenStack)
  end

  def binary_operation lineNumber, tokenStack
    # Top of stack is an operator
	# Second from top is RHS, third is LHS
	op = tokenStack.pop
	rhs = tokenStack.pop
	lhs = tokenStack.pop
	error(lineNumber "Operator #{op} applied to empty stack") if lhs.nil? OR rhs.nil? 
    error(lineNumber "Invalid operand #{rhs}") unless rhs.is_a? Numeric OR rhs.match(/[a-z]/)
    error(lineNumber "Invalid operand #{lhs}") unless lhs.is_a? Numeric OR lhs.match(/[a-z]/)
	error(lineNumber "Variable #{rhs} is not initialized") unless variables.has_key? rhs
	error(lineNumber "Variable #{lhs} is not initialized") unless variables.has_key? lhs
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
	error(lineNumber "Could not evaluate expression") if tokenStack.isEmpty?
	if tokenStack[0].match(/print/)
	  # Print instruction
      result = tokenStack[1]
      unless result.is_a? Numeric OR result.match(/[a-z]/)
        error(lineNumber "Invalid operand #{result}")
      end
      result = variables[result] if result.match(/[a-z]/) # Dereference variable
      if tokenStack.size > 2
	    error(lineNumber "#{tokenStack.size - 1} elements left on stack" )
      end
	  error(lineNumber "Operator PRINT applied to empty stack") if tokenStack.size == 1
      puts result
	elsif tokenStack[0].match(/let/)
	  # Variable assignment
      result = tokenStack[2]
	  newVar = tokenStack[1]
	  error(lineNumber "Could not evaluate expression") unless result.match(/[a-z]/)
	  if tokenStack.size > 2
	    error(lineNumber "#{tokenStack.size - 1} elements left on stack" )
	  end 
	  error(lineNumber "Operator LET applied to empty stack") if tokenStack.size <= 2
	  @variables[newVar] = result # Put new variable itno hash table
	elsif tokenStack[0].match(/quit/)
      exit
	elsif tokenStack[0].match(/[^0-9a-z]/) # Anything that isnt a number or letter
	  error(lineNumber "Invalid keyword #{tokenStack[0]}")
	else
      # If there isn't a keyword, then the bottom of the stack should
	  # be a number 
	  error(lineNumber "#{tokenStack.size} elements left on stack") unless tokenStack.size == 1
      result = tokenStack[0] 
	end
	if @repl_mode == true
	  puts "> " + result # REPL output
	end
  end

  def error lineNumber, message
    if @repl_mode
      puts "Line #{lineNumber}: " + message
	else 
      puts message
    end
    exit
  end
end
