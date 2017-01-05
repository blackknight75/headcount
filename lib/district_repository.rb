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
      d = District.new({:name => name})
      @districts[name.to_sym] = d
    end
  end

  def find_by_name(name)
    @districts[(name.upcase.to_sym)] if @districts[(name.upcase.to_sym)] != 0
  end

  def find_all_matching(names)
    found_districts = names.map {|name| find_by_name(name)}.compact
  end

end
