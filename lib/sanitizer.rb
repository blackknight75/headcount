class Sanitizer

  def self.truncate_data(float)
    float = 0 if float.nan?
    (float * 1000).floor / 1000.to_f
  end

  def self.input_name(row)
    row[:location].upcase
  end

  def self.poverty_level(row)
    row[:poverty_level]
  end

  def self.dataformat(row)
    row[:dataformat].downcase
  end

  def self.year(row, symbol = nil)
    if symbol == :median_household_income
      x = row[:timeframe].split("-")
      results = x.map {|year| year.to_i}
    else
      row[:timeframe].to_i
    end
  end

  def self.data(row)
    data = row[:data]
    if data.nil?
      0
    elsif data != nil && data.include?(".")
      data.to_f.round(3)
    else
      data.to_i
    end
  end

  def self.poverty_data(row)
    if row[:dataformat] == "percent"
      row[:data].to_f.round(3)
    else

    end
  end

  def self.poverty_year(row)
    if row[:dataformat] == "percent"
      row[:timeframe].to_i
    else
      nil
    end
  end

  def self.lunch_data(row)
    return row[:data].to_f.round(3) if row[:dataformat] == "percent"
    return row[:data].to_i if row[:dataformat] == "number"

  end
  # def self.error?(condition)
  #   raise UnknownDataError unless condition
  # end
end
