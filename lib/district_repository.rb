require 'csv'
require './lib/district'
class DistrictRepository

  def initialize(districts = {})
    @districts = districts
  end

  def load_data(path)
    filename = path[:enrollment][:kindergarten]
    @csv_data = CSV.open(filename, headers: true, header_converters: :symbol)
  end

  def find_by_name(name)
    search_districts(name)
  end

  # def find_all_matching(names)
  #   all_matching = []
  #   names.each do |name|
  #     all_matching << find_by_name(name)
  #   end
  #   all_matching
  # end

  def search_districts(name)
    @districts.each do |district|
      return district[1] if (name.upcase) == district[1].name
      # return nil if (name.upcase) != district[1].name
    end
  end

end
