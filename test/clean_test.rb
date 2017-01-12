require './test/helper'
require_relative '../lib/clean'

class CleanTest < Minitest::Test

  def test_can_create_clean_object
    clean = Clean.new
    assert_instance_of Clean, clean
  end

  def test_can_truncate_data
    clean = Clean.new
    assert_equal 0.034, Clean.truncate_data(0.0349843284)
  end


end
