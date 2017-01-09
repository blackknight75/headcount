require './lib/sanitizer'
class HeadcountAnalysis
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
end
