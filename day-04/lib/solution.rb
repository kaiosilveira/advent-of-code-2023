module AoC2023
  module Day04
    def self.parse_card_information(line)
      card_name, card_data = line.split(":")
      winning_numbers, owned_numbers = card_data.split("|").map(&:strip)

      {
        id: card_name.split(" ").last.to_i,
        winning_numbers: winning_numbers.split.map(&:to_i),
        owned_numbers: owned_numbers.split.map(&:to_i)
      }
    end

    def self.find_owned_winning_numbers(card_info)
      card_info[:winning_numbers] & card_info[:owned_numbers]
    end

    module Part01
      def self.solve(scratchcards:)
        result = scratchcards.map do |line|
          calculate_card_points(Day04.parse_card_information(line))
        end

        result.compact.reduce(&:+)
      end

      def self.calculate_card_points(card_info)
        Day04.find_owned_winning_numbers(card_info).map{ 1 }.reduce { |sum, n| sum * 2 }
      end
    end

    module Part02
      def self.process_turn(card_played:, all_cards:)
        owned_winning_numbers = Day04.find_owned_winning_numbers(card_played)

        card_ids_to_select = 1.upto(owned_winning_numbers.size).map do |n|
          card_played[:id] + n
        end

        newly_acquired_card_copies = all_cards.clone.select do |card|
          card_ids_to_select.include?(card[:id])
        end

        { newly_acquired_card_copies: newly_acquired_card_copies }
      end

      def self.get_final_card_count(initial_hand:)
        mappings = {}
        processed_queue = {}
        initial_hand.each do |card|
          turn_result = process_turn(card_played: card, all_cards: initial_hand)
          mappings[card[:id]] = turn_result[:newly_acquired_card_copies].map { |c| c[:id] }
          processed_queue[card[:id]] = 0
        end

        queue = mappings.keys
        processed_item_count = 0
        while queue.any?
          processed_item_count += 1
          card_id = queue.shift
          new_cards = mappings[card_id]
          new_cards.each { |new_card_id| queue << new_card_id }
        end

        processed_item_count
      end

      def self.solve(scratchcards:)
        parsed_cards = scratchcards.map { |line| Day04.parse_card_information(line) }
        get_final_card_count(initial_hand: parsed_cards)
      end
    end
  end
end
