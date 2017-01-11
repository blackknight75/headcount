require './test/helper'
require_relative "../../headcount/lib/economic_profile"

class EconomicProfileTest < Minitest::Test

  def data
    {
      name: "name",
      median_household_income: {[2006, 2010]=>85450, [2008, 2012]=>89615, [2007, 2011]=>88099, [2009, 2013]=>89953},
      children_in_poverty:
        {
          1995=>0.032,
          1997=>0.035,
          1999=>0.032,
          2000=>0.031
        },
      free_or_reduced_price_lunch:
      {
        2014=>{:Number=>3132, :Percent=>0.127},
        2004=>{:Number=>1182, :Percent=>0.06},
        2003=>{:Percent=>0.06, :Number=>1062},
        2002=>{:Number=>905, :Percent=>0.048},
        2001=>{:Percent=>0.047, :Number=>855},
        2000=>{:Number=>701, :Percent=>0.04}
       },
      title_i: {2009=>0.014, 2011=>0.011, 2012=>0.0107, 2013=>0.0125, 2014=>0.027}
    }
  end

  def test_economic_profile_has_name
    ep = EconomicProfile.new(data)
    assert_equal "name", ep.name
    assert_equal String, ep.name.class
  end

  def test_economic_profile_has_income_data
    ep = EconomicProfile.new(data)
    expected = {[2006, 2010]=>85450, [2008, 2012]=>89615, [2007, 2011]=>88099, [2009, 2013]=>89953}
    assert_equal (expected), ep.median_household_income
    assert_equal Hash, ep.median_household_income.class
  end

  def test_economic_profile_has_poverty_data
    ep = EconomicProfile.new(data)
    expected =         {
              1995=>0.032,
              1997=>0.035,
              1999=>0.032,
              2000=>0.031
            }

    assert_equal (expected), ep.children_in_poverty
    assert_equal Hash, ep.children_in_poverty.class
  end

  def test_economic_profile_has_lunch_data
    ep = EconomicProfile.new(data)
    expected = {
      2014=>{:Number=>3132, :Percent=>0.127},
      2004=>{:Number=>1182, :Percent=>0.06},
      2003=>{:Percent=>0.06, :Number=>1062},
      2002=>{:Number=>905, :Percent=>0.048},
      2001=>{:Percent=>0.047, :Number=>855},
      2000=>{:Number=>701, :Percent=>0.04}
     }
    assert_equal (expected), ep.free_or_reduced_price_lunch
    assert_equal Hash, ep.free_or_reduced_price_lunch.class
  end

  def test_economic_profile_title_i_data
    ep = EconomicProfile.new(data)
    expected = {2009=>0.014, 2011=>0.011, 2012=>0.01072, 2013=>0.01246, 2014=>0.0273}
    assert_equal (expected), ep.title_i
    assert_equal Hash, ep.title_i.class
  end

  def test_can_find_median_household_income_in_year
    ep = EconomicProfile.new(data)
    assert_equal 85450, ep.median_household_income_in_year(2006)
    assert_equal 88279, ep.median_household_income_in_year(2009)
  end

  def test_can_find_median_household_income_average
    ep = EconomicProfile.new(data)
    assert_equal 88279, ep.median_household_income_average
  end

  def test_can_find_children_in_poverty_in_year
    ep = EconomicProfile.new(data)
    assert_equal 0.031, ep.children_in_poverty_in_year(2000)
  end

  def test_can_find_free_or_reduced_price_lunch_percentage_in_year
    ep = EconomicProfile.new(data)
    assert_equal 0.127, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_can_find_title_i_in_year
    ep = EconomicProfile.new(data)
    assert_equal 0.127, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

end
