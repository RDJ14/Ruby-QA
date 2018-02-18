require "minitest/autorun"

require_relative "driver"

class TestDriver < Minitest::Test

  def test_driver_is_a_driver
    driver = Driver.new("TestDriver")
    assert driver.is_a?(Driver)
  end

  def test_driver_new_not_nil
    driver = Driver::new("test")
    refute_nil driver
  end
  # Unit test for setStart(x)
  # Entering an integer 1-4 will set the location to one of the predefined strings
  # Equivalence Classes
  # x = 1..4 -> sets the location to a predefined location
  # x = anything else -> the drivers location remains blank

  #If one of the predefined locations are passed in, the drivers location should be set to that string
  def test_defined_constants_location

      driver1 = Driver.new("TestDriver 1")
      driver2 = Driver.new("TestDriver 2")

      driver1.setStart(1)
      driver2.setStart(2)

      assert_equal "Cathedral", driver1.current_location
      assert_equal "Hillman", driver2.current_location
  end

  #If a valid location is not passed in, then the drivers location should be left blank
  def test_undefined_location
      driver = Driver.new("TestDriver")

      driver.setStart(-1)

      assert_equal "", driver.current_location
  end

  # Unit test for displayClasses
  # SUCCESS CASES : If a driver has > 1 class, the display message should display plural.
  #               : If a driver has 1 class, the singluar message should be displayed
  # FAILURE CASES : The returned string does not have the matching grammar for the proper amount

  def test_single_class
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver attended 1 class!"

    assert_equal driver1.displayClasses, correctString
  end

  def test_multiple_classes
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver attended 2 classes!"

    driver1.num_classes = 2

    assert_equal driver1.displayClasses, correctString
  end

  # Unit test for displayBooks
  # SUCCESS CASES : If a driver has > 1 book or 0 books, the display message should display plural.
  #               : If a driver has 1 book, the singluar message should be displayed
  # FAILURE CASES : The returned string does not have the matching grammar for the proper amount

  #EDGE CASE
  def test_no_book
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver recieved 0 books!"

    assert_equal driver1.displayBooks, correctString
  end

  def test_single_book
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver recieved 1 book!"

    driver1.num_books = 1

    assert_equal driver1.displayBooks, correctString
  end

  def test_multiple_books
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver recieved 2 books!"

    driver1.num_books = 2

    assert_equal driver1.displayBooks, correctString
  end

  # Unit test for displayBooks
  # SUCCESS CASES : If a driver has > 1 dino or 0 dinos, the display message should display plural.
  #               : If a driver has 1 dino, the singluar message should be displayed
  # FAILURE CASES : The returned string does not have the matching grammar for the proper amount

  #EDGE CASE
  def test_no_dino
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver recieved 0 dinosaur toys!"

    assert_equal driver1.displayDinos, correctString
  end

  def test_single_dino
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver recieved 1 dinosaur toy!"

    driver1.num_dino = 1

    assert_equal driver1.displayDinos, correctString
  end

  def test_multiple_dinos
    driver1 = Driver.new("TestDriver")
    correctString = "TestDriver recieved 2 dinosaur toys!"

    driver1.num_dino = 2

    assert_equal driver1.displayDinos, correctString
  end


  # Unit test for drive(x)
  # SUCCESS CASES : If x = true, the driver should move horizontally, if this causes the driver to leave
  # =>              then the method should return true. Otherwise false
  # FAILURE CASES : If the method does not return the proper bool based on the drivers location

  def test_drive_horizontal_in_city
    driver1 = Driver.new("TestDriver")

    driver1.setStart(3) #Museum

    assert driver1.drive(true)
  end

  def test_drive_horizontal_out_city

    driver1 = Driver.new("TestDriver")

    driver1.setStart(2) #Hillman

    refute driver1.drive(true)
  end

  def test_drive_vertical
    driver1 = Driver.new("TestDriver")

    driver1.setStart(2) #Hillman

    assert driver1.drive(false)
  end
  # Unit test for displayRoute(goingTo, horizontal)
  # SUCCESS CASES : If a predefined location is passed as goingTo and a boolean is passed to horizontal, the route
  # =>             the driver took should be returned
  # =>            : If a non-predefined location is passsed nothing is returned
  # FAILURE CASES : The proper route is not returned for a location

  def test_display_of_defined_location_horizontal
    driver = Driver.new("TestDriver")
    cd = Minitest::Mock.new
    def cd.y; 0; end
    def cd.x; 1; end
    driver.current_coords = cd
    driver.current_location = Driver::HOSP_CONST
    correctRoute = "TestDriver heading from Hospital to Cathedral via Fourth Ave."

    route = driver.displayRoute(Driver::CATHY_CONST, true)

    assert_equal correctRoute, route
  end

  def test_display_of_defined_location_vertical
    driver = Driver.new("TestDriver")
    cd = Minitest::Mock.new

    def cd.y; 0; end
    def cd.x; 1; end
    driver.current_coords = cd
    driver.current_location = Driver::HOSP_CONST
    correctRoute = "TestDriver heading from Hospital to Hillman via Foo St."

    route = driver.displayRoute(Driver::HILL_CONST, false)

    assert_equal correctRoute, route
  end

  def test_display_non_defined_location
    driver = Driver.new("TestDriver")

    route = driver.displayRoute("Not a Place", false)

    assert_nil route
  end

  # Unit test for arrivedCathy()
  # SUCCESS CASES: The drivers number of classes should be doubled
  # FAILURE CASES: The drivers number of classes is not doubled

  def test_classes_updated
    driver = Driver.new("TestDriver")
    driver.num_classes = 2

    driver.arrivedCathy()

    assert_equal 4, driver.num_classes
  end

  # Unit test for arrivedMus()
  # SUCCESS CASES: The drivers number of dinos should be increased by 1
  # FALUURE CASES: The drivers number of dinos doesn't increase by 1

  def test_classes_updated
    driver = Driver.new("TestDriver")
    driver.num_dino = 2

    driver.arrivedMus()

    assert_equal 3, driver.num_classes
  end

  # Unit test for arrivedHill()
  # SUCCESS CASES: The drivers number of books should be increased by 1
  # FALUURE CASES: The drivers number of books doesn't increase by 1

  def test_classes_updated
    driver = Driver.new("TestDriver")
    driver.num_books = 2

    driver.arrivedHill()

    assert_equal 3, driver.num_books
  end

end
