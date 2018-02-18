
require_relative "Coordinates"

class Driver

  #City Strings
    #Locations                  Starting Numbers for RNG     Coordinates
  CATHY_CONST  = "Cathedral"    #1                           [0][2]
  HILL_CONST   = "Hillman"      #2                           [1][1]
  MUSE_CONST   = "Museum"       #3                           [1][2]
  HOSP_CONST   = "Hospital"     #4                           [0][1]
  MONROE_CONST = "Monroeville"  #                            [0][3]
  DOWNT_CONST  = "Downtown"     #                            [1][0]

    #Street Names
  FIFTH_CONST  = "Fifth Ave."
  FOOST_CONST  = "Foo St."
  BARST_CONST  = "Bar St."
  FOURTH_CONST = "Fourth Ave."

  def initialize(name)
    @name = name
    @num_classes = 1
    @num_books = 0
    @num_dino = 0
    @current_location = ""
    @current_coords = Coordinates.new(-1, -1)
    # city_array[0][x] x must increase (fouth ave.)        city_array[0][1] <--> city_array[1][1]  foo st.
    # city_array[1][x] x must decrease (fifth ave.)        city_array[0][2] <--> city_array[1][2] bar st.
    @city_array = [[nil, HOSP_CONST, CATHY_CONST, MONROE_CONST], [DOWNT_CONST, HILL_CONST, MUSE_CONST, nil]]
  end

  attr_reader :name
  attr_reader :num_classes
  attr_reader :num_books
  attr_reader :num_dino
  attr_reader :current_location
  attr_reader :current_coords

  attr_accessor :num_classes
  attr_accessor :num_dino
  attr_accessor :num_books
  attr_accessor :current_coords

  def setStart(starting_location)
      if(starting_location == 1)
        @current_location = CATHY_CONST
        self.arrivedCathy()
      elsif (starting_location == 2)
        @current_location = HILL_CONST
        self.arrivedHill()
      elsif (starting_location == 3)
        @current_location = MUSE_CONST
        self.arrivedMus()
      elsif (starting_location == 4)
        @current_location = HOSP_CONST
      end
      @current_coords.setCoordinatesByLocation(@current_location)
  end

  def displayClasses()
    if (@num_classes > 1)
      return "#{@name} attended #{@num_classes} classes!"
    else
      return "#{@name} attended #{@num_classes} class!"
    end
  end

  def displayBooks()
    if(@num_books == 1)
        return "#{@name} recieved #{@num_books} book!"
    else
        return "#{@name} recieved #{@num_books} books!"
    end
  end

  def displayDinos()
    if(@num_dino == 1)
        return "#{@name} recieved #{@num_dino} dinosaur toy!"
    else
        return "#{@name} recieved #{@num_dino} dinosaur toys!"
    end
  end

  def displayRoute(goingTo, horizontal)
    if(horizontal)
      if(@current_coords.y == 0)
        return "#{@name} heading from #{@current_location} to #{goingTo} via #{FOURTH_CONST}"
      elsif(@current_coords.y == 1)
        return "#{@name} heading from #{@current_location} to #{goingTo} via #{FIFTH_CONST}"
      end
    else
      if(@current_coords.y == 0)
        if(@current_coords.x == 1)
          return "#{@name} heading from #{@current_location} to #{goingTo} via #{FOOST_CONST}"
        elsif @current_coords.x == 2
          return "#{@name} heading from #{@current_location} to #{goingTo} via #{BARST_CONST}"
        end
      elsif (@current_coords.y == 1)
        if(@current_coords.x == 1)
          return "#{@name} heading from #{@current_location} to #{goingTo} via #{FOOST_CONST}"
        elsif @current_coords.x == 2
          return "#{@name} heading from #{@current_location} to #{goingTo} via #{BARST_CONST}"
        end
      end
    end
  end

  def drive(horizontal)
    if(horizontal)
        @current_coords.moveHorizontal();
        goingTo = @current_coords.getLocationFromCoords()
        puts displayRoute(goingTo, horizontal)
        @current_location = goingTo
        if(goingTo.eql? MONROE_CONST)
          return false
        elsif goingTo.eql? DOWNT_CONST
          return false
        end
    else
        @current_coords.moveVertical()
        goingTo = @current_coords.getLocationFromCoords()
        puts displayRoute(goingTo, horizontal)
        @current_location = goingTo
    end
    if(goingTo == CATHY_CONST)
      self.arrivedCathy()
    elsif goingTo == MUSE_CONST
      self.arrivedMus()
    elsif goingTo == HILL_CONST
      self.arrivedHill
    end
    return true
  end

  def arrivedCathy()
      @num_classes = @num_classes * 2
  end

  def arrivedMus()
      @num_dino += 1
  end

  def arrivedHill()
      @num_books += 1
  end


end
