require_relative 'token_stack'
require_relative 'rpn_lib'

# Interprets the input of the data
class Interpreter
  def initialize(repl, testing)
    @operators = ['+', '-', '/', '*']
    @keywords = %w[print let quit]
    @line_number = 0
    @repl_mode = repl
    @test_mode = testing
  end

  def repl(line_number, stack)
    loop do
      print '> ' # Print avoids the newline
      stackify_input(line_number + 1, gets.chomp, stack)
    end
  end

  def read_file(filename)
    file = File.open(filename, 'r')
    stack = TokenStack.new # Variables and tokens are reset per file (program)
    file.each_line do |line|
      # line.lstrip.empty? Checks if there is any non-whitespace characters
      stackify_input(@line_number += 1, line, stack) unless line.lstrip.empty?
    end
  end

  def stackify_input(line_number, line, stack)
    line.split.each do |token| # Array-ified line
      unless stack.bottom.eql?('quit')
        if RpnLib.unknown_keyword(token)
          # The token is not a number, keyword, or single char
          error(4, stack, line_number, "Unknown keyword #{token}")
        end
      end
      stack.push(token) # Push space-delimited tokens
      if @operators.include?(stack.top) # op at top of stack
        stack.push(binary_operation(line_number, stack)) # Push result on top
      end
    end
    evaluate(line_number, stack)
  end

  def check_null_operation(lhs, rhs)
    true if lhs.nil? || rhs.nil?
  end

  def verify_arg(arg, stack, line_number)
    if arg.is_a?(String)
      if stack.get_var(arg).nil?
        error(1, stack, line_number, "Variable #{arg} is not initialized")
        return 'Error'
      end
      arg = stack.get_var(arg) # Dereference variable
    end
    arg
  end

  def binary_operation(line_number, stack)
    op = stack.pop
    rhs = stack.pop
    lhs = stack.pop
    unless @operators.include? op
      error(3, stack, line_number,
            "#{stack.size} elements in stack after evaluation")
      return 'Error'
    end
    if check_null_operation(lhs, rhs)
      error(5, stack, line_number, 'Could not evaluate expression')
      return 'Error'
    end
    rhs = verify_arg(rhs, stack, line_number)
    lhs = verify_arg(lhs, stack, line_number)
    result = lhs.send(op, rhs)
    result
  end

  def print_keyword(line_number, stack)
    # PRINT instruction
    size = stack.size
    if size != 1
      error(2, stack, line_number,
            'Operator PRINT applied to empty stack')
      return 'Error'
    end
    result = stack.pop # should be stack[1]
    unless result.class < Numeric ||
           result.match?(/[a-z]/) # if result is some type of number
      error(5, stack, line_number, "Invalid operand \"#{result}\"")
      return 'Error'
    end
    # Dereference variable
    result = stack.get_var(result) if result.is_a? String
    if size > 1
      error(3, stack, line_number,
            "#{size} elements in stack after evaluation")
      return 'Error'
    end
    puts result unless @repl_mode
    result
  end

  def let_keyword(line_number, stack)
    result = stack.pop # stack[2]
    result = stack.get_var(result) if result.is_a?(String)
    size = stack.size
    if size != 1
      error(2, stack, line_number, 'Operator LET applied to empty stack')
    end
    new_var = stack.pop # stack[1]
    if size > 1
      error(3, stack, line_number, "#{size} elements in stack after evaluation")
    end
    stack.add_var(new_var, result) # Put new variable into hash table
    print result if @repl_mode == true
  end

  def evaluate(line_number, stack)
    result = evaluate_string(line_number, stack) if stack.bottom.is_a?(String)
    unless stack.bottom.is_a?(String)
      result = evaluate_nonstring(line_number, stack)
    end
    puts result if @repl_mode == true
    stack.reset # Reset since we're going to a new line
  end

  def evaluate_string(line_number, stack)
    if stack.bottom.eql?('print')
      print_keyword(line_number, stack)
    elsif stack.bottom.eql?('let')
      let_keyword(line_number, stack)
    elsif stack.bottom.eql?('quit')
      exit # QUIT instruction
    end
  end

  def evaluate_nonstring(line_number, stack)
    if stack.empty?
      error(5, stack, line_number, 'Could not evaluate expression')
      return 'Error'
    end
    # If there wasn't a keyword, stack bottom should be a number
    unless stack.size == 1
      error(3, stack, line_number,
            "#{stack.size} elements in stack after evaluation")
      return 'Error'
    end
    stack.bottom # result of the operation
  end

  def error(error_code, stack, line_number, message)
    output = "Line #{line_number}: " + message
    puts(output) unless @test_mode
    exit(error_code) unless @repl_mode || @test_mode
    stack.reset # Clean up our stack
    repl(line_number, stack) unless @test_mode
    output
  end
end
