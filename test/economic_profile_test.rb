require './test/helper'
require_relative "../../headcount/lib/economic_profile"

class EconomicProfileTest < Minitest::Test

  def test_can_create_economic_profile
    ep = EconomicProfile.new({
      :name => "name",
      :median_household_income => Hash.new,
      :children_in_poverty => Hash.new,
      :free_or_reduced_price_lunch => Hash.new { |hash, key| hash[key] = {} },
      :title_i => Hash.new
    })
    assert_instance_of EconomicProfile, ep
  end


end
