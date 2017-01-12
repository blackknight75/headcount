require 'csv'
require_relative 'statewide_test'
require_relative 'Clean'
class StatewideTestRepository

  def initialize
    @statewide_tests = {}
  end

  def load_data(path)
    path[:statewide_testing].each do |symbol, file_path|
      CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
        name    = row[:location].upcase
        year    = row[:timeframe].to_i
        # data = Clean.truncate_data(row[:data].to_f)
        race = row[:race_ethnicity]
        score = row[:score]

        if symbol == :third_grade || symbol == :eighth_grade
          if symbol == :third_grade
            top_level_key = symbol
          elsif symbol == :eighth_grade
            top_level_key = symbol
          end

          subject = score.downcase.to_sym
        else
          top_level_key = race.downcase.to_sym
          subject = symbol.downcase.to_sym
        end

        make_statewide_test(name, year, top_level_key, subject, row)
      end
    end
  end

  def make_statewide_test(name, year, top_level_key, subject, row)
    unless @statewide_tests.has_key?(name)
      @statewide_tests[name] = StatewideTest.new({
        :name => name,
        :grade_year_subject => {},
        :race_year_subject => {}
      })
    end

    statewide_test = @statewide_tests[name]
    if top_level_key == :third_grade || top_level_key == :eighth_grade
      root = statewide_test.grade_year_subject
    else
      root = statewide_test.race_year_subject
    end

    root[top_level_key] = {} unless root.has_key?(top_level_key)
    root[top_level_key][year] = {} unless root[top_level_key].has_key?(year)
    root[top_level_key][year][subject] = Clean.data(row)
  end

  def find_by_name(name)
    @statewide_tests[name.upcase] if name
  end
end
