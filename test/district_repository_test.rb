require './test/test_helper'
require './lib/district_repository'
require './lib/district'

class DistrictRepositoryTest < Minitest::Test

  def test_district_repo_exists
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  def test_search_districts_can_find_input_district
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new({"ADAMS" => d1, "ACADEMY 20" => d2})

    assert_equal d1, dr.search_districts("Adams")
    assert_equal d2, dr.search_districts("ACADEMY 20")
    # assert_equal nil, dr.search_districts("")
  end

  def test_district_repo_can_find_one_district_by_name
    d1 = District.new({:name => "Adams"})
    dr = DistrictRepository.new({"Adams" => d1})
    dr.load_data({
      :enrollment => {
        :kindergarten => "./fixtures/kg_in_full_day.csv"
      }
    })
    district = dr.find_by_name("Adams")
    assert_equal d1, district
  end

  def test_it_can_find_by_name_if_more_than_one_district
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new({"ADAMS" => d1, "ACADEMY 20" => d2})
    assert_equal d1, dr.find_by_name("Adams")
    assert_equal d2, dr.find_by_name("ACADEMY 20")
    # assert_equal nil, dr.find_by_name("")
  end

  def test_can_find_all_matching
    skip
    d1 = District.new({:name => "Adams"})
    d2 = District.new({:name => "ACADEMY 20"})
    dr = DistrictRepository.new({"ADAMS" => d1, "ACADEMY 20" => d2})

    # assert_equal [d1, d2], dr.find_all_matching(["Adams", "ACADEMY 20"])
    assert_equal [], dr.find_all_matching(["", ""])
  end

end
