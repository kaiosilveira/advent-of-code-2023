module AoC2023
  module Day01
    module Part01
      def self.get_calibration_value_from(value)
        numbers = value.scan(/\d/)
        first, last = numbers.first, numbers.last

        "#{first}#{last}".to_i
      end
  
      def self.get_combined_calibration_value(input:)
        input.map { |value| get_calibration_value_from(value) }.reduce(:+)
      end
    end

    module Part02
      NUMBER_NAMES = %w[zero one two three four five six seven eight nine]

      def self.get_calibration_value_from(value)
        first = find_first_digit(value)
        last = find_last_digit(value)

        "#{first}#{last}".to_i
      end

      def self.find_first_digit(value)
        regex = /([1-9])|(one|two|three|four|five|six|seven|eight|nine)/
        first_digit = parse_number_names(scan_input_using_regex(value, regex)).first

        first_digit
      end

      def self.find_last_digit(value)
        regex = /([1-9])|(#{NUMBER_NAMES.map(&:reverse).join('|')})/
        sanitized_matches = scan_input_using_regex(value.reverse, regex).reverse.map(&:reverse)
        last_digit = parse_number_names(sanitized_matches).last

        last_digit
      end

      def self.scan_input_using_regex(input, regex)
        input.scan(regex).flat_map { |i| i }.filter { |i| !i.nil? }
      end

      def self.parse_number_names(input)
        input.map { |i| i.to_i == 0 ? NUMBER_NAMES.index(i) : i }
      end

      def self.get_combined_calibration_value(input:)
        input.map { |value| get_calibration_value_from(value) }.reduce(:+)
      end
    end
  end
end
