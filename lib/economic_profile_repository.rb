require 'csv'
require './lib/economic_profile'
require './lib/sanitizer'
class EconomicProfileRepository
  attr_reader :economic_profiles

  def initialize
    @economic_profiles = Hash.new(0)

  end

  def load_data(path)
    path[:economic_profile].each do |symbol, file_path|
      CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
        make_ep(row, symbol)
      end
    end
  end

  def find_by_name(name)
    @economic_profiles[name]
  end

  def make_ep(row, symbol)
    ep_key = @economic_profiles[input_name(row)]
    if ep_key != 0
      ep_data_router(row, symbol, ep_key)
    else
      make_new_economic_profile(row)
    end
  end

  def ep_data_router(row, symbol, ep_key)
    ep_key.median_household_income[year(row)]     = data(row).to_i if symbol == :median_household_income
    ep_key.children_in_poverty[poverty_year(row)]         = poverty_data(row) if symbol == :children_in_poverty && poverty_year(row) != nil
    ep_key.free_or_reduced_price_lunch[year(row)][(dataformat(row)).to_sym] = lunch_data(row) if poverty_level(row) == "Eligible for Free or Reduced Lunch"
    ep_key.title_i[year(row)]                     = data(row).to_f if symbol == :title_i
  end

  def make_new_economic_profile(row)
    ep = EconomicProfile.new(ep_data_framework(input_name(row)))
    @economic_profiles[input_name(row)] = ep
  end

  def input_name(row)
    row[:location].upcase
  end

  def poverty_level(row)
    row[:poverty_level]
  end

  def dataformat(row)
    row[:dataformat]
  end

  def year(row)
    row[:timeframe].to_i
  end

  def data(row)
    row[:data]
  end

  def poverty_data(row)
    if row[:dataformat] == "Percent"
      row[:data].to_f.round(3)
    else
      nil
    end
  end

  def poverty_year(row)
    if row[:dataformat] == "Percent"
      row[:timeframe].to_i
    else
      nil
    end
  end

  def lunch_data(row)
    return row[:data].to_f.round(3) if row[:dataformat] == "Percent"
    return row[:data].to_i if row[:dataformat] == "Number"
  end

  def ep_data_framework(name)
    {
      :name => name,
      :median_household_income => Hash.new,
      :children_in_poverty => Hash.new,
      :free_or_reduced_price_lunch => Hash.new { |hash, key| hash[key] = {} },
      :title_i => Hash.new
    }
  end
end
