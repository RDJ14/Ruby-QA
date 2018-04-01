require_relative "Interpreter"

# Main 
Interpreter.new(true, nil) if ARGV.count == 0 # REPL mode

tempFile = File.new('temp.rpn', 'a')
File.open(tempFile, 'a') # Open in append mode

ARGV.each { |f|
  # Concatenate all files together
  # as per requirement 29
  abort("#{f} does not exist") unless File.exist?(f)
  openedFile = File.open(f, 'r') # Open in read mode
  File.write(tempFile, openedFile.read, File.size(tempFile)) # Offset is the size of the first file
}
Interpreter.new(false,tempFile) # Runs on initialization
File.delete(tempFile)
