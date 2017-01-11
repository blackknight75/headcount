class District
  attr_reader :name, :dr

  def initialize(input, district_repo = nil)
    @name = input[:name]
    @dr = district_repo
  end

  def enrollment
    @dr.find_enrollment(@name)
  end

<<<<<<< HEAD
  def statewide_test
    @dr.find_statewide_test(@name)
=======
  def statewide_test 
    @dr.find_statewide(@name)
>>>>>>> 75fcf8f0777e2dbeb96a81c3e107f7d4d24b2889
  end
end
