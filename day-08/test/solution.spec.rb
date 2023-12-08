require 'test/unit'
require_relative '../lib/solution'

module AoC2023 
  module Day08
    class InputParserTest < Test::Unit::TestCase
      include Day08::InputParser
      def test_parse_input
        instructions, coordinates = parse_input(input)
        expected_instructions = ["R", "L"]
        expected_coordinates = {
          "AAA" => { L: "BBB", R: "CCC" },
          "BBB" => { L: "DDD", R: "EEE" },
          "CCC" => { L: "ZZZ", R: "GGG" },
          "DDD" => { L: "DDD", R: "DDD" },
          "EEE" => { L: "EEE", R: "EEE" },
          "GGG" => { L: "GGG", R: "GGG" },
          "ZZZ" => { L: "ZZZ", R: "ZZZ" },
        }

        assert_equal expected_instructions, instructions
        assert_equal expected_coordinates, coordinates
      end

      def input
        <<~INPUT
          RL

          AAA = (BBB, CCC)
          BBB = (DDD, EEE)
          CCC = (ZZZ, GGG)
          DDD = (DDD, DDD)
          EEE = (EEE, EEE)
          GGG = (GGG, GGG)
          ZZZ = (ZZZ, ZZZ)
        INPUT
      end
    end

    class NavigatorTest < Test::Unit::TestCase
      include Navigator

      def test_navigates_to_target_in_two_steps
        instructions = ["R", "L"]
        coordinates = {
          "AAA" => { L: "BBB", R: "CCC" },
          "BBB" => { L: "DDD", R: "EEE" },
          "CCC" => { L: "ZZZ", R: "GGG" },
          "DDD" => { L: "DDD", R: "DDD" },
          "EEE" => { L: "EEE", R: "EEE" },
          "GGG" => { L: "GGG", R: "GGG" },
          "ZZZ" => { L: "ZZZ", R: "ZZZ" },
        }

        steps = navigate_to_target(instructions, coordinates, initial_position: 'AAA')

        assert_equal 2, steps
      end

      def test_navigates_to_zzz_in_six_steps
        instructions = ["L", "L", "R"]
        coordinates = {
          "AAA" => { L: "BBB", R: "BBB" },
          "BBB" => { L: "AAA", R: "ZZZ" },
          "ZZZ" => { L: "ZZZ", R: "ZZZ" },
        }

        steps = navigate_to_target(instructions, coordinates, initial_position: 'AAA')

        assert_equal 6, steps
      end

      def was_criteria_met?(current_position)
        current_position == 'ZZZ'
      end
    end

    class Part01Test < Test::Unit::TestCase
      def test_solve
        assert_equal 2, Part01.new.solve(input: input)
      end

      def input
        <<~INPUT
          RL

          AAA = (BBB, CCC)
          BBB = (DDD, EEE)
          CCC = (ZZZ, GGG)
          DDD = (DDD, DDD)
          EEE = (EEE, EEE)
          GGG = (GGG, GGG)
          ZZZ = (ZZZ, ZZZ)
        INPUT
      end
    end

    class Part02Test < Test::Unit::TestCase
      def test_solve
        assert_equal 6, Part02.new.solve(input: input)
      end

      def test_navigate_all_targets_to_any_location_ending_with_z
        instructions = ["L", "R"]
        coordinates = {
          "11A" => { L: "11B", R: "XXX" },
          "11B" => { L: "XXX", R: "11Z" },
          "11Z" => { L: "11B", R: "XXX" },
          "22A" => { L: "22B", R: "XXX" },
          "22B" => { L: "22C", R: "22C" },
          "22C" => { L: "22Z", R: "22Z" },
          "22Z" => { L: "22B", R: "22B" },
          "XXX" => { L: "XXX", R: "XXX" }
        }

        assert_equal 6, Part02.new.navigate_all_targets_to_any_location_ending_with_z(
          instructions,
          coordinates
        )
      end

      def test_least_common_multiple
        assert_equal 6, Part02.new.least_common_multiple(2, 3)
        assert_equal 60, Part02.new.least_common_multiple(15, 20)
        assert_equal 242, Part02.new.least_common_multiple(121, 2)
      end

      def input
        <<~INPUT
          LR

          11A = (11B, XXX)
          11B = (XXX, 11Z)
          11Z = (11B, XXX)
          22A = (22B, XXX)
          22B = (22C, 22C)
          22C = (22Z, 22Z)
          22Z = (22B, 22B)
          XXX = (XXX, XXX)
        INPUT
      end
    end
  end
end
