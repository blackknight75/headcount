require './test/test_helper'
require './lib/district'

class DistrictTest < MiniTest::Test

  def test_district_exists
    district = District.new({:name => "ACADEMY 20"})
    assert_instance_of District, district
  end

  def test_district_has_name
    district = District.new({:name => "ACADEMY 20"})
    assert_equal ({:name => "ACADEMY 20"}), district.name
  end
end
