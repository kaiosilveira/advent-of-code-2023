require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day07
    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_parse_input
          expected_result = { hand: ["3", "2", "T", "3", "K"], bid: 765, type: :one_pair }
          assert_equal expected_result, Day07.parse_input("32T3K 765")
        end

        def test_get_hand_type
          assert_equal :high_card, Day07.get_hand_type(["1", "2", "3", "4", "5"])
          assert_equal :one_pair, Day07.get_hand_type(["3", "2", "T", "3", "K"])
          assert_equal :two_pairs, Day07.get_hand_type(["K", "K", "6", "7", "7"])
          assert_equal :three_of_a_kind, Day07.get_hand_type(["Q", "Q", "Q", "J", "A"])
          assert_equal :full_house, Day07.get_hand_type(["2", "3", "3", "3", "2"])
          assert_equal :four_of_a_kind, Day07.get_hand_type(["A", "A", "8", "A", "A"])
          assert_equal :five_of_a_kind, Day07.get_hand_type(["A", "A", "A", "A", "A"])
        end

        def test_resolve_tie
          assert_equal -1, Part01.resolve_tie_between(
            ["5", "8", "7", "2", "T"], ["9", "5", "J", "8", "T"]
          )

          assert_equal 1, Part01.resolve_tie_between(
            ["9", "5", "J", "8", "T"], ["5", "8", "7", "2", "T"]
          )

          assert_equal -1, Part01.resolve_tie_between(
            ["K", "T", "J", "J", "T"], ["K", "K", "6", "7", "7"]
          )

          assert_equal 1, Part01.resolve_tie_between(
            ["K", "K", "6", "7", "7"], ["K", "T", "J", "J", "T"]
          )
        end

        def test_sort_hands_by_type
          hands = [
            Part01.enhance_hand_with_type({ hand: ["A", "A", "8", "A", "A"], bid: 684 }),
            Part01.enhance_hand_with_type({ hand: ["2", "3", "3", "3", "2"], bid: 28 }),
            Part01.enhance_hand_with_type({ hand: ["2", "3", "4", "5", "6"], bid: 483 }),
            Part01.enhance_hand_with_type({ hand: ["A", "A", "A", "A", "A"], bid: 765 }),
            Part01.enhance_hand_with_type({ hand: ["A", "2", "3", "A", "4"], bid: 220 }),
            Part01.enhance_hand_with_type({ hand: ["T", "T", "T", "9", "8"], bid: 220 }),
            Part01.enhance_hand_with_type({ hand: ["2", "3", "4", "3", "2"], bid: 220 }),
          ]

          expected_result = [
            { hand: ["2", "3", "4", "5", "6"], bid: 483, type: :high_card },
            { hand: ["A", "2", "3", "A", "4"], bid: 220, type: :one_pair },
            { hand: ["2", "3", "4", "3", "2"], bid: 220, type: :two_pairs },
            { hand: ["T", "T", "T", "9", "8"], bid: 220, type: :three_of_a_kind },
            { hand: ["2", "3", "3", "3", "2"], bid: 28, type: :full_house },
            { hand: ["A", "A", "8", "A", "A"], bid: 684, type: :four_of_a_kind },
            { hand: ["A", "A", "A", "A", "A"], bid: 765, type: :five_of_a_kind },
          ]

          assert_equal expected_result, Day07.sort_hands_by_type(hands)
        end

        def test_rank_hands
          hands = Day07.sort_hands_by_type([
            { hand: ["3", "2", "T", "3", "K"], bid: 765, type: :one_pair },
            { hand: ["T", "5", "5", "J", "5"], bid: 684, type: :three_of_a_kind },
            { hand: ["K", "K", "6", "7", "7"], bid: 28, type: :two_pairs },
            { hand: ["K", "T", "J", "J", "T"], bid: 220, type: :two_pairs },
            { hand: ["Q", "Q", "Q", "J", "A"], bid: 483, type: :three_of_a_kind },
          ])

          expected_result = [
            { hand: ["3", "2", "T", "3", "K"], bid: 765, type: :one_pair }, #1
            { hand: ["K", "T", "J", "J", "T"], bid: 220, type: :two_pairs }, # 2
            { hand: ["K", "K", "6", "7", "7"], bid: 28, type: :two_pairs }, # 3
            { hand: ["T", "5", "5", "J", "5"], bid: 684, type: :three_of_a_kind }, # 4
            { hand: ["Q", "Q", "Q", "J", "A"], bid: 483, type: :three_of_a_kind }, # 5
          ]

          assert_equal expected_result, Part01.rank_hands(hands)
        end

        def test_rank_hands_same_type
          hands = [
            { hand: ["4", "8", "5", "2", "6"], bid: 765, type: :high_card },
            { hand: ["6", "Q", "8", "T", "7"], bid: 684, type: :high_card },
            { hand: ["9", "5", "J", "8", "T"], bid: 28, type: :high_card },
            { hand: ["5", "8", "7", "2", "T"], bid: 220, type: :high_card },
            { hand: ["3", "4", "5", "2", "7"], bid: 483, type: :high_card },
            { hand: ["7", "A", "8", "J", "5"], bid: 483, type: :high_card },
            { hand: ["8", "7", "9", "5", "Q"], bid: 483, type: :high_card },
            { hand: ["T", "8", "7", "2", "9"], bid: 483, type: :high_card },
            { hand: ["5", "K", "4", "7", "2"], bid: 483, type: :high_card },
          ]

          expected_result = [
            { hand: ["3", "4", "5", "2", "7"], bid: 483, type: :high_card },
            { hand: ["4", "8", "5", "2", "6"], bid: 765, type: :high_card },
            { hand: ["5", "8", "7", "2", "T"], bid: 220, type: :high_card },
            { hand: ["5", "K", "4", "7", "2"], bid: 483, type: :high_card },
            { hand: ["6", "Q", "8", "T", "7"], bid: 684, type: :high_card },
            { hand: ["7", "A", "8", "J", "5"], bid: 483, type: :high_card },
            { hand: ["8", "7", "9", "5", "Q"], bid: 483, type: :high_card },
            { hand: ["9", "5", "J", "8", "T"], bid: 28, type: :high_card },
            { hand: ["T", "8", "7", "2", "9"], bid: 483, type: :high_card },
          ]

          assert_equal expected_result, Part01.rank_hands(hands)
        end
        
        def test_get_total_winnings
          hands = [
            { hand: ["3", "2", "T", "3", "K"], bid: 765, type: :one_pair }, #1
            { hand: ["K", "T", "J", "J", "T"], bid: 220, type: :two_pairs }, # 2
            { hand: ["K", "K", "6", "7", "7"], bid: 28, type: :two_pairs }, # 3
            { hand: ["T", "5", "5", "J", "5"], bid: 684, type: :three_of_a_kind }, # 4
            { hand: ["Q", "Q", "Q", "J", "A"], bid: 483, type: :three_of_a_kind }, # 5
          ]

          expected_result = 765 * 1 + 220 * 2 + 28 * 3 + 684 * 4 + 483 * 5
          assert_equal expected_result, Part01.get_total_winnings(hands)
        end

        def input
          [
            "32T3K 765",
            "T55J5 684",
            "KK677 28",
            "KTJJT 220",
            "QQQJA 483",
          ]
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_solve
          assert_equal 765 * 1 + 28 * 2 + 684 * 3 + 483 * 4 + 220 * 5, Part02.solve(input: input)
        end

        def test_get_total_winnings
          hands = [
            { hand: ["3", "2", "T", "3", "K"], bid: 765, type: :one_pair },
            { hand: ["K", "K", "6", "7", "7"], bid: 28, type: :two_pairs },
            { hand: ["T", "5", "5", "J", "5"], bid: 684, type: :three_of_a_kind },
            { hand: ["Q", "Q", "Q", "J", "A"], bid: 483, type: :three_of_a_kind },
            { hand: ["K", "T", "J", "J", "T"], bid: 220, type: :two_pairs },
          ]

          expected_result = 765 * 1 + 28 * 2 + 684 * 3 + 483 * 4 + 220 * 5
          assert_equal expected_result, Part02.get_total_winnings(hands)
        end

        def test_rank_hands
          hands = [
            {
              original_hand: ["3", "2", "T", "3", "K"],
              updated_hand: ["3", "2", "T", "3", "K"],
              bid: 765,
              type: :one_pair,
            },
            {
              original_hand: ["T", "5", "5", "J", "5"],
              updated_hand: ["T", "5", "5", "5", "5"],
              bid: 684,
              type: :four_of_a_kind,
            },
            {
              original_hand: ["K", "K", "6", "7", "7"],
              bid: 28,
              type: :two_pairs,
            },
            {
              original_hand: ["K", "T", "J", "J", "T"],
              bid: 220,
              type: :four_of_a_kind,
            },
            {
              original_hand: ["Q", "Q", "Q", "J", "A"],
              bid: 483,
              type: :four_of_a_kind,
            },
          ]

          expected_result = [
            {
              original_hand: ["3", "2", "T", "3", "K"],
              updated_hand: ["3", "2", "T", "3", "K"],
              bid: 765,
              type: :one_pair,
            },
            {
              original_hand: ["K", "K", "6", "7", "7"],
              bid: 28,
              type: :two_pairs,
            },
            {
              original_hand: ["T", "5", "5", "J", "5"],
              updated_hand: ["T", "5", "5", "5", "5"],
              bid: 684,
              type: :four_of_a_kind,
            },
            {
              original_hand: ["Q", "Q", "Q", "J", "A"],
              bid: 483,
              type: :four_of_a_kind,
            },
            {
              original_hand: ["K", "T", "J", "J", "T"],
              bid: 220,
              type: :four_of_a_kind,
            },
          ]

          assert_equal expected_result, Part02.rank_hands(hands)
        end

        def test_get_best_possible_hand
          hand_1 = {
            original_hand: ["1", "2", "3", "4", "5"],
            updated_hand: ["1", "2", "3", "4", "5"],
            type: :high_card
          }
          assert_equal hand_1, Part02.get_best_possible_hand(["1", "2", "3", "4", "5"])

          hand_2 = {
            original_hand: ["1", "2", "3", "4", "J"],
            updated_hand: ["1", "2", "3", "4", "4"],
            type: :one_pair
          }
          assert_equal hand_2, Part02.get_best_possible_hand(["1", "2", "3", "4", "J"])

          hand_3 = {
            original_hand: ["1", "2", "3", "J", "J"],
            updated_hand: ["1", "2", "3", "3", "3"],
            type: :three_of_a_kind
          }
          assert_equal hand_3, Part02.get_best_possible_hand(["1", "2", "3", "J", "J"])

          hand_4 = {
            original_hand: ["1", "2", "J", "J", "J"],
            updated_hand: ["1", "2", "2", "2", "2"],
            type: :four_of_a_kind
          }
          assert_equal hand_4, Part02.get_best_possible_hand(["1", "2", "J", "J", "J"])

          hand_5 = {
            original_hand: ["1", "J", "J", "J", "J"],
            updated_hand: ["1", "1", "1", "1", "1"],
            type: :five_of_a_kind
          }
          assert_equal hand_5, Part02.get_best_possible_hand(["1", "J", "J", "J", "J"])

          hand_6 = {
            original_hand: ["K", "T", "J", "J", "T"],
            updated_hand: ["K", "T", "T", "T", "T"],
            type: :four_of_a_kind
          }
          assert_equal hand_6, Part02.get_best_possible_hand(["K", "T", "J", "J", "T"])

          hand_7 = {
            original_hand: ["Q", "Q", "Q", "J", "A"],
            updated_hand: ["Q", "Q", "Q", "Q", "A"],
            type: :four_of_a_kind
          }
          assert_equal hand_7, Part02.get_best_possible_hand(["Q", "Q", "Q", "J", "A"])
        end

        def input
          [
            "32T3K 765",
            "T55J5 684",
            "KK677 28",
            "KTJJT 220",
            "QQQJA 483",
          ]
        end
      end
    end
  end
end
