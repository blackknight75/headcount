class District
  attr_reader :name, :dr

  def initialize(input, district_repo = nil)
    @name = input[:name]
    @dr = district_repo
  end
end
