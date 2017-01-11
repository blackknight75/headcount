require './test/helper'
require_relative "../../headcount/lib/economic_profile_repository"
require_relative "../../headcount/lib/economic_profile"

class EconomicProfileRepositoryTest < Minitest::Test

  def test_can_create_epr
    epr = EconomicProfileRepository.new
    assert_instance_of EconomicProfileRepository, epr
  end

  def test_can_make_ep_objects
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./test/fixtures/median_income.csv",
      :children_in_poverty => "./test/fixtures/children_poverty.csv",
      :free_or_reduced_price_lunch => "./test/fixtures/lunch.csv",
      :title_i => "./test/fixtures/title.csv"
    }
    })
    ep = epr.find_by_name("ACADEMY 20")
    assert_instance_of EconomicProfile, ep
    assert_equal "ACADEMY 20", ep.name
  end

  def test_enrollments_stored_in_hash
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./test/fixtures/median_income.csv",
      :children_in_poverty => "./test/fixtures/children_poverty.csv",
      :free_or_reduced_price_lunch => "./test/fixtures/lunch.csv",
      :title_i => "./test/fixtures/title.csv"
    }
    })
    assert_equal Hash, epr.economic_profiles.class
    assert_equal 4, epr.economic_profiles.count
  end

  def test_ep_data_framework
    epr = EconomicProfileRepository.new
    assert_equal Hash, epr.ep_data_framework("Academy 20").class
  end
end
