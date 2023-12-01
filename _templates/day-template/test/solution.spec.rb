require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module DayN
    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_works
          assert_equal 1, Part01.solve(input: "1abc2")
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_works
          assert_equal 1, Part02.solve(input: "1abc2")
        end
      end
    end
  end
end
