require './test/test_helper'
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
        :kindergarten => "./fixtures/kg_in_full_day.csv"
      }
    })
    assert_equal 3, dr.districts.length

    district = dr.find_by_name("Adams County 14")
    assert_instance_of District, district
    assert_equal "ADAMS COUNTY 14", district.name

    district = dr.find_by_name("Random District")
    assert_nil district
  end

  def test_it_can_find_by_name_if_more_than_one_district
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new({"Adams" => d1, "ACADEMY 20" => d2})

    assert_equal d1, dr.find_by_name("Adams")
    assert_equal d2, dr.find_by_name("ACADEMY 20")
  end

end
