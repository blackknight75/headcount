class Enrollment
  attr_reader :name
  attr_accessor :kindergarten_participation, :high_school_graduation

  def initialize(input)
    @name = input[:name]
    @kindergarten_participation = input[:kindergarten_participation]
    @high_school_graduation = input[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation[year]
  end

  def graduation_rate_by_year
    @high_school_graduation
  end
end
