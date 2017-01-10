require 'csv'
require './lib/economic_profile'
require './lib/sanitizer'
class EconomicProfileRepository

  def initialize
    @economic_profiles = Hash.new(0)

  end

  def load_data(path)
    path[:economic_profile].each do |symbol, file_path|
      CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
        name    = row[:location].upcase
        year    = row[:timeframe]
        data    = row[:data].to_i
        poverty_level = row[:poverty_level]
        dataformat = row[:dataformat]
        lunch_data = lunch_data_selector(row)
        make_ep(name, data, year, symbol, poverty_level, dataformat, lunch_data)
      end
    end
    binding.pry
  end

  def lunch_data_selector(row)
    return percentage = row[:data].to_f if row[:dataformat] == "Percent"
    return total      = row[:data].to_i if row[:dataformat] == "Number"
  end

  def make_ep(name, data, year, symbol, poverty_level, dataformat, lunch_data)
    ep_key = @economic_profiles[name]
    if ep_key != 0
      ep_key.median_household_income[year]     = data if symbol == :median_household_income
      ep_key.children_in_poverty[year]         = data if symbol == :children_in_poverty
      ep_key.free_or_reduced_price_lunch[year][dataformat.to_sym] = lunch_data if poverty_level == "Eligible for Free or Reduced Lunch"
      ep_key.title_i[year]                     = data if symbol == :title_i
    else
    ep_data = {
      :name => name,
      :median_household_income => Hash.new,
      :children_in_poverty => Hash.new,
      :free_or_reduced_price_lunch => Hash.new { |hash, key| hash[key] = {} },
      :title_i => Hash.new
      }
      ep = EconomicProfile.new(ep_data)
      @economic_profiles[name] = ep
    end
  end
end
