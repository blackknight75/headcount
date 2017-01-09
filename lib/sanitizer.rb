class Sanitizer

  def self.truncate_data(float)
    float = 0 if float.nan?
    (float * 1000).floor / 1000.to_f
  end

end
