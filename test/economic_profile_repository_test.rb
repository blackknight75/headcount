require './test/helper'
require './lib/economic_profile_repository'
require './lib/economic_profile'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_can_create_epr
    epr = EconomicProfileRepository.new
    assert_instance_of EconomicProfileRepository, epr
  end

  def test_can_make_ep_objects
    epr = EconomicProfileRepository.new
  epr.load_data({
    :economic_profile => {
      # :median_household_income => "./data/Median household income.csv",
      # :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
    }
    })
    ep = epr.find_by_name("ACADEMY 20")
    assert_instance_of EconomicProfile, ep
  end
end
