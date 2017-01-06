require 'csv'
require './lib/enrollment'

class EnrollmentRepository
  attr_reader :enrollments
  def initialize(enrollments = {})
    @enrollments = enrollments
  end

  def load_data(path)
    filename = path[:enrollment][:kindergarten]
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      name = row[:location]
      data = row[:data].to_f
      year = row[:timeframe].to_i
      make_enrollments(name.upcase, data, year)
    end
  end

  def make_enrollments(name, data, year)
    if @enrollments.has_key?(name)
      @enrollments[name].kindergarten_participation[year] = data
    else
      d = Enrollment.new({:name => name, :kindergarten_participation => {year => data}})
      @enrollments[name] = d
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase] if name
  end
end
