require 'helper'

class Arelastic::Filters::NestedTest < Minitest::Test
  def test_as_elastic
    expected = {
      "nested" => {
        "path"  => "bunnies",
        "query" => {
          "match" => {
            "name" => "Harry"
          }
        }
      }
    }

    assert_equal expected, Arelastic::Filters::Nested.new('bunnies', Arelastic::Searches::Query.new(Arelastic::Queries::Match.new('name', 'Harry'))).as_elastic
  end

end