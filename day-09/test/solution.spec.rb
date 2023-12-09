require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day09
    def self.input
      <<~INPUT
        0 3 6 9 12 15
        1 3 6 10 15 21
        10 13 16 21 30 45
      INPUT
    end

    class Day09Test < Test::Unit::TestCase
      def test_parse_input
        assert_equal [
          [0, 3, 6, 9, 12, 15],
          [1, 3, 6, 10, 15, 21],
          [10, 13, 16, 21, 30, 45]
        ], Day09.parse_input(Day09.input)
      end
  
      def test_find_difference_pattern
        assert_equal [3, 3, 3, 3, 3], Day09.find_difference_pattern([0, 3, 6, 9, 12, 15])
        assert_equal [0, 0, 0, 0], Day09.find_difference_pattern([3, 3, 3, 3, 3])
      end
    end

    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_solve
          assert_equal 114, Part01.solve(Day09.input)
        end

        def test_predict_next_number
          assert_equal 0, Day09.predict_next_number([0, 0, 0], direction: :forward)
          assert_equal 1, Day09.predict_next_number([1, 1, 1, 1], direction: :forward)
          assert_equal 7, Day09.predict_next_number([2, 3, 4, 5, 6], direction: :forward)
          assert_equal 28, Day09.predict_next_number([1, 3, 6, 10, 15, 21], direction: :forward)
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_solve
          assert_equal 2, Part02.solve(Day09.input)
        end

        def test_predict_previous_number
          assert_equal 0, Day09.predict_next_number([0, 0], direction: :backward)
          assert_equal 2, Day09.predict_next_number([2, 2, 2], direction: :backward)
          assert_equal -2, Day09.predict_next_number([0, 2, 4, 6], direction: :backward)
          assert_equal 5, Day09.predict_next_number([3, 3, 5, 9, 15], direction: :backward)
          assert_equal 5, Day09.predict_next_number([10, 13, 16, 21, 30, 45], direction: :backward)
        end
      end
    end
  end
end
