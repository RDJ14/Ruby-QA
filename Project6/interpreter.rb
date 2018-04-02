require_relative 'token_stack'

class Interpreter
  def initialize(repl, filename)
    @debug = false
    @operators = ['+', '-', '/', '*']
    @keywords = %w(print let quit)
    @line_number = 0
    @repl_mode = repl
    if repl
      repl(TokenStack.new, 0)
    else
      # Read file array if we're REPLing
      # Throw error if the file arguments are invalid
      read_file(filename)
    end
  end

  def repl(stack, line_number)
    loop do
      print '> ' # Print avoids the newline
      stackify_input(line_number + 1, gets.chomp, stack)
    end
  end

  def read_file(filename)
    error("File \"#{filename}\" !found") unless File.exist?(filename)
    file = File.open(filename, 'r')
    stack = TokenStack.new # Variables and tokens are reset per file (program)
    file.each_line do |line|
      # Calls function per line
      @line_number += 1
      # line.lstrip.empty? Checks if there is any non-whitespace characters
      stackify_input(@line_number, line, stack) unless line.lstrip.empty?
    end
  end

  def stackify_input(line_number, line, stack)
    line.split.each do |token| # Array-ified line
      unless (token.length == 1 && token.match?(/[[:alpha:]]/)) ||
             token.match?(/[[:digit:]]+/) ||
              @keywords.include?(token) ||
             @operators.include?(token)
        # The token is not a number, keyword, or single char
        error(4, stack, line_number, "Unknown keyword #{token}")
      end
      stack.push(token) # Push space-delimited tokens
      if @operators.include?(stack.top)
        # Do binary op if we reached an operator
        result = binary_operation(line_number, stack)
        stack.push(result) # Push result onto top of stack
      end
    end
    evaluate(line_number, stack)
    stack.reset # Reset since we're going to a new line
  end

  def binary_operation(line_number, stack)
    op = stack.pop
    rhs = stack.pop
    lhs = stack.pop
    unless @operators.include? op
      error(3, stack, line_number,
            "#{stack.size} elements in stack after evaluation")
    end
    if lhs.nil? || rhs.nil?
      error(2, stack, line_number, "Operator #{op} applied to empty stack")
    end
    if rhs.is_a?(String)
      if stack.get_var(rhs).nil?
        error(1, stack, line_number, "Variable #{rhs} is not initialized")
      end
      rhs = stack.get_var(rhs) # Dereference variable
    end
    if lhs.is_a?(String) 
      if stack.get_var(lhs).nil?
        error(1, stack, line_number, "Variable #{lhs} is not initialized")
      end
      lhs = stack.get_var(lhs) # Dereference variable
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

  def evaluate(line_number, stack)
    # Check for keywords here since binary operations
    if (stack.bottom.is_a? String) && stack.bottom.eql?('print')
      # PRINT instruction
      if stack.size != 1
        error(3, stack, line_number, 'Operator PRINT applied to empty stack')
      end
      result = stack.pop # should be stack[1]
      unless result.class < Numeric ||
             result.match?(/[a-z]/) # if result is some type of number
        error(5, stack, line_number, "Invalid operand \"#{result}\"")
      end
      if result.is_a? String # Dereference variable
        result = stack.get_var(result)
      end
      if stack.size > 1
        error(3, stack, line_number,
              "#{stack.size} elements in stack after evaluation")
      end
      puts result unless @repl_mode
    elsif (stack.bottom.is_a? String) && stack.bottom.eql?('let')
      # LET instruction
      result = stack.pop # stack[2]
      if stack.size != 1
        error(3, stack, line_number,
              'Operator LET applied to empty stack')
      end
      new_var = stack.pop # stack[1]
      if stack.size > 1
        error(3, stack, line_number,
              "#{stack.size} elements in stack after evaluation")
      end
      stack.add_var(new_var, result) # Put new variable into hash table
    elsif (stack.bottom.is_a? String) && stack.bottom.eql?('quit')
      # QUIT instruction
      exit
    else
      if stack.empty?
        error(5, stack, line_number, 'Could not evaluate expression')
      end
      # If there isn't a keyword, then the bottom of the stack should
      # be a number
      unless stack.size == 1
        error(3, stack, line_number,
              "#{stack.size} elements in stack after evaluation")
      end
      result = stack.bottom
    end
    if @repl_mode == true
      puts result # REPL output
    end
  end

  def error(message)
    puts message
    exit
  end

  def error(error_code, stack, line_number, message)
    puts "Line #{line_number}: " + message
    abort("Exit with error code:#{error_code}") unless @repl_mode
    stack.reset # Clean up our stack
    repl(stack, line_number)
  end
end
