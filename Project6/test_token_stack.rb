require 'minitest/autorun'
require_relative 'token_stack'

# Unit tests for token_stack.rb
class TestTokenStack < Minitest::Test

  # Unit test for TokenStack::push(token)
  # Success case: token added to stack as either a String
  # or an Integer
  def test_valid_push
    token_stack = TokenStack.new
    token_stack.push('let')
    assert_equal(token_stack.stack.count, 1)
  end

  # Unit test for TokenStack::pop
  # Success case: removes item from stack
  # Failure case: Stack is empty
  def test_pop
    token_stack = TokenStack.new
    token_stack.stack.push('let')
    token_stack.pop
    assert_equal(token_stack.stack.count, 0)
  end

  def test_empty_pop
    token_stack = TokenStack.new
    token_stack.pop
    assert_equal(token_stack.stack.count, 0)
  end

  # Unit test for TokenStack::get_var
  # Success case: returns a variable
  # Failure case: returns nil
  def test_valid_get_var
    token_stack = TokenStack.new
    token_stack.variables['a'] = 3
    assert_equal(token_stack.get_var('a'), 3)
  end

  def test_invalid_get_var
    token_stack = TokenStack.new
    assert_nil(token_stack.get_var('a'))
  end

  # Test Methods for reset()
  # SUCCESS CASES: The stack is Reset
  # FAILURE CASES: The stack is left with elements
  # =>             The stack is deleted
  def test_reset
    stack = TokenStack.new
    stack.push('0')
    stack.push('1')
    stack.push('2')
    stack.push('3')
    stack.reset

    assert_empty stack
  end

  # Test methods for size()
  # SUCCESS CASES: The number of elements in the stack is returned minus the
  #                keywords
  # FAILURE CASES: Improper count is returned
  # =>             nil is returned
  def test_no_keyword
    stack = TokenStack.new
    stack.push('0')
    stack.push('1')
    stack.push('2')
    stack.push('3')
    stack.push('4')
    stack.push('5')
    count = stack.size
    assert_equal 6, count
  end

  def test_keywords
    stack = TokenStack.new
    stack.push('0')
    stack.push('1')
    stack.push('print')
    stack.push('2')
    stack.push('3')
    stack.push('let')
    stack.push('quit')
    count = stack.size
    assert_equal 4, count
  end

  def test_empty
    stack = TokenStack.new
    count = stack.size
    assert_equal 0, count
  end
end
