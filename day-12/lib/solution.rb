module AoC2023
  module Day12
    module Part01
      def self.solve(input:)
        1
      end

      def self.parse_input(input)
        raw_pattern, numbers = input.split(' ')
        numbers = numbers.split(',').map(&:to_i)
        pattern = raw_pattern.scan(/[\?+\#?]+/)

        [numbers, pattern].transpose.map do |number, pattern|
          { number_of_damaged_springs: number, pattern: pattern }
        end
      end

      def self.get_number_of_arrangements(pattern:, number_of_damaged_springs:)
        return pattern.size if pattern.chars.all? { |char| char == '#' }

        known_positions = pattern.count('#')
        unknown_positions = pattern.count('?')
        springs_to_allocate = (number_of_damaged_springs - known_positions).abs
        puts "unknown_positions: #{unknown_positions}"
        puts "springs_to_allocate: #{springs_to_allocate}"

        springs_to_allocate * unknown_positions
      end
    end

    module Part02
      def self.solve(input:)
        1
      end
    end
  end
end
