require './test/helper'
require './lib/headcount_analyst'
require './lib/district_repository'

class HeadcountAnalystTest < Minitest::Test

  def test_headcount_anaylsis_exists
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    ha = HeadcountAnalyst.new(dr)
    assert_instance_of HeadcountAnalyst, ha
  end

  def test_can_find_district_object
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_instance_of District,   ha.dr.find_by_name("ACADEMY 20")
  end

  def test_can_find_enrollment_object
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_instance_of Enrollment,   ha.dr.find_enrollment("ACADEMY 20")
  end

  def test_can_compare_district_to_state_kg_participation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    actual = 0.766
    assert_in_delta actual, expected, 0.005
  end

  def test_can_compare_district_to_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
    actual = 0.573
    assert_in_delta actual, expected, 0.005
  end

  def test_can_find_kg_paticipation_trend_per_year
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    actual = ({2004=>1.258, 2005=>0.96, 2006=>1.05, 2007=>0.992, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.687, 2013=>0.693, 2014=>0.661})
    assert_equal actual, expected
  end

  def test_can_find_kindergarten_participation_against_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv",
        :high_school_graduation => "./test/fixtures/hs_graduation.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    actual = 0.641
    expected = ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal actual, expected
  end

  def test_high_school_versus_kindergarten_analysis
   dr = DistrictRepository.new
   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                 :high_school_graduation => "./data/High school graduation rates.csv"},
                                 :statewide_testing => {
                                   :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                   :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                   :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                 }})
   ha = HeadcountAnalyst.new(dr)

   assert_in_delta 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J'), 0.005
   assert_in_delta 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2'), 0.005
 end

 def test_can_find_high_school_graduation_variation
   dr = DistrictRepository.new
   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                 :high_school_graduation => "./data/High school graduation rates.csv"},
                                 :statewide_testing => {
                                   :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                   :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                   :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                 }})
   ha = HeadcountAnalyst.new(dr)
   expected = ha.high_school_graduation_rate_variation("ACADEMY 20", :against => "COLORADO")
   assert_equal 1.1947844598190527, expected
 end

 def test_kindergarten_participation_correlates_with_high_school_graduation
   dr = DistrictRepository.new
   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                 :high_school_graduation => "./data/High school graduation rates.csv"},
                                 :statewide_testing => {
                                   :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                   :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                   :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                 }})
   ha = HeadcountAnalyst.new(dr)
   expected = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
   assert_equal true, expected
 end

 def test_multi_district_corellation_with_hs_to_kg
   dr = DistrictRepository.new
   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                 :high_school_graduation => "./data/High school graduation rates.csv"},
                                 :statewide_testing => {
                                   :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                   :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                   :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                   :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                 }})
   ha = HeadcountAnalyst.new(dr)
   district_1 = "ACADEMY 20"
   district_2 = "ADAMS COUNTY 14"
   district_3 = "ADAMS-ARAPAHOE 28J"
   expected = ha.kindergarten_participation_correlates_with_high_school_graduation(:across => [district_1, district_2, district_3])
   assert_equal true, expected
  end
end