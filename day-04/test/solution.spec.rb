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
        def test_process_turn
          card_01, card_02, card_03, card_04, card_05 = all_cards
          newly_acquired_card_copies = [card_02, card_03, card_04, card_05]
          result = Part02.process_turn(card_played: card_01, all_cards: all_cards)

          assert_equal newly_acquired_card_copies, result[:newly_acquired_card_copies]
        end

        def test_get_final_card_count
          assert_equal 30, Part02.get_final_card_count(initial_hand: all_cards)
        end

        def all_cards
          card_01 = {
            id: 1,
            winning_numbers: [41, 48, 83, 86, 17],
            owned_numbers: [83, 86, 6, 31, 17, 9, 48, 53]
          }

          card_02 = {
            id: 2,
            winning_numbers: [13, 32, 20, 16, 61],
            owned_numbers: [61, 30, 68, 82, 17, 32, 24, 19]
          }

          card_03 = {
            id: 3,
            winning_numbers: [1, 21, 53, 59, 44],
            owned_numbers: [69, 82, 63, 72, 16, 21, 14, 1]
          }

          card_04 = {
            id: 4,
            winning_numbers: [41, 92, 73, 84, 69],
            owned_numbers: [59, 84, 76, 51, 58, 5, 54, 83]
          }

          card_05 = {
            id: 5,
            winning_numbers: [87, 83, 26, 28, 32],
            owned_numbers: [88, 30, 70, 12, 93, 22, 82, 36]
          }

          card_06 = { 
            id: 6,
            winning_numbers: [31, 18, 13, 56, 72],
            owned_numbers: [74, 77, 10, 23, 35, 67, 36, 11]
          }

          [card_01, card_02, card_03, card_04, card_05, card_06]
        end
      end
    end
  end
end
