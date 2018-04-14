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
end
