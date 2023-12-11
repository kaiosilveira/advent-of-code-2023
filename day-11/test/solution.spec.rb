require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day11

    def self.universe
      <<~UNIVERSE
        ...#......
        .......#..
        #.........
        ..........
        ......#...
        .#........
        .........#
        ..........
        .......#..
        #...#.....
      UNIVERSE
    end

    class Day11Test < Test::Unit::TestCase
      def test_map_galaxies
        universe = [
          # 1    2    3    4    5    6    7    8    9   10    11   12   13
          ['.', '.', '.', '.', '#', '.', '.', '.', '.', '.', '.', '.', '.'], # 1
          ['.', '.', '.', '.', '.', '.', '.', '.', '.', '#', '.', '.', '.'], # 2
          ["#", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], # 3
          [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], # 4
          [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], # 5
          [".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", ".", "."], # 6
          [".", "#", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], # 7
          [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "#"], # 8
          [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], # 9
          [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], # 10
          [".", ".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", "."], # 11
          ["#", ".", ".", ".", ".", "#", ".", ".", ".", ".", ".", ".", "."]  # 12
        ]

        expected_result = [
          { n: 1, coords: [1, 5] },
          { n: 2, coords: [2, 10] },
          { n: 3, coords: [3, 1] },
          { n: 4, coords: [6, 9] },
          { n: 5, coords: [7, 2] },
          { n: 6, coords: [8, 13] },
          { n: 7, coords: [11, 10] },
          { n: 8, coords: [12, 1] },
          { n: 9, coords: [12, 6] }
        ], Day11.map_galaxies(universe)
      end

      def test_find_min_distance_between_galaxies
        expansion_analysis = [[4, 8], [3, 6, 9]]

        assert_equal 9, Day11.find_minimum_number_of_steps_between(
          { n: 5, coords: [6, 2] },
          { n: 9, coords: [10, 5] },
          expansion_analysis: expansion_analysis,
          multiplier_factor: 2
        )

        assert_equal 15, Day11.find_minimum_number_of_steps_between(
          { n: 1, coords: [1, 4] },
          { n: 7, coords: [9, 8] },
          expansion_analysis: expansion_analysis,
          multiplier_factor: 2
        )

        assert_equal 17, Day11.find_minimum_number_of_steps_between(
          { n: 3, coords: [3, 1] },
          { n: 6, coords: [7, 10] },
          expansion_analysis: expansion_analysis,
          multiplier_factor: 2
        )

        assert_equal 5, Day11.find_minimum_number_of_steps_between(
          { n: 8, coords: [10, 1] },
          { n: 9, coords: [10, 5] },
          expansion_analysis: expansion_analysis,
          multiplier_factor: 2
        )

        assert_equal 10, Day11.find_minimum_number_of_steps_between(
          { n: 7, coords: [9, 8] },
          { n: 8, coords: [10, 1] },
          expansion_analysis: expansion_analysis,
          multiplier_factor: 2
        )

        assert_equal 5, Day11.find_minimum_number_of_steps_between(
          { n: 7, coords: [9, 8] },
          { n: 9, coords: [10, 5] },
          expansion_analysis: expansion_analysis,
          multiplier_factor: 2
        )
      end

      def test_analyze_universe_expansion
        expected_result = [[4, 8], [3, 6, 9]]

        assert_equal expected_result, Day11.analyze_universe_expansion(
          Day11.universe.split("\n").map(&:strip).map { |r| r.chars }
        )
      end
    end

    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_solve
          assert_equal 374, Part01.solve(input: Day11.universe)
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_solve
          assert_equal 374, Part02.solve(input: Day11.universe, multiplier_factor: 2)
          assert_equal 1030, Part02.solve(input: Day11.universe, multiplier_factor: 10)
          assert_equal 8410, Part02.solve(input: Day11.universe, multiplier_factor: 100)
        end
      end
    end
  end
end
