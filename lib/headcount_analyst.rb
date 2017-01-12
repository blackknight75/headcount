require_relative "Clean"
class HeadcountAnalyst
  attr_reader :dr

  def initialize(district_repo)
    @dr = district_repo
  end

  def kindergarten_participation_rate_variation(district, against)
    find_district = @dr.find_by_name(district)
    find_against = @dr.find_by_name(against[:against])
    calculate_kg_participation_variation(find_district, find_against)
  end

  def calculate_kg_participation_variation(find_district, find_against)
    a = (find_district
        .enrollment.kindergarten_participation_by_year.values.reduce(:+)/11)
    b = (find_against.enrollment
        .kindergarten_participation_by_year.values.reduce(:+)/11)
    a / b
  end

  def kindergarten_participation_rate_variation_trend(district, against)
    find_district = @dr.find_by_name(district)
    find_against = @dr.find_by_name(against[:against])
    c = Hash.new(0)
    a = find_district.enrollment.kindergarten_participation_by_year
    b = find_against.enrollment.kindergarten_participation_by_year
    a.sort.each do |year, data|
      c[year] = Clean.truncate_data(data / b[year])
    end
    c
  end

  def kindergarten_participation_against_high_school_graduation(district)
    against = {:against => 'COLORADO'}
    a = kindergarten_participation_rate_variation(district, against)
    b = high_school_graduation_rate_variation(district, against)
    Clean.truncate_data(a/b)
  end

  def high_school_graduation_rate_variation(district, state)
    find_district = @dr.find_by_name(district)
    find_state = @dr.find_by_name(state[:against])
    count = find_district.enrollment.graduation_rate_by_year.count
    calculate_hs_grad_variation(find_district, find_state, count)
  end

  def calculate_hs_grad_variation(find_district, find_state, count)
    a = find_district.enrollment.graduation_rate_by_year.values.reduce(:+)/count
    b = find_state.enrollment.graduation_rate_by_year.values.reduce(:+)/count
    a / b
  end

  def kindergarten_participation_correlates_with_high_school_graduation(input)
    if input[:for] == "STATEWIDE"
      check_correlation_statewide(input)
    elsif input[:across]
      check_correlation_across_multiple_districts(input)
    else
      check_correlation_of_single_district(input)
    end
  end

  def check_correlation_of_single_district(input)
    r = kindergarten_participation_against_high_school_graduation(input[:for])
    correlate?(r)
  end

  def check_correlation_across_multiple_districts(districts)
    results = districts[:across].map do |district_name|
      correlate?(
        kindergarten_participation_against_high_school_graduation(district_name)
      )
    end
    (results.count(true) / (results.count)) > 0.70
  end

  def check_correlation_statewide(districts)
    results = @dr.districts.keys.map do |district_name|
      correlate?(
        kindergarten_participation_against_high_school_graduation(district_name)
      )
    end
    (results.count(true) / (results.count)) > 0.70
  end

  def correlate?(data)
     data >= 0.6 && data <= 1.5 ? true : false
  end
end
