require 'csv'

class CsvValidator
  include Memery

  def initialize csv_string:
    @csv_string = csv_string
  end

  def call
    return false unless values.size == 4
    true
  end

  private

  memoize def values
    CSV.parse(@csv_string).drop(1).shift
  end
end
