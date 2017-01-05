class District
  attr_reader :name

  def initialize(input)
    @name = name_generator(input)
  end

  def name_generator(input)
    input[:name].upcase
  end

end
