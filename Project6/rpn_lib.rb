# RPN Library
class RpnLib
  @operators = ['+', '-', '/', '*']
  @keywords = %w[print let quit]
  def self.unknown_keyword(input)
    # [a-zA-Z] is valid input
    return false if input.length == 1 && input.match?(/[[:alpha:]]/)
    #  All numbers are valid input
    return false if input.match?(/[[:digit:]]+/)
    # Keywords are valid keywords
    return false if @keywords.include?(input)
    # Operators are valid input
    return false if @operators.include?(input)
    true
  end
end
