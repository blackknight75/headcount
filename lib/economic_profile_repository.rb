require 'csv'
require_relative "economic_profile"
require_relative "sanitizer"
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
    ep_key = @economic_profiles[Sanitizer.input_name(row)]
    if ep_key != 0
      ep_data_router(row, symbol, ep_key)
    else
      make_new_economic_profile(row)
    end
  end

  def ep_data_router(row, symbol, ep_key)
    ep_key.median_household_income[Sanitizer.year(row, symbol)]                               = Sanitizer.data(row).to_i if symbol == :median_household_income
    ep_key.children_in_poverty[Sanitizer.poverty_year(row)]                           = Sanitizer.poverty_data(row) if symbol == :children_in_poverty && Sanitizer.poverty_year(row) != nil
    ep_key.free_or_reduced_price_lunch[Sanitizer.year(row)][(Sanitizer.dataformat(row)).to_sym] = Sanitizer.lunch_data(row) if Sanitizer.poverty_level(row) == "Eligible for Free or Reduced Lunch"
    ep_key.title_i[Sanitizer.year(row)]                                               = Sanitizer.data(row).to_f if symbol == :title_i
  end

  def make_new_economic_profile(row)
    ep = EconomicProfile.new(ep_data_framework(Sanitizer.input_name(row)))
    @economic_profiles[Sanitizer.input_name(row)] = ep
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
