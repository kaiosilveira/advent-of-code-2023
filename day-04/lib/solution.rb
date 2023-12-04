module AoC2023
  module Day04
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
      def self.solve(input:)
        1
      end
    end
  end
end
