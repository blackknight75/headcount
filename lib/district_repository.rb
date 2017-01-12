require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

class DistrictRepository
  attr_reader :districts, :er

  def initialize
    @districts = {}
    @er = EnrollmentRepository.new
    @str = StatewideTestRepository.new
    @epr = EconomicProfileRepository.new
  end

  def load_data(path)
    load_repos(path)
    filename = path[:enrollment][:kindergarten]
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      d = District.new({:name => name.upcase}, self)
      @districts[d.name] = d unless @districts.has_key?(name)
    end
  end

  def load_repos(path)
    @er.load_data(path)  unless path[:enrollment].nil?
    @str.load_data(path) unless path[:statewide_testing].nil?
    @epr.load_data(path) unless path[:economic_profile].nil?
  end

  def find_by_name(name)
    @districts[name.upcase]
  end

  def find_all_matching(prefix)
    found = Array.new
    if prefix.empty? || prefix.nil?
    else
      @districts.each {|k, v| found << v if k.start_with?(prefix)}
    end
    found
  end

  def find_enrollment(name)
    @er.find_by_name(name)
  end

  def find_statewide_test(name)
    @str.find_by_name(name)
  end

  def find_economic_profile(name)
    @epr.find_by_name(name)
  end
end
