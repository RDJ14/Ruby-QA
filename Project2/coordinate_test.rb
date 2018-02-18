require "minitest/autorun"

require_relative "Coordinates"

class TestCoordinate < Minitest::Test

  # Unit tests for setCoordinatesByLocation(String)
  # Entering a predefined location string should set the driver's coordinates to the corresponding locations
  # Entering invalid strings leave the coordinates as they are
  # SUCCESS CASES : The entered string is one of the predefined location strings
  # FAILURE CASES : The entered value is not one of the predefined location strings

  #Test setting the coordinates for locations that exist
  def test_defined_location
    coordinates1 = Coordinates.new(-1, -1)
    coordinates2 = Coordinates.new(-1, -1)

    coordinates1.setCoordinatesByLocation(Coordinates::CATHY_CONST)
    coordinates2.setCoordinatesByLocation(Coordinates::MUSE_CONST)

    assert_equal coordinates1.y, 0
    assert_equal coordinates1.x, 2
    assert_equal coordinates2.y, 1
    assert_equal coordinates2.x, 2
  end

  def test_undefined_location
    coordinates1 = Coordinates.new(-1, -1)

    coordinates1.setCoordinatesByLocation("Not a location")

    assert_equal coordinates1.x, -1
    assert_equal coordinates1.y, -1
  end

  # Unit tests for moveHorizontal()
  # SUCCESS CASES : The x value is increased if the y value is 0
  #               : The x value is decreased if the y value is 1
  # FAILURE CASES : The x value is not upadted properly
  # =>            : The y value is changed

  def test_moving_horizontal_top_row
    cd = Coordinates.new(0, 0)
    cd.moveHorizontal()

    assert_equal cd.x, 1
    assert_equal cd.y, 0
  end

  def test_moving_horizontal_bottom_row
    cd = Coordinates.new(2, 1)
    cd.moveHorizontal()

    assert_equal cd.x, 1
    assert_equal cd.y, 1
  end

  # Unit tests for moveVertical()
  # SUCCESS CASES : The y value is changed from 1 -> 0 or from 0 -> 1
  # FAILURE CASES : The y value is not updated properly
  # =>            : The x value is changed

  def test_moving_vertical_from_top
    cd = Coordinates.new(0, 0)
    cd.moveVertical()

    assert_equal cd.y, 1
    assert_equal cd.x, 0
  end

  def test_moving_vertical_from_bot
    cd = Coordinates.new(0, 1)
    cd.moveVertical()

    assert_equal cd.y, 0
    assert_equal cd.x, 0
  end

  # Unit tests for getLocationFromCoords()
  # SUCCESS CASES : A predefined location is returned if the coordinates match one of them
  # =>            : nil is returned if the coordinates do not match a predefined location
  # FAILURE CASES : nil is returned when the coordinates match a predefined locations
  # =>            : a predefined location is returned for incorrect coordinates

  def test_defined_coordinates
    cathy = Coordinates.new(2, 0)
    muse = Coordinates.new(2, 1)

    assert_equal Coordinates::CATHY_CONST, cathy.getLocationFromCoords()
    assert_equal Coordinates::MUSE_CONST, muse.getLocationFromCoords()
  end

  def test_undefined_coordinates
    cd = Coordinates.new(-1, -1)

    assert_nil cd.getLocationFromCoords()
  end

end
