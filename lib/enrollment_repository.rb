require 'csv'
require_relative "enrollment"
require_relative "Clean"
class EnrollmentRepository
  attr_reader :enrollments
  def initialize(enrollments = {})
    @enrollments = enrollments
  end

  def load_data(path)
    path[:enrollment].each do |symbol, file_path|
      CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
        name = row[:location]
        year = row[:timeframe].to_i
        make_enrollments(name.upcase, year, symbol, row)
      end
    end
  end

  def make_enrollments(name, year, symbol, row)
    e_key = @enrollments[name]
    if e_key
      e_key.kindergarten_participation[year] = data(row) if kg_symbol(symbol)
      e_key.high_school_graduation[year]     = data(row) if hs_symbol(symbol)
    else
      d = Enrollment.new(enrollment_data_framework(name, year, row))
      @enrollments[name] = d
    end
  end

  def kg_symbol(symbol)
    symbol == :kindergarten
  end

  def hs_symbol(symbol)
    symbol == :high_school_graduation
  end

  def find_by_name(name)
    @enrollments[name.upcase] if name
  end

  def data(row)
    Clean.truncate_data(row[:data].to_f)
  end

  def enrollment_data_framework(name, year, row)
    {
      :name => name,
      :kindergarten_participation => {year => data(row)},
      :high_school_graduation => Hash.new
    }
  end
end
