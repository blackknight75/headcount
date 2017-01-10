require 'csv'
require_relative "enrollment"
require_relative "sanitizer"
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
    if @enrollments[name]
      @enrollments[name].kindergarten_participation[year] = data(row) if symbol == :kindergarten
      @enrollments[name].high_school_graduation[year]     = data(row) if symbol == :high_school_graduation
    else
      d = Enrollment.new({:name => name, :kindergarten_participation => {year => data(row)}, :high_school_graduation => Hash.new})
      @enrollments[name] = d
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase] if name
  end

  def data(row)
    Sanitizer.truncate_data(row[:data].to_f)
  end
end
