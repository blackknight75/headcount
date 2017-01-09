require 'csv'
require './lib/enrollment'

class EnrollmentRepository
  attr_reader :enrollments
  def initialize(enrollments = {})
    @enrollments = enrollments
  end

  # def truncate_data(float)
  #   float = 0 if float.nan?
  #   (float * 1000).floor / 1000.to_f
  # end

  def load_data(path)
    path[:enrollment].each do |symbol, file_path|
      CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
        name    = row[:location]
        year    = row[:timeframe].to_i
        kg_data = Sanitizer.truncate_data(row[:data].to_f) if symbol == :kindergarten
        hs_data = Sanitizer.truncate_data(row[:data].to_f) if symbol == :high_school_graduation
        make_enrollments(name.upcase, kg_data, hs_data, year, symbol)
      end
    end
  end

  def make_enrollments(name, kg_data, hs_data, year, symbol)
    if @enrollments[name]
      @enrollments[name].kindergarten_participation[year] = kg_data if symbol == :kindergarten
      @enrollments[name].high_school_graduation[year]     = hs_data if symbol == :high_school_graduation
    else
      d = Enrollment.new({:name => name, :kindergarten_participation => {year => kg_data}, :high_school_graduation => Hash.new})
      @enrollments[name] = d
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase] if name
  end


end
