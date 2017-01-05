require './test/test_helper'
require './lib/enrollment_repository'
require './lib/enrollment'

class EnrollmentRepositoryTest < MiniTest::Test

  def test_enrollment_repo_exists
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_enrollment_repo_find_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    assert_instance_of Enrollment, enrollment
  end
end
