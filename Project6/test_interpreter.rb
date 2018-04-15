require 'minitest/autorun'
require_relative 'interpreter'

# Test methods for the interpreter
class TestInterpreter < Minitest::Test
  # Test Methods for check_null_operation(lhs, rhs)
  # => SUCCESS CASES: If either lhs or rhs is nil then true is returned.
  # =>                If both lhs and rhs are not nil then false
  # => FAILURE CASES: If one of the parameters is nil and false is returned
  # =>                If both paramters are not nil and true is returned
  def test_both_nil
    terp = Interpreter.new(false, true)
    assert terp.check_null_operation(nil, nil)
  end

  def test_one_nil
    terp = Interpreter.new(false, true)
    assert terp.check_null_operation('1', nil)
  end

  def test_both_value
    terp = Interpreter.new(false, true)
    refute terp.check_null_operation('1', '1')
  end

  # Test Methods for binary_operation(line_number, stack)
  # SUCCESS CASES: The top 3 objects on the stack are popped off and evaluated,
  #                the result of them is return.
  # =>             An error is printed if the bottom 2 objects of the stack are
  #                not operands
  # =>             An error is printed if the top of the stack is not an
  #                operator
  # FAILURE CASES: The program crahsed from mishandling any of the 3 objects
  # =>             The incorrect value is returned
  def test_proper_stack
    stack = TokenStack.new
    stack.push('4')
    stack.push('3')
    stack.push('*')
    terp = Interpreter.new(false, true)

    result = terp.binary_operation(0, stack)
    assert_equal 12, result
  end

  def test_bad_operator
    stack = TokenStack.new
    stack.push('4')
    stack.push('3')
    stack.push('#')
    terp = Interpreter.new(false, true)

    result = terp.binary_operation(0, stack)
    assert_equal 'Error', result
  end

  def test_too_few_operands
    stack = TokenStack.new
    stack.push('4')
    stack.push('+')
    terp = Interpreter.new(false, true)
    result = terp.binary_operation(0, stack)
    assert_equal 'Error', result
  end

  def test_no_operator
    stack = TokenStack.new
    stack.push('4')
    stack.push('3')
    terp = Interpreter.new(false, true)
    result = terp.binary_operation(0, stack)
    assert_equal 'Error', result
  end

  # Test Methods for error(error_code, stack, line_number, message)
  # SUCCESS CASES: The line number is printed followed by the message followed
  #                by the error code. The string is returned for tests. Stack is
  #                is reset for repl mode.
  # FAILURE CASES: Nothing is returned
  # =>             The incorrect string is returned
  # =>             Stack is not reset
  def test_error_normal
    stack = TokenStack.new
    expected = 'Line 0: Testing Exit with error code:0'
    terp = Interpreter.new(false, true)
    error = terp.error(0, stack, 0, 'Testing')

    assert_equal expected, error
  end

  def test_error_stack_rest
    stack = TokenStack.new
    stack.push('4')
    stack.push('3')
    terp = Interpreter.new(false, true)
    terp.error(0, stack, 0, 'Testing')

    assert_equal 0, stack.size
  end

  # Test Methods for evaluate_nonstring(line_number, stack)
  # SUCCESS CASES: The bottom of the stack should be returned contatining a
  #                result of an operation
  # =>             'Error' is returned in testing mode for incorrect inputs
  # FAILURE CASES: nil is returned
  # =>             an incorrect value is retured
  def test_right_stack
    stack = TokenStack.new
    stack.push('4')

    terp = Interpreter.new(false, true)
    result = terp.evaluate_nonstring(0, stack)
    assert_equal 4, result
  end

  def test_empty_stack_ns
    stack = TokenStack.new
    terp = Interpreter.new(false, true)

    result = terp.evaluate_nonstring(0, stack)

    assert_equal 'Error', result
  end

  def test_multiple_elements
    stack = TokenStack.new
    stack.push('4')
    stack.push('1')
    terp = Interpreter.new(false, true)

    result = terp.evaluate_nonstring(0, stack)

    assert_equal 'Error', result
  end

  # Test methods for print_keyword(line_number, stack)
  # SUCCESS CASES: If there is one number in the stack, it is printed/returned
  # =>             If there is not one element in the stack 'Error' is returned
  #                in testing mode
  # =>             If there is a string in the stack, nothing is printed
  # FAILURE CASES: The right element is not returned
  # =>             Program crashes, error is not handled
  def test_number_stack
    stack = TokenStack.new
    stack.push('10')
    terp = Interpreter.new(true, true)

    result = terp.print_keyword(0, stack)
    assert_equal 10, result
  end

  def test_string_stack
    stack = TokenStack.new
    stack.push('a')
    terp = Interpreter.new(true, true)

    result = terp.print_keyword(0, stack)
    assert_nil result
  end

  def test_empty_stack_pk
    stack = TokenStack.new
    terp = Interpreter.new(true, true)

    result = terp.print_keyword(0, stack)
    assert_equal 'Error', result
  end

  def test_bigger_stack
    stack = TokenStack.new
    terp = Interpreter.new(true, true)
    stack.push('2')
    stack.push('3')

    result = terp.print_keyword(0, stack)
    assert_equal 'Error', result
  end

  # Test methods for verify_arg(arg, stack, line_number)
  # SUCCESS CASES: Arg is returned in proper format whether it was a
  #                variable or a number
  # =>             If arg was an unitialized variable, 'Error' is
  #                returned in test mode
  # FAILURE CASES: The wrong arg is returned, or nil is returned
  def test_number_passed
    stack = TokenStack.new
    terp = Interpreter.new(false, true)
    returned = terp.verify_arg(4, stack, 0)

    assert_equal 4, returned
  end

  def test_initialized_var
    stack = TokenStack.new
    stack.add_var('a', 10)
    terp = Interpreter.new(false, true)
    returned = terp.verify_arg('a', stack, 0)

    assert_equal 10, returned
  end

  def test_unitialized_var
    stack = TokenStack.new
    terp = Interpreter.new(false, true)
    returned = terp.verify_arg('a', stack, 0)

    assert_equal 'Error', returned
  end

  
end
