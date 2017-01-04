require 'csv'
class DistrictRepository

  def load_data(path)
    cleaned_path = path[:enrollment][:kindergarten]
    csv_data = CSV.open cleaned_path, headers: true, header_converters: :symbol
    data = csv_data.map { |line| line}
    binding.pry
  end
end
