require './test/helper'
require_relative "../../headcount/lib/district_repository"
require_relative "../../headcount/lib/district"
class DistrictTest < MiniTest::Test

  def test_district_exists
    district = District.new({:name => "ACADEMY 20"})
    assert_instance_of District, district
  end

  def test_district_has_name
    district = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", district.name
  end

  def test_district_can_hold_district_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv",
      },
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd_grade.csv",
        :eighth_grade => "./test/fixtures/8th_grade.csv",
        :math => "./test/fixtures/math.csv",
        :reading => "./test/fixtures/reading.csv",
        :writing => "./test/fixtures/writing.csv"
      },
    })
    district = District.new({:name => "ACADEMY 20"}, dr)
    assert_instance_of DistrictRepository, district.dr
  end
end
