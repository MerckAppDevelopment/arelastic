require 'helper'

class Arelastic::Filters::QueryTest < MiniTest::Spec
  def test_as_elastic
    expected = {"query" => { "match" => {"message" => "this is a test"} }}

    assert_equal expected, Arelastic::Filters::Query.new(Arelastic::Queries::Match.new('message', 'this is a test')).as_elastic
  end
end