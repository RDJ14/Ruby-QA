
class Seed

  def initialize()
    @seed_num = nil
  end

  def getSeedValue(input_array)
      rand_seed = input_array[0].to_i rescue false
    if(rand_seed.is_a?Integer)
      rand_seed = input_array[0].to_i
    else
      rand_seed = 0
    end
    @seed_num = rand_seed
    return rand_seed
  end

end
