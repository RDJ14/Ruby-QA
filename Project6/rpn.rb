require_relative "interpreter"

# Main 
repl_mode = false 
repl_mode = true if ARGV.count == 0 # REPL mode
Interpreter.new(repl_mode,ARGV) # Runs on initialization
