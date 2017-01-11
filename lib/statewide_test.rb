<<<<<<< HEAD
require_relative 'errors'
require_relative 'sanitizer'
class StatewideTest
  attr_reader :name, :grade_year_subject, :race_year_subject, :error

  def initialize(input = {})
    @name = input[:name]
    @grade_year_subject = input[:grade_year_subject] if input.has_key?(:grade_year_subject)
    @race_year_subject  = input[:race_year_subject] if input.has_key?(:race_year_subject)
    @error = UnknownDataError
  end

  def proficient_by_grade(grade)
    raise error unless @grade_year_subject[grade]
    else
      @grade_year_subject[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    raise error unless @race_year_subject[race]
=======
class StatewideTest
  attr_reader :name, :grade_year_subject, :race_year_subject

  def initialize(input)
    @name = input[:name]
    @grade_year_subject = input[:grade_year_subject] if input.has_key?(:grade_year_subject)
    @race_year_subject = input[:race_year_subject] if input.has_key?(:race_year_subject)
  end

  def proficient_by_grade(grade)
    @grade_year_subject[grade]
  end

  def proficient_by_race_or_ethnicity(race)
>>>>>>> 75fcf8f0777e2dbeb96a81c3e107f7d4d24b2889
    @race_year_subject[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
<<<<<<< HEAD
    raise error unless @grade_year_subject[grade]
      @grade_year_subject[grade][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise error unless @race_year_subject[race]
      @race_year_subject[race][year][subject]
=======
    @grade_year_subject[grade][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    @race_year_subject[race][year][subject]
>>>>>>> 75fcf8f0777e2dbeb96a81c3e107f7d4d24b2889
  end
end
