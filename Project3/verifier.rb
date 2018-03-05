require_relative "Block"
require_relative "vericator"

#Main
veri = Vericator.new()

inputArray = ARGV
if(! veri.verify_arg(inputArray))
  puts "Invalid argument. Enter 1 argument that is the file containing the blockchain transactions"
  exit!
end

fileName = inputArray[0]
blocks = veri.read_file(fileName)
blockArray = []
for i in 0..(blocks.length - 1) do
  someBlock = veri.split_block(blocks[i])
  aBlock = Block.create_block(someBlock)
  if(aBlock == nil)
    puts "Block #{i} was not properly formatted"
    exit!
  end
  blockArray[i] = aBlock
end

startingBlockOK = veri.verify_starting_block(blockArray[0])

if(startingBlockOK != true)
  puts startingBlockOK
  exit!
end





exit!
