require 'helper'

class Arelastic::Filters::MissingTest < MiniTest::Spec
  def test_as_elastic
    expected = {"missing" => { "field" => "color" }}

    assert_equal expected, Arelastic::Filters::Missing.new('color').as_elastic
  end

  def test_with_options
    expected = {"missing" => { "field" => "color" }}

    assert_equal expected, Arelastic::Filters::Missing.new('color').as_elastic
  end
  
end