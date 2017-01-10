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
        year    = row[:timeframe].to_i
        data    = row[:data]
        poverty_level = row[:poverty_level]
        dataformat = row[:dataformat]
        lunch_data = lunch_data_selector(row)
        poverty_data = poverty_data_selector(row)
        poverty_year = poverty_year_selector(row)
        make_ep(name, data, year, symbol, poverty_level, dataformat, lunch_data, poverty_data, poverty_year)
      end
    end
    binding.pry
  end

  def poverty_data_selector(row)
    if row[:dataformat] == "Percent"
      row[:data].to_f
    else
      nil
    end
  end

  def poverty_year_selector(row)
    if row[:dataformat] == "Percent"
      row[:timeframe].to_i
    else
      nil
    end
  end

  def lunch_data_selector(row)
    return row[:data].to_f.round(3) if row[:dataformat] == "Percent"
    return row[:data].to_i if row[:dataformat] == "Number"
  end

  def make_ep(name, data, year, symbol, poverty_level, dataformat, lunch_data, poverty_data, poverty_year)
    ep_key = @economic_profiles[name]
    if ep_key != 0
      ep_key.median_household_income[year]     = data.to_i if symbol == :median_household_income
      ep_key.children_in_poverty[poverty_year]         = poverty_data.to_f.round(3) if symbol == :children_in_poverty && poverty_year != nil
      ep_key.free_or_reduced_price_lunch[year][dataformat.to_sym] = lunch_data if poverty_level == "Eligible for Free or Reduced Lunch"
      ep_key.title_i[year]                     = data.to_f if symbol == :title_i
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
