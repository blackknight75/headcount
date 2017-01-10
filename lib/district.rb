class District
  attr_reader :name, :dr

  def initialize(input, district_repo = nil)
    @name = input[:name]
    @dr = district_repo
  end

  def enrollment
    @dr.find_enrollment(@name)
  end

  def statewide_test 
    @dr.find_statewide(@name)
  end
end
