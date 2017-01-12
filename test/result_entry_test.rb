require './test/helper'
require './lib/result_entry'

class ResultEntryTest < Minitest::Test

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

  def test_can_create_result_entry
    entry1 = ResultEntry.new(r1)
    assert_instance_of ResultEntry, entry1
  end

  def test_can_hold_lunch_data
    entry1 = ResultEntry.new(r1)
    assert_equal 0.5, entry1.free_and_reduced_price_lunch_rate
    assert_equal Float, entry1.free_and_reduced_price_lunch_rate.class
  end

  def test_can_hold_poverty_data
    entry1 = ResultEntry.new(r1)
    assert_equal 0.25, entry1.children_in_poverty_rate
    assert_equal Float, entry1.children_in_poverty_rate.class
  end

  def test_can_hold_graduation_data
    entry1 = ResultEntry.new(r1)
    assert_equal 0.75, entry1.high_school_graduation_rate
    assert_equal Float, entry1.high_school_graduation_rate.class
  end
end
