require './test/helper'
require_relative "../../headcount/lib/district_repository"
require_relative "../../headcount/lib/district"

class DistrictRepositoryTest < Minitest::Test

  def test_district_repo_exists
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  def test_district_repo_can_find_one_district_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    district = dr.find_by_name("Adams County 14")

    assert_equal "ADAMS COUNTY 14", district.name
    assert_instance_of District, district

  end

  def test_it_can_find_by_name_if_more_than_one_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    district = dr.find_by_name("Adams County 14")

    assert_instance_of District, dr.find_by_name("Adams County 14")
    assert_equal "ADAMS COUNTY 14", dr.find_by_name("Adams County 14").name
    assert_instance_of District, dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", dr.find_by_name("Academy 20").name
    assert_nil dr.find_by_name("")
  end

  def test_can_find_all_matching
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })

    assert_equal 3, dr.find_all_matching("A").count
    assert_equal [], dr.find_all_matching("")
  end

  def test_district_can_hold_enrollment_repository
    dr = DistrictRepository.new
    assert_instance_of EnrollmentRepository, dr.er
  end

  def test_district_repository_can_find_enrollment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    assert_instance_of Enrollment, dr.find_enrollment("COLORADO")
    assert_nil dr.find_enrollment("")
  end

  def test_can_access_kindergarten_enrollment_for_year
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    district = dr.find_by_name("Colorado")
    assert_instance_of District, district
    assert_equal "COLORADO", district.name

    enrollment = district.enrollment
    assert_instance_of Enrollment, enrollment
    assert_equal "COLORADO", enrollment.name
    assert_equal 0.336, enrollment.kindergarten_participation_in_year(2006)
  end

  def test_loading_and_finding_districts
    dr = DistrictRepository.new
    dr.load_data({
     :enrollment => {
       :kindergarten => "./data/Kindergartners in full-day program.csv"
       }
     })
    district = dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name

    assert_equal 7, dr.find_all_matching("WE").count
  end

end
