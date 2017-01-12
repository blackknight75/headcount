require './test/helper'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'

class StatewideTestTest < Minitest::Test

  def data
    {
      name: "COLORADO",
      grade_year_subject: {:third_grade=>{2008=>{:math=>0.697}}},
      race_year_subject: {:all_students=>{2011=>{:math=>0.557}}},
      asian: {2011=>{:math=>0.709}}
    }
  end

  def test_can_create_statewide_tests
    st = StatewideTest.new
    assert_instance_of StatewideTest, st
  end

  def test_statewide_test_has_name
    st = StatewideTest.new(data)
    assert_equal "COLORADO", st.name
    assert_equal String, st.name.class
  end

  def test_statewide_test_has_grade_data
    st = StatewideTest.new(data)
    actual = ({:third_grade=>{2008=>{:math=>0.697}}})
    assert_equal actual, st.grade_year_subject
    assert_equal Hash, st.grade_year_subject.class
  end

  def test_statewide_test_has_race_data
    st = StatewideTest.new(data)
    actual = {:all_students=>{2011=>{:math=>0.557}}}
    assert_equal actual, st.race_year_subject
    assert_equal Hash, st.race_year_subject.class
  end

  def test_proficient_by_grade
    st = StatewideTest.new(data)
    actual = {2008=>{:math=>0.697}}
    assert_equal actual, st.proficient_by_grade(:third_grade)
    assert_equal Hash, st.proficient_by_grade(:third_grade).class
  end

  def test_proficient_by_race
    st = StatewideTest.new(data)
    actual = {2011=>{:math=>0.557}}
    assert_equal actual, st.proficient_by_race_or_ethnicity(:all_students)
    assert_equal Hash, st.proficient_by_race_or_ethnicity(:all_students).class
  end

  def test_proficient_for_subject_by_grade_in_year
    st = StatewideTest.new(data)
    expected = st.proficient_for_subject_by_grade_in_year(:math, :third_grade, 2008)
    assert_equal 0.697, expected
    assert_equal Float, expected.class
  end

  def test_proficient_for_subject_by_race_in_year
    st = StatewideTest.new(data)
    expected = st.proficient_for_subject_by_race_in_year(:math, :all_students, 2011)
    assert_equal 0.557, expected
    assert_equal Float, expected.class
  end
end
