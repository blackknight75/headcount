require 'csv'
require './lib/district'
class DistrictRepository

  def initialize(districts = {})
    @districts = districts
  end

  def load_data(path)
    filename = path[:enrollment][:kindergarten]
    district_collection = [""]
    @csv_data = CSV.open(filename, headers: true, header_converters: :symbol)
  end

  def find_by_name(name)
    district = search_districts(name)
    district
  end

  def search_districts(name)
    found_district = ""
    @districts.each_with_index do |district, index|
      if (name.upcase) == district[1].name
        found_district = district[1]
      else
      end
    end
    found_district
  end
end
