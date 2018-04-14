require 'minitest/autorun'
require_relative 'token_stack'

# Unit tests for token_stack.rb
class TestTokenStack < Minitest::Test

  # Unit test for TokenStack::push(token)
  # Success case: token added to stack as either a String
  # or an Integer
  def test_valid_push
    stack = TokenStack.new
    stack.push('let')
    assert_equal(stack.stack.count, 1)
  end

  # Unit test for TokenStack::pop
  # Success case: removes item from stack
  # Failure case: Stack is empty
  def test_pop
    stack = TokenStack.new
    stack.push('let')
    stack.pop
    assert_equal(stack.stack.count, 0)
  end
  
  def test_empty_pop
    stack = TokenStack.new
    stack.pop
    assert_equal(stack.stack.count, 0)
  end
  
end
