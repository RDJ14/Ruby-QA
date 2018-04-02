require_relative 'interpreter'

# Main
Interpreter.new(true, nil) if ARGV.count.zero? # REPL mode

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
Interpreter.new(false, temp_file) # Runs on initialization
File.delete(temp_file)
