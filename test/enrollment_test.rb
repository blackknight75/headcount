require './test/helper'
require_relative "../../headcount/lib/enrollment"
class EnrollmentTest < Minitest::Test

  def test_enrollment_exists
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_instance_of Enrollment, e
  end

  def test_kindergarten_participation_is_a_hash
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal Hash, e.kindergarten_participation.class
  end

  def test_name_is_a_string
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal String, e.name.class
  end

  def test_can_return_kindergarten_participation_per_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    expected = {2010=>0.3915, 2011=>0.35356, 2012=>0.2677}
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_can_return_kindergarten_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_in_delta 0.391 , e.kindergarten_participation_in_year(2010)
  end
end
