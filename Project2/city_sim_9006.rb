
require_relative "Driver"
require_relative "Seed"

# Main
input_array = ARGV

if(input_array.length != 1)
  puts  "Enter a seed and only a seed"
  exit!
end

seed = Seed.new()
rand_seed = seed.getSeedValue(input_array);
puts "Seed : #{rand_seed}"
prng = Random.new(rand_seed)

for i in 1..5 do
  starting_location = prng.rand(1..4)
  driver = Driver.new("Driver #{i}")
  driver.setStart(starting_location)
  continue = true
  while continue
    randBool = prng.rand(0..1)
    horizontal = false
    if(randBool == 1)
      horizontal = true
    end
    continue = driver.drive(horizontal)
  end
  puts driver.displayBooks()
  puts driver.displayDinos()
  puts driver.displayClasses()
end

exit!
