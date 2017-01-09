require './test/helper'
require './lib/enrollment_repository'
require './lib/enrollment'

class EnrollmentRepositoryTest < MiniTest::Test

  def test_enrollment_repo_exists
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_can_hold_enrollments_as_hashes
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
      })
      assert_equal Hash, er.enrollments.class
  end

  def test_enrollment_repo_find_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    enrollment2 = er.find_by_name("")
    enrollment3 = er.find_by_name(nil)
    assert_equal Enrollment, enrollment.class
    assert_equal "ACADEMY 20", enrollment.name
    assert_nil enrollment2
    assert_nil enrollment3
  end

  def test_can_find_graduation_rate_by_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kg_in_full_day.csv",
        :high_school_graduation => "./test/fixtures/hs_graduation.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    expected = ({ 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898,})
    actual = enrollment.graduation_rate_by_year
    assert_equal expected, actual
  end
end
