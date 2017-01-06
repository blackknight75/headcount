require 'csv'
require './lib/district'
class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = Hash.new(0)
  end

  def load_data(path)
    filename = path[:enrollment][:kindergarten]
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      name = row[:location]
      d = District.new({:name => name}, self)
      @districts[name] = d if @districts[name] == 0
    end
  end

  def find_by_name(name)
    @districts[(name.upcase)] if @districts[(name.upcase)] != 0
  end

  def find_all_matching(names)
    found_districts = names.map {|name| find_by_name(name)}.compact
  end
end
