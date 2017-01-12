require './test/helper'
require './lib/result_set'
require './lib/result_entry'

class ResultSetTest < Minitest::Test

  def r1
    {
      free_and_reduced_price_lunch_rate: 0.5,
      children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75
    }
  end

  def r2
    {
      free_and_reduced_price_lunch_rate: 0.3,
      children_in_poverty_rate: 0.2,
      high_school_graduation_rate: 0.6
    }
  end

  def test_can_create_result_set
    rs = ResultSet.new(matching_districts: [ResultEntry.new(r1)], statewide_average: ResultEntry.new(r2))
    assert_instance_of ResultSet, rs
  end

  def test_can_hold_matching_districts
    entry1 = ResultEntry.new(r1)
    entry2 = ResultEntry.new(r2)
    rs = ResultSet.new(matching_districts: [entry1], statewide_average: entry2)

    assert_equal entry1, rs.matching_districts.first
    assert_equal 0.5, rs.matching_districts.first.free_and_reduced_price_lunch_rate
    assert_equal 0.25, rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.75, rs.matching_districts.first.high_school_graduation_rate
  end

  def test_can_hold_statewide_average
    entry1 = ResultEntry.new(r1)
    entry2 = ResultEntry.new(r2)
    rs = ResultSet.new(matching_districts: [entry1], statewide_average: entry2)
    assert_equal entry2, rs.statewide_average
    assert_equal 0.3, rs.statewide_average.free_and_reduced_price_lunch_rate
    assert_equal 0.2, rs.statewide_average.children_in_poverty_rate
    assert_equal 0.6, rs.statewide_average.high_school_graduation_rate
  end
end
