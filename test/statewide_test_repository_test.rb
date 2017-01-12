require './test/helper'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/district_repository'
require_relative '../lib/headcount_analyst'

class StatewideTestRepositoryTest < Minitest::Test

  def test_statewide_test_repo_exists
    statewide = StatewideTestRepository.new
    assert_instance_of StatewideTestRepository, statewide
  end

  def test_statewide_test_repo_find_name
    statewide_repo = StatewideTestRepository.new
    statewide_repo.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd_grade.csv",
        :eighth_grade => "./test/fixtures/8th_grade.csv",
        :math => "./test/fixtures/math.csv",
        :reading => "./test/fixtures/reading.csv",
        :writing => "./test/fixtures/writing.csv"
      }
    })

    st = statewide_repo.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", st.name
  end

  def test_statewide_test_repo_proficient_by_grade
    statewide_repo = StatewideTestRepository.new
    statewide_repo.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd_grade.csv",
        :eighth_grade => "./test/fixtures/8th_grade.csv",
        :math => "./test/fixtures/math.csv",
        :reading => "./test/fixtures/reading.csv",
        :writing => "./test/fixtures/writing.csv"
      }
    })

    st = statewide_repo.find_by_name("ACADEMY 20")
    year_hash = st.proficient_by_grade(:eighth_grade)

    assert_equal 7, year_hash.keys.length
    assert_equal true, year_hash.has_key?(2008)

    subject_hash = year_hash[2008]
    assert_equal 3, subject_hash.keys.length
    assert_equal true, subject_hash.has_key?(:math)
    assert_equal true, subject_hash.has_key?(:reading)
    assert_equal true, subject_hash.has_key?(:writing)
    assert_equal 0.64, subject_hash[:math]
    assert_equal 0.843, subject_hash[:reading]
    assert_equal 0.734, subject_hash[:writing]
  end

  def test_statewide_test_repo_proficient_by_race
  statewide_repo = StatewideTestRepository.new
  statewide_repo.load_data({
    :statewide_testing => {
      :third_grade => "./test/fixtures/3rd_grade.csv",
      :eighth_grade => "./test/fixtures/8th_grade.csv",
      :math => "./test/fixtures/math.csv",
      :reading => "./test/fixtures/reading.csv",
      :writing => "./test/fixtures/writing.csv"
    }
  })

  st = statewide_repo.find_by_name("ACADEMY 20")
  year_hash = st.proficient_by_race_or_ethnicity(:asian)

  assert_equal 4, year_hash.keys.length
  assert_equal true, year_hash.has_key?(2011)

  subject_hash = year_hash[2011]
  assert_equal 3, subject_hash.keys.length
  assert_equal true, subject_hash.has_key?(:math)
  assert_equal true, subject_hash.has_key?(:reading)
  assert_equal true, subject_hash.has_key?(:writing)
  assert_in_delta 0.816, subject_hash[:math], 0.005
  assert_in_delta 0.897, subject_hash[:reading], 0.005
  assert_in_delta 0.826, subject_hash[:writing], 0.005
  end

  def test_statewide_test_repo_proficient_for_subject_by_grade_in_year

  statewide_repo = StatewideTestRepository.new
  statewide_repo.load_data({
    :statewide_testing => {
      :third_grade => "./test/fixtures/3rd_grade.csv",
      :eighth_grade => "./test/fixtures/8th_grade.csv",
      :math => "./test/fixtures/math.csv",
      :reading => "./test/fixtures/reading.csv",
      :writing => "./test/fixtures/writing.csv"
    }
  })

  st = statewide_repo.find_by_name("ACADEMY 20")
  proficiency = st.proficient_for_subject_by_grade_in_year(:math, :third_grade, 2009)

  assert_equal 0.824, proficiency
  end

  def test_statewide_test_repo_proficient_for_subject_by_race_in_year

    statewide_repo = StatewideTestRepository.new
    statewide_repo.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd_grade.csv",
        :eighth_grade => "./test/fixtures/8th_grade.csv",
        :math => "./test/fixtures/math.csv",
        :reading => "./test/fixtures/reading.csv",
        :writing => "./test/fixtures/writing.csv"
      }
    })

    st = statewide_repo.find_by_name("ACADEMY 20")
    proficiency = st.proficient_for_subject_by_race_in_year(:math, :asian, 2011)

    assert_in_delta 0.816, proficiency, 0.005
  end
end
