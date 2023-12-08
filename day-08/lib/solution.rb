module AoC2023
  module Day08
    module InputParser
      def parse_input(input)
        instructions_str, rest = input.split("\n\n")
        instructions = instructions_str.split("")
        coordinates = rest.split("\n").map do |line|
          name, position_string = line.split(" = ")
          position_left, position_right = position_string.gsub("(", "").gsub(")", "").split(", ")
          position = { L: position_left, R: position_right }
          [name, position]
        end.to_h
  
        [instructions, coordinates]
      end
    end

    module Navigator
      def navigate_to_target(instructions, coordinates, initial_position:)
        steps = 0
        current_instruction_index = 0

        current_position = initial_position.clone
        current_element = coordinates[current_position]

        while !was_criteria_met?(current_position)
          steps += 1
          instruction = instructions[current_instruction_index % instructions.length]
          current_instruction_index += 1
          current_position = current_element[instruction.to_sym]
          current_element = coordinates[current_position]
        end

        steps
      end
    end

    class Part01
      include Day08::Navigator
      include Day08::InputParser

      def solve(input:)
        instructions, coordinates = parse_input(input)
        navigate_to_target(instructions, coordinates, initial_position: 'AAA')
      end

      def was_criteria_met?(current_position)
        current_position == 'ZZZ'
      end
    end

    class Part02
      include Day08::Navigator
      include Day08::InputParser

      def solve(input:)
        instructions, coordinates = parse_input(input)
        navigate_all_targets_to_any_location_ending_with_z(instructions, coordinates)
      end

      def navigate_all_targets_to_any_location_ending_with_z(instructions, coordinates)
        steps = 0
        current_instruction_index = 0
        initial_positions = coordinates.keys.select { |key| key.end_with?('A') }
        current_elements = initial_positions.map { |t| coordinates[t] }

        steps = initial_positions.map do |position|
          navigate_to_target(instructions, coordinates, initial_position: position)
        end

        least_common_multiple(*steps)
      end

      def was_criteria_met?(current_position)
        current_position.end_with?('Z')
      end

      def least_common_multiple(*numbers)
        numbers.reduce(1, :lcm)
      end
    end
  end
end
