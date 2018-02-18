

class Coordinates

  #City Strings
    #Locations                  Starting Numbers for RNG     Coordinates
  CATHY_CONST  = "Cathedral"    #1                           [0][2]
  HILL_CONST   = "Hillman"      #2                           [1][1]
  MUSE_CONST   = "Museum"       #3                           [1][2]
  HOSP_CONST   = "Hospital"     #4                           [0][1]
  MONROE_CONST = "Monroeville"  #                            [0][3]
  DOWNT_CONST  = "Downtown"     #                            [1][0]

  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_reader :x
  attr_reader :y

  def setCoordinatesByLocation(location)
      if(location.eql? CATHY_CONST)
        @y = 0
        @x = 2
      elsif (location.eql? HILL_CONST)
        @y = 1
        @x = 1
      elsif (location.eql? MUSE_CONST)
        @y = 1
        @x = 2
      elsif (location.eql? HOSP_CONST)
        @y = 0
        @x = 1
      end
  end

  def moveHorizontal()
    if(@y == 0)
      @x += 1
    elsif(@y == 1)
      @x -= 1
    end
  end

  def moveVertical()
    if(@y == 0)
      @y = 1
    elsif @y == 1
      @y = 0
    end
  end

  def getLocationFromCoords()
    if(@y == 0)
      if(@x == 2)
        return CATHY_CONST
      elsif @x == 1
        return HOSP_CONST
      elsif @x == 3
        return MONROE_CONST
      end
    elsif @y == 1
        if @x == 1
          return HILL_CONST
        elsif @x == 2
          return MUSE_CONST
        elsif @x == 0
          return DOWNT_CONST
        end
      end
    end

end
