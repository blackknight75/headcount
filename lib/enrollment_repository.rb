require 'csv'
require './lib/enrollment'
require './lib/sanitizer'
class EnrollmentRepository
  attr_reader :enrollments
  def initialize(enrollments = {})
    @enrollments = enrollments
  end

  def load_data(path)
    path[:enrollment].each do |symbol, file_path|
      CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
        name    = row[:location]
        year    = row[:timeframe].to_i
        data = Sanitizer.truncate_data(row[:data].to_f)
        make_enrollments(name.upcase, data, year, symbol)
      end
    end
  end

  def make_enrollments(name, data, year, symbol)
    if @enrollments[name]
      @enrollments[name].kindergarten_participation[year] = data if symbol == :kindergarten
      @enrollments[name].high_school_graduation[year]     = data if symbol == :high_school_graduation
    else
      d = Enrollment.new({:name => name, :kindergarten_participation => {year => data}, :high_school_graduation => Hash.new})
      @enrollments[name] = d
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase] if name
  end


end
