module AoC2023
  module Day09
    def self.find_difference_pattern(line)
      line.each_cons(2).map { |a, b| b - a }
    end

    def self.parse_input(input)
      input.split("\n").map { |line| line.split(" ").map(&:to_i) }
    end

    def self.predict_next_number(sequence, direction:)
      return sequence.first if sequence.all? { |v| v == sequence.first }

      difference_pattern = find_difference_pattern(sequence)
      next_number = predict_next_number(difference_pattern, direction: direction)

      return sequence.last + next_number if direction == :forward
      return sequence.first - next_number if direction == :backward
    end

    module Part01
      def self.solve(input)
        sequences = Day09.parse_input(input)
        next_numbers = sequences.map { |s| Day09.predict_next_number(s, direction: :forward) }
        next_numbers.sum
      end
    end

    module Part02
      def self.solve(input)
        sequences = Day09.parse_input(input)
        next_numbers = sequences.map { |s| Day09.predict_next_number(s, direction: :backward) }
        next_numbers.sum
      end
    end
  end
end
