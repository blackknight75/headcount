class ResultEntry
  attr_reader :name,
              :free_and_reduced_price_lunch_rate,
              :children_in_poverty_rate,
              :high_school_graduation_rate,
              :median_household_income

  def initialize(dat)
    @name = dat[:name]
    @free_and_reduced_price_lunch_rate = dat[:free_and_reduced_price_lunch_rate]
    @children_in_poverty_rate = dat[:children_in_poverty_rate]
    @high_school_graduation_rate = dat[:high_school_graduation_rate]
    @median_household_income = dat[:median_household_income]
  end

end
