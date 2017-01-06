require './test/helper'
require './lib/district_repository'
require './lib/district'

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
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./test/fixtures/kg_in_full_day.csv"
        }
      })

    assert_equal 2, dr.find_all_matching(["Adams County 14", "ACADEMY 20"]).count
    assert_equal [], dr.find_all_matching(["", ""])
  end
end
