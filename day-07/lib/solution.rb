module AoC2023
  module Day07
    def self.get_hand_type(hand)
      distinct_cards = hand.uniq

      return :high_card if distinct_cards.size == 5
      return :one_pair if distinct_cards.size == 4
      return Day07.has_two_pairs?(hand) ? :two_pairs : :three_of_a_kind if distinct_cards.size == 3
      return Day07.has_full_house?(hand) ? :full_house : :four_of_a_kind if distinct_cards.size == 2
      return :five_of_a_kind if distinct_cards.size == 1
    end

    def self.has_two_pairs?(hand)
      distinct_cards = hand.uniq
      distinct_cards.map { |c| hand.count { |cc| cc == c } }.intersect?([2, 2])
    end

    def self.has_full_house?(hand)
      distinct_cards = hand.uniq
      distinct_cards.map { |c| hand.count { |cc| cc == c } }.intersect?([3, 2])
    end

    def self.sort_hands_by_type(hands)
      hands.sort_by { |hand_info| hand_rankings[hand_info[:type]] }
    end

    def self.parse_input(input)
      hand, bid = input.split(" ")
      bid = bid.to_i
      hand = hand.split("")

      { hand: hand, bid: bid, type: Day07.get_hand_type(hand) }
    end

    def self.hand_rankings
      {
        :high_card => 1,
        :one_pair => 2,
        :two_pairs => 3,
        :three_of_a_kind => 4,
        :full_house => 5,
        :four_of_a_kind => 6,
        :five_of_a_kind => 7,
      }
    end

    module Part01
      def self.enhance_hand_with_type(hand_info)
        hand = hand_info[:hand]
        distinct_cards = hand.uniq

        return hand_info.clone.merge(type: :high_card) if distinct_cards.size == 5
        return hand_info.clone.merge(type: :one_pair) if distinct_cards.size == 4
        return hand_info.clone.merge(type: :five_of_a_kind) if distinct_cards.size == 1

        return hand_info.clone.merge(
          type: Day07.has_two_pairs?(hand) ? :two_pairs : :three_of_a_kind
        ) if distinct_cards.size == 3

        return hand_info.clone.merge(
          type: Day07.has_full_house?(hand) ? :full_house : :four_of_a_kind
        ) if distinct_cards.size == 2
      end

      def self.resolve_tie_between(hand1, hand2)
        order = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

        0.upto(5) do |i|
          return -1 if order.index(hand1[i]) > order.index(hand2[i])
          return 1 if order.index(hand1[i]) < order.index(hand2[i])
        end

        0
      end

      def self.get_total_winnings(hands)
        hands.map.with_index { |hand_info, i| hand_info[:bid] * (i + 1) }.sum
      end

      def self.rank_hands(hands)
        ranked_hands = hands.sort do |hand_info1, hand_info2|
          if hand_info1[:type] == hand_info2[:type]
            resolve_tie_between(hand_info1[:hand], hand_info2[:hand])
          else
            Day07.hand_rankings[hand_info1[:type]] <=> Day07.hand_rankings[hand_info2[:type]]
          end
        end
  
        ranked_hands
      end

      def self.solve(input:)
        unsorted_hands = input.map { |line| enhance_hand_with_type(Day07.parse_input(line)) }
        ranked_hands = rank_hands(Day07.sort_hands_by_type(unsorted_hands))

        get_total_winnings(ranked_hands)
      end
    end

    module Part02
      def self.solve(input:)
        unsorted_hands = input.map { |line| Day07.parse_input(line) }.map do |hand_info|
          get_best_possible_hand(hand_info[:hand]).merge(bid: hand_info[:bid])
        end

        ranked_hands = rank_hands(Day07.sort_hands_by_type(unsorted_hands))
        get_total_winnings(ranked_hands)
      end

      def self.rank_hands(hands)
        ranked_hands = hands.sort do |hand_info1, hand_info2|
          if hand_info1[:type] == hand_info2[:type]
            resolve_tie_between(hand_info1[:original_hand], hand_info2[:original_hand])
          else
            Day07.hand_rankings[hand_info1[:type]] <=> Day07.hand_rankings[hand_info2[:type]]
          end
        end
  
        ranked_hands
      end

      def self.resolve_tie_between(hand1, hand2)
        order = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

        0.upto(5) do |i|
          return -1 if order.index(hand1[i]) > order.index(hand2[i])
          return 1 if order.index(hand1[i]) < order.index(hand2[i])
        end

        0
      end

      def self.get_total_winnings(hands)
        hands.map.with_index { |hand_info, i| hand_info[:bid] * (i + 1) }.sum
      end

      def self.get_best_possible_hand(hand)
        number_of_jokers = hand.count { |card| card == "J" }
        if number_of_jokers == 0 || number_of_jokers == 5
          return { original_hand: hand, updated_hand: hand, type: Day07.get_hand_type(hand) }
        end

        updated_hand = convert_jokers(hand)

        { original_hand: hand, updated_hand: updated_hand, type: Day07.get_hand_type(updated_hand) }
      end

      def self.convert_jokers(hand)
        hand_without_jokers = hand.reject { |card| card == "J" }
        grouped_cards = hand_without_jokers.group_by { |card| card }.map do |card, instances|
          { card: card, instances: instances.size }
        end
      
        most_repeated_cards = grouped_cards.sort_by { |i| i[:instances] }
        most_repeated_card = most_repeated_cards.last
        updated_hand = hand.map { |card| card == "J" ? most_repeated_card[:card] : card }

        updated_hand
      end
    end
  end
end
