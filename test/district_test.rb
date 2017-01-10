require './test/helper'
require './lib/district'
require './lib/district_repository'

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
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    district = District.new({:name => "ACADEMY 20"}, dr)
    assert_instance_of DistrictRepository, district.dr
  end
end
