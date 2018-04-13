# Token Stack holds the stack of tokens read in
class TokenStack
  def initialize
    @debug = false
    @stack = Array[]
    @keywords = %w[print let quit]
    @variables = {}
  end

  def push(token)
    token.downcase! if token.is_a? String # Case insensitive program
    # Convert string numbers to normal numbers
    token = token.to_i if (token.is_a? String) && token.match?(/[[:digit:]]+/)
    @stack.push(token)
  end

  def pop
    @stack.pop
  end

  def reset
    @stack = Array[]
  end

  def bottom
    @stack[0]
  end

  def top
    @stack[-1]
  end

  def size
    # Count only NON keyword items
    @stack.count { |item| !@keywords.include? item }
  end

  def empty?
    size.zero?
  end

  def add_var(new_var, value)
    puts "DEBUG: adding var:#{new_var} w/ val:#{value}" if @debug
    @variables[new_var] = value
  end

  def get_var(var)
    puts "DEBUG: returning var:#{var} w/ val:#{@variables[var]}" if @debug
    @variables[var]
  end
end
