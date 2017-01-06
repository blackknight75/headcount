class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(input)
    @name = input[:name]
    @kindergarten_participation = input[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation[year]
  end
end
