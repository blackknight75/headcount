class District
  attr_reader :name, :dr, :enrollment

  def initialize(input, district_repo = nil)
    @name = input[:name]
    @dr = district_repo
    @enrollment = find_matching_enrollment_instance if district_repo
  end

  def find_matching_enrollment_instance
    district_repo = @dr
    enrollment_repo = district_repo.enrollment_repo
    enrollment_repo.find_by_name(@name)
  end

end
