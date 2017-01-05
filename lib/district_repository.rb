require 'csv'
require './lib/district'
class DistrictRepository
  attr_reader :districts

  def initialize(districts = {})
    @districts = districts
  end

  def load_data(path)
    filename = path[:enrollment][:kindergarten]

    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      name = row[:location]  # row[0]
      data = row[:data]      # row[3]
      year = row[:timeframe] # row[1]

      d = District.new({:name => name})

      @districts[name] = d
    end
  end

  def find_by_name(name)
    district = search_districts(name)
    district
  end

  def search_districts(name)
    found_district = nil
    @districts.each_with_index do |district, index|
      if (name.upcase) == district[1].name
        found_district = district[1]
      else
      end
    end
    found_district
  end
end
