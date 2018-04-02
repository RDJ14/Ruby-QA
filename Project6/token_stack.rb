class TokenStack
  def initialize
    @debug = false
    @stack = Array.new
    @keywords = ['print', 'let', 'quit']
    @variables = Hash.new
  end

  def push token
    token.downcase! if token.is_a? String # Case insensitive program
    # Convert string numbers to normal numbers
    token = token.to_i if token.is_a? String and token.match?(/[[:digit:]]+/)
    @stack.push(token)
  end

  def pop
    return @stack.pop
  end

  def reset
    @stack = Array.new
  end

  def bottom
    return @stack[0]
  end

  def top
    return @stack[-1]
  end

  def size
    # Count only NON keyword items
    return @stack.count { |item| not @keywords.include? item }
  end

  def empty?
      return self.size == 0 
  end

  def add_var newVar, value
    puts "DEBUG: adding var:#{newVar} w/ val:#{value}" if @debug
    @variables[newVar] = value
  end

  def get_var var
    puts "DEBUG: returning var:#{var} w/ val:#{@variables[var]}" if @debug
    return @variables[var]
  end
end
