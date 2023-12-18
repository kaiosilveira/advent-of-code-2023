require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day12
    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_works
          assert_equal 1, Part01.solve(input: "1abc2")
        end

        def test_get_number_of_arrangements
          # pattern = ???.### 1,1,3
          assert_equal 1, Part01.get_number_of_arrangements(
            pattern: "#", number_of_damaged_springs: 1
          )

          assert_equal 1, Part01.get_number_of_arrangements(
            pattern: "?#", number_of_damaged_springs: 2
          )

          assert_equal 2, Part01.get_number_of_arrangements(
            pattern: "??#", number_of_damaged_springs: 2
          )

          assert_equal 3, Part01.get_number_of_arrangements(
            pattern: "???", number_of_damaged_springs: 1
          )
        end

        def test_parse_input
          input = ".??..??...?##. 1,1,3"

          expected_output = [
            { number_of_damaged_springs: 1, pattern: "??" },
            { number_of_damaged_springs: 1, pattern: "??" },
            { number_of_damaged_springs: 3, pattern: "?##" }
          ]

          assert_equal expected_output, Part01.parse_input(input)
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
