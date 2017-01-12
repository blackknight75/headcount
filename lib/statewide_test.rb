require_relative 'errors'
require_relative 'Clean'
class StatewideTest
  attr_reader :name, :grade_year_subject, :race_year_subject, :error

  def initialize(input = {})
    @name = input[:name]
    @grade_year_subject = input[:grade_year_subject] if grade_key(input)
    @race_year_subject  = input[:race_year_subject]  if race_key(input)
  end

  def grade_key(input)
    input.has_key?(:grade_year_subject)
  end

  def race_key(input)
    input.has_key?(:race_year_subject)
  end

  def proficient_by_grade(grade)
    cleaned_grade = Clean.grade(grade)
    raise UnknownDataError unless @grade_year_subject[cleaned_grade]
      @grade_year_subject[cleaned_grade]
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownDataError unless @race_year_subject[race]
    @race_year_subject[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless check_grade_keys(grade, year, subject)
      @grade_year_subject[Clean.grade(grade)][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless check_race_keys(race, year, subject)
      @race_year_subject[race][year][subject]
  end

  def check_race_keys(race, year, subject)
    (
      @race_year_subject[race] &&
      @race_year_subject[race][year] &&
      @race_year_subject[race][year][subject]
    )
  end

  def check_grade_keys(grade, year, subject)
    (
      @grade_year_subject[Clean.grade(grade)] &&
      @grade_year_subject[Clean.grade(grade)][year] &&
      @grade_year_subject[Clean.grade(grade)][year][subject]
    )
  end
end
