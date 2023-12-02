require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day02
    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_check_game_feasibility
          constraints = { red: 12, green: 13, blue: 14 }
          game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
          game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
          game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
          game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
          game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

          assert_equal true, Part01.is_game_possible?(game_1, constraints)
          assert_equal true, Part01.is_game_possible?(game_2, constraints)
          assert_equal false, Part01.is_game_possible?(game_3, constraints)
          assert_equal false, Part01.is_game_possible?(game_4, constraints)
          assert_equal true, Part01.is_game_possible?(game_5, constraints)
        end

        def test_get_sum_of_possible_game_ids
          game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
          game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
          game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
          game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
          game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

          assert_equal 8, Part01.get_sum_of_possible_game_ids(
            games: [game_1, game_2, game_3, game_4, game_5],
            constraints: { red: 12, green: 13, blue: 14 }
          )
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_get_minimum_number_of_cubes_required
          game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
          game_1_expected_result = { red: 4, green: 2, blue: 6 }

          game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
          game_2_expected_result = { red: 1, green: 3, blue: 4 }

          game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
          game_3_expected_result = { red: 20, green: 13, blue: 6 }

          game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
          game_4_expected_result = { red: 14, green: 3, blue: 15 }

          game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
          game_5_expected_result = { red: 6, green: 3, blue: 2 }

          assert_equal game_1_expected_result, Part02.get_minimum_number_of_cubes_required(game_1)
          assert_equal game_2_expected_result, Part02.get_minimum_number_of_cubes_required(game_2)
          assert_equal game_3_expected_result, Part02.get_minimum_number_of_cubes_required(game_3)
          assert_equal game_4_expected_result, Part02.get_minimum_number_of_cubes_required(game_4)
          assert_equal game_5_expected_result, Part02.get_minimum_number_of_cubes_required(game_5)
        end

        def test_get_minimum_game_cube_set_power
          game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
          game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
          game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
          game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
          game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

          assert_equal 48, Part02.get_minimum_game_cube_set_power(game_1)
          assert_equal 12, Part02.get_minimum_game_cube_set_power(game_2)
          assert_equal 1560, Part02.get_minimum_game_cube_set_power(game_3)
          assert_equal 630, Part02.get_minimum_game_cube_set_power(game_4)
          assert_equal 36, Part02.get_minimum_game_cube_set_power(game_5)
        end

        def test_get_sum_of_minimum_game_cube_set_powers
          game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
          game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
          game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
          game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
          game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

          assert_equal 48 + 12 + 1560 + 630 + 36, Part02.get_sum_of_minimum_game_cube_set_powers(
            games: [game_1, game_2, game_3, game_4, game_5]
          )
        end
      end
    end
  end
end
