require_relative 'interpreter'
require_relative 'token_stack'
# Main
if ARGV.count.zero? # REPL mode
  interp = Interpreter.new(true, false)
  stack = TokenStack.new
  interp.repl(0, stack)
end

File.delete('temp.rpn') if File.exist?('temp.rpn')
temp_file = File.new('temp.rpn', 'a')
File.open(temp_file, 'a') # Open in append mode

ARGV.each do |f|
  # Concatenate all files together
  # as per requirement 29
  abort("#{f} does not exist") unless File.exist?(f)
  opened_file = File.open(f, 'r') # Open in read mode
  # Offset is the size of the first file
  File.write(temp_file, opened_file.read, File.size(temp_file))
end
interp = Interpreter.new(false, false) # Runs on initialization
interp.read_file(temp_file)
File.delete(temp_file)
