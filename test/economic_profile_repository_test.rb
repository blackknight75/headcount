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

  def test_input_name
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./test/fixtures/median_income.csv",
    }
    })
    # row = CSV::Row.new([location:"ACADEMY 20"], [head: "COLORADO"], true)
    # binding.pry
    row = epr.csv_object
    assert_equal "ADAMS-ARAPAHOE 28J", epr.input_name(row)
    assert_equal String, epr.input_name(row).class
  end

  def test_poverty_level
      epr = EconomicProfileRepository.new
      epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./test/fixtures/lunch.csv",
      }
      })
      row = epr.csv_object
      assert_equal "Eligible for Reduced Price Lunch", epr.poverty_level(row)
      assert_equal String, epr.poverty_level(row).class
  end

  def test_dataformat
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :children_in_poverty => "./test/fixtures/children_poverty.csv",
    }
    })
    row = epr.csv_object
    assert_equal "Percent", epr.dataformat(row)
    assert_equal String, epr.dataformat(row).class
  end

  def test_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :children_in_poverty => "./test/fixtures/children_poverty.csv",
    }
    })
    row = epr.csv_object
    assert_equal 2013, epr.year(row)
    assert_equal Fixnum, epr.year(row).class
  end

  def test_data
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :children_in_poverty => "./test/fixtures/children_poverty.csv",
    }
    })
    row = epr.csv_object
    assert_equal 0.267, epr.data(row)
    assert_equal Float, epr.data(row).class
  end

  def test_poverty_data
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :children_in_poverty => "./test/fixtures/children_poverty.csv",
    }
    })
    row = epr.csv_object
    assert_equal 0.267, epr.poverty_data(row)
    assert_equal Float, epr.poverty_data(row).class
  end

  def test_poverty_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :children_in_poverty => "./test/fixtures/children_poverty.csv",
    }
    })
    row = epr.csv_object
    assert_equal 2013, epr.poverty_year(row)
    assert_equal Fixnum, epr.poverty_year(row).class
  end

  def test_lunch_data
      epr = EconomicProfileRepository.new
      epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./test/fixtures/lunch.csv",
      }
      })
      row = epr.csv_object
      assert_equal 0.08, epr.lunch_data(row)
      assert_equal Float, epr.lunch_data(row).class
  end

  def test_ep_data_framework
    epr = EconomicProfileRepository.new
    assert_equal Hash, epr.ep_data_framework("Academy 20").class
  end
end
