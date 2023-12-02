module AoC2023
  module Day02

    def self.get_total_cubes_used_per_round(round)
      round.reduce({ red: 0, green: 0, blue: 0 }) { |total, hash| total.merge(hash) }
    end

    def self.get_cubes_used_in_each_game_round(game_info)
      game_name, round_info = game_info.split(':')
      all_rounds = round_info.split(';')
      cubes_per_round = all_rounds.map do |round|
        numbers_and_colors = round.split(',').map(&:strip).map(&:split)
        numbers_and_colors.map { |number, color| { color.to_sym => number.to_i } }
      end

      cubes_per_round.map { |round| get_total_cubes_used_per_round(round) }
    end

    module Part01
      def self.is_game_possible?(game_info, constraints)
        cubes_used_per_round = Day02.get_cubes_used_in_each_game_round(game_info)

        round_feasibility_result = cubes_used_per_round.map do |cubes_used|
          were_round_within_constraints?(cubes_used, constraints)
        end

        round_feasibility_result.all? { |was_possible| was_possible == true }
      end

      def self.get_sum_of_possible_game_ids(games:, constraints:)
        games
          .select { |game_info| is_game_possible?(game_info, constraints) }
          .map { |game_info| game_info.split(':').first.split(' ').last.to_i }
          .reduce(:+)
      end

      def self.were_round_within_constraints?(total_cubes_used, constraints)
        within_constraints = %w[red green blue].map(&:to_sym).map do |color|
          total_cubes_used[color] <= constraints[color]
        end

        within_constraints.all? { |was_possible| was_possible == true }
      end
    end

    module Part02
      def self.get_minimum_number_of_cubes_required(game_info)
        minimum_cube_requirements = { red: 0, green: 0, blue: 0 }

        cubes_used_per_round = Day02.get_cubes_used_in_each_game_round(game_info)
        cubes_used_per_round.map do |cubes_used|
          cubes_used.map do |color, count|
            minimum_cube_requirements[color] = [count, minimum_cube_requirements[color]].max
          end
        end

        minimum_cube_requirements
      end

      def self.get_minimum_game_cube_set_power(game_info)
        minimum_cube_requirements = get_minimum_number_of_cubes_required(game_info)
        %w[red green blue].map { |color| minimum_cube_requirements[color.to_sym] }.reduce(:*)
      end

      def self.get_sum_of_minimum_game_cube_set_powers(games:)
        games
          .map { |game_info| get_minimum_game_cube_set_power(game_info) }
          .reduce(:+)
      end
    end
  end
end
