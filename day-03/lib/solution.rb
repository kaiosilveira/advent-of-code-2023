module AoC2023
  module Day03
    def self.extract_numbers_with_metadata(line, line_idx:)
      mapped_numbers = []

      line.scan(/\d+/) do |number|
        start = Regexp.last_match.offset(0)[0]
        finish = start + number.size - 1
        mapped_numbers << { number: number, range: (start..finish), line: line_idx }
      end

      mapped_numbers
    end

    def self.extract_symbols_with_metadata(line, line_idx:)
      symbol_info = []

      line.scan(/[^.0-9]/) do |symbol|
        idx = Regexp.last_match.offset(0)[0]
        symbol_info << { symbol: symbol, index: idx, line: line_idx }
      end

      symbol_info
    end

    def self.is_symbol_adjacent_to_number?(symbol:, number:)
      number_start, number_end = number[:range].first, number[:range].last
      number_spread = ([0, number_start - 1].max)..(number_end + 1)
      symbol_spread = (symbol[:line] - 1)..(symbol[:line] + 1)
      number_spread.include?(symbol[:index]) && symbol_spread.include?(number[:line])
    end

    module Part01
      def self.get_sum_of_engine_part_numbers(engine_schematic)
        all_symbols = engine_schematic.flat_map.with_index do |line, i|
          Day03.extract_symbols_with_metadata(line.strip, line_idx: i)
        end

        all_numbers = engine_schematic.flat_map.with_index do |line, i|
          Day03.extract_numbers_with_metadata(line, line_idx: i)
        end

        engine_part_numbers = all_numbers.select do |number|
          is_engine_part_number?(number, all_symbols)
        end
puts engine_part_numbers.map { |n| n[:number].to_i }
        engine_part_numbers.map { |n| n[:number].to_i }.sum
      end

      def self.is_engine_part_number?(number, symbols)
        symbols.any? do |symbol|
          number_start = number[:range].first
          number_end = number[:range].last
          Day03.is_symbol_adjacent_to_number?(symbol: symbol, number: number)
        end
      end
    end

    module Part02
      def self.get_sum_of_gear_ratios(engine_schematic)
        all_symbols = engine_schematic.flat_map.with_index do |line, index|
          Day03.extract_symbols_with_metadata(line.strip, line_idx: index)
        end

        all_numbers = engine_schematic.flat_map.with_index do |line, index|
          Day03.extract_numbers_with_metadata(line.strip, line_idx: index)
        end

        gears = find_gears(all_numbers, all_symbols)
        gears.map { |gear| get_gear_ratio(gear) }.sum
      end

      def self.find_gears(numbers, symbols)
        gear_symbols = symbols.select { |s| s[:symbol] == '*' }.map do |s|
          adjacent_numbers = numbers.select do |number|
            Day03.is_symbol_adjacent_to_number?(symbol: s, number: number)
          end

          { symbol: s, adjacent_numbers: adjacent_numbers }
        end

        gears = gear_symbols.select { |g| g[:adjacent_numbers].size > 1 }
        gears
      end

      def self.get_gear_ratio(gear)
        gear[:adjacent_numbers].map { |n| n[:number].to_i }.reduce(:*)
      end
    end
  end
end
