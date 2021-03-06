require 'csv'

# More rules can applied here
class ValidateCsv
  include Memery

  def initialize csv_string:
    @csv_string = csv_string
  end

  def call
    return false unless csv_values.size == 4
    true
  end

  private

  memoize def csv_values
    CSV.parse(@csv_string).drop(1).shift
  end
end
