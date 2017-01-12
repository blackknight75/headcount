require 'csv'
require_relative "economic_profile"
require_relative "Clean"
class EconomicProfileRepository
  attr_reader :economic_profiles, :csv_object

  def initialize
    @economic_profiles = Hash.new(0)
    @csv_object = nil

  end

  def load_data(path)
     path[:economic_profile].each do |symbol, file_path|
       CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
         @csv_object = row
         make_ep(row, symbol)
       end
     end
   end

  def find_by_name(name)
    @economic_profiles[name]
  end

  def make_ep(row, symbol)
    ep_key = @economic_profiles[Clean.input_name(row)]
    if ep_key != 0
      ep_data_router(row, symbol, ep_key)
    else
      make_new_economic_profile(row)
    end
  end

  def ep_data_router(row, symbol, ep_key)
    add_income(row, symbol, ep_key) if median_symbol(symbol)
    add_poverty(row, ep_key)        if poverty_symbol(symbol, row)
    add_lunch(row, ep_key)          if lunch_symbol(row)
    add_title_i(row, ep_key)        if title_i_symbol(symbol)
  end

  def title_i_symbol(symbol)
    symbol == :title_i
  end

  def lunch_symbol(row)
    Clean.poverty_level(row) == "Eligible for Free or Reduced Lunch"
  end

  def median_symbol(symbol)
    symbol == :median_household_income
  end

  def poverty_symbol(symbol, row)
    symbol == :children_in_poverty && Clean.pov_year(row) != nil
  end

  def add_income(row, symbol, ep_key)
    ep_key.median_household_income[Clean.year(row, symbol)] = Clean.data(row)
  end

  def add_poverty(row, ep_key)
    ep_key.children_in_poverty[Clean.pov_year(row)] = Clean.pov_data(row)
  end

  def add_lunch(row, ep_key)
    lunch_set = ep_key.free_or_reduced_price_lunch
    lunch_set[Clean.year(row)][(Clean.dataformat(row))] = Clean.lunch_data(row)
  end

  def add_title_i(row, ep_key)
    ep_key.title_i[Clean.year(row)] = Clean.data(row)
  end

  def make_new_economic_profile(row)
    ep = EconomicProfile.new(ep_data_framework(Clean.input_name(row)))
    @economic_profiles[Clean.input_name(row)] = ep
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
