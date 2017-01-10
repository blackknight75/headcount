require_relative "sanitizer"
class HeadcountAnalyst
  attr_reader :dr

  def initialize(district_repo)
    @dr = district_repo
  end

  def kindergarten_participation_rate_variation(district, against)
    a = @dr.find_by_name(district).enrollment.kindergarten_participation_by_year.values.reduce(:+)/11
    b = @dr.find_by_name(against[:against]).enrollment.kindergarten_participation_by_year.values.reduce(:+)/11
    a / b
  end

  def kindergarten_participation_rate_variation_trend(district, against)
    c = Hash.new(0)
    a = @dr.find_by_name(district).enrollment.kindergarten_participation_by_year
    b = @dr.find_by_name(against[:against]).enrollment.kindergarten_participation_by_year
    a.sort.each do |year, data|
      c[year] = Sanitizer.truncate_data(data / b[year])
    end
    c
  end

  def kindergarten_participation_against_high_school_graduation(district)
    x = district
    if district == "STATEWIDE"
      x = "COLORADO"
    end
    a = kindergarten_participation_rate_variation(x, {:against => 'COLORADO'})
    b = high_school_graduation_rate_variation(x, {:against => 'COLORADO'})
    Sanitizer.truncate_data(a/b)
  end

  def high_school_graduation_rate_variation(district, state)
    number_of_entries = @dr.find_by_name(district).enrollment.graduation_rate_by_year.count
    a = @dr.find_by_name(district).enrollment.graduation_rate_by_year.values.reduce(:+)/number_of_entries
    b = @dr.find_by_name(state[:against]).enrollment.graduation_rate_by_year.values.reduce(:+)/number_of_entries
    a / b
  end

  def kindergarten_participation_correlates_with_high_school_graduation(districts)
    results = Array.new
    districts.values.flatten.each do |district|
      data = kindergarten_participation_against_high_school_graduation(district)
      results << correlate?(data)
    end
    results.count(true) > (districts.count / 2) ? true : false
    end

    def correlate?(data)
       data >= 0.6 && data <= 1.5 ? true : false
    end
end
