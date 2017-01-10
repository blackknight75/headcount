require 'csv'
require './lib/district'
require './lib/enrollment_repository'

class DistrictRepository
  attr_reader :districts, :er

  def initialize
    @districts = Hash.new(0)
    @er = EnrollmentRepository.new
  end

  def load_data(path)
    @er.load_data(path)
    filename = path[:enrollment][:kindergarten]
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      name = row[:location]
      d = District.new({:name => name.upcase}, self)
      @districts[d.name] = d unless @districts.has_key?(name)
    end
    binding.pry
  end

  def find_by_name(name)
    @districts[name.upcase] if @districts.has_key?(name.upcase)
  end

  def find_all_matching(names)
    found_districts = names.map {|name| find_by_name(name)}.compact
  end

  def find_enrollment(name)
    @er.find_by_name(name)
  end
end
