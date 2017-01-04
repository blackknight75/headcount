require './test/test_helper'
require './lib/district_repository'
require './lib/district'

class DistrictRepositoryTest < Minitest::Test

  def test_district_repo_exists
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  def test_district_repo_can_find_district_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal District, district
  end
end
