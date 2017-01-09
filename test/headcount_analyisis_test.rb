require './test/helper'
require './lib/headcount_analysis'
require './lib/district_repository'

class HeadcountAnalysisTest < Minitest::Test

  def test_headcount_anaylsis_exists
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })

    ha = HeadcountAnalysis.new(dr)
    assert_instance_of HeadcountAnalysis, ha
  end

  def test_can_find_district_object
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    ha = HeadcountAnalysis.new(dr)
    assert_instance_of District,   ha.dr.find_by_name("ACADEMY 20")
  end

  def test_can_find_enrollment_object
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    ha = HeadcountAnalysis.new(dr)
    assert_instance_of Enrollment,   ha.dr.find_enrollment("ACADEMY 20")
  end

  def test_can_compare_district_to_state_kg_participation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    ha = HeadcountAnalysis.new(dr)
    expected = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    actual = 0.766
    assert_in_delta actual, expected, 0.005
  end

  def test_can_compare_district_to_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    ha = HeadcountAnalysis.new(dr)
    expected = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
    actual = 0.573
    assert_in_delta actual, expected, 0.005
  end

  def test_can_find_kg_paticipation_trend_per_year
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    ha = HeadcountAnalysis.new(dr)
    expected = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    actual = ({2004=>1.258, 2005=>0.96, 2006=>1.05, 2007=>0.992, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.687, 2013=>0.693, 2014=>0.661})
    assert_equal actual, expected
  end

end
