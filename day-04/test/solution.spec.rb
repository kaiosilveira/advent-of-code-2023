require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day04
    class Day04Test < Test::Unit::TestCase
      def test_parses_card_information_correctly
        card_line = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
        card_info = Day04.parse_card_information(card_line)

        assert_equal 1, card_info[:id]
        assert_equal [41, 48, 83, 86, 17], card_info[:winning_numbers]
        assert_equal [83, 86, 6, 31, 17, 9, 48, 53], card_info[:owned_numbers]
      end

      def test_find_owned_winning_numbers
        card_info = {
          winning_numbers: [41, 48, 83, 86, 17],
          owned_numbers: [83, 86, 6, 31, 17, 9, 48, 53]
        }

        assert_equal [48, 83, 86, 17], Day04.find_owned_winning_numbers(card_info)
      end
    end

    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_calculates_card_points
          card_info = {
            winning_numbers: [41, 48, 83, 86, 17],
            owned_numbers: [83, 86, 6, 31, 17, 9, 48, 53]
          }

          assert_equal 8, Part01.calculate_card_points(card_info)
        end

        def test_solves_the_problem
          assert_equal 13, Part01.solve(scratchcards: sample_input)
        end

        def sample_input
          [
            "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
            "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
            "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
            "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
            "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
            "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
          ]
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
