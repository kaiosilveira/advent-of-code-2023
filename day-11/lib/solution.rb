module AoC2023
  module Day11
    def self.map_galaxies(expanded_universe)
      galaxies = []

      expanded_universe.each.with_index do |row, row_idx|
        row.each.with_index do |col, col_idx|
          galaxies << { n: galaxies.size + 1, coords: [row_idx + 1, col_idx + 1] } if col == '#'
        end
      end

      galaxies
    end

    def self.analyze_universe_expansion(universe_lines)
      [
        find_expansible_lines(universe_lines),
        find_expansible_lines(universe_lines.transpose)
      ]
    end

    def self.find_expansible_lines(universe_line)
      universe_line.map
        .with_index { |l, idx| line_has_only_empty_spaces?(l) ? idx + 1 : nil }
        .compact
    end

    def self.line_has_only_empty_spaces?(line)
      line.all? { |c| c == '.' }
    end

    def self.find_minimum_number_of_steps_between(
      first_galaxy, second_galaxy, expansion_analysis:, multiplier_factor:
    )
      extra_rows, extra_cols = expansion_analysis
      first_row, first_col = first_galaxy[:coords]
      second_row, second_col = second_galaxy[:coords]

      projected_row_distance = get_projected_distance(
        first_row, second_row, extra_rows, multiplier_factor
      )

      projected_col_distance = get_projected_distance(
        first_col, second_col, extra_cols, multiplier_factor
      )

      projected_row_distance + projected_col_distance
    end

    def self.get_projected_distance(p1, p2, extra_points, multiplier_factor)
      point_distance = (p1 - p2).abs
      crossed_expanded_points = extra_points.count { |l| line_has_point?(p1, p2, l) }
      additional_points = crossed_expanded_points * multiplier_factor - crossed_expanded_points
      projected_distance = point_distance + additional_points
    end

    def self.line_has_point?(l1, l2, point)
      first, last = [l1, l2].sort
      first < point && point < last
    end

    def self.get_minimum_distance_combinations(galaxies, expansion_analysis, multiplier_factor = 2)
      minimum_distances = galaxies.combination(2).map do |galaxy1, galaxy2|
        Day11.find_minimum_number_of_steps_between(
          galaxy1,
          galaxy2,
          expansion_analysis: expansion_analysis,
          multiplier_factor: multiplier_factor
        )
      end

      minimum_distances
    end

    module Part01
      def self.solve(input:)
        universe = input.split("\n").map(&:strip).map { |r| r.chars }
        galaxies = Day11.map_galaxies(universe)
        expansion_analysis = Day11.analyze_universe_expansion(universe)
        minimum_distances = Day11.get_minimum_distance_combinations(galaxies, expansion_analysis)

        minimum_distances.sum
      end
    end

    module Part02
      def self.solve(input:, multiplier_factor:)
        universe = input.split("\n").map(&:strip).map { |r| r.chars }
        galaxies = Day11.map_galaxies(universe)
        expansion_analysis = Day11.analyze_universe_expansion(universe)
        minimum_distances = Day11.get_minimum_distance_combinations(
          galaxies, expansion_analysis, multiplier_factor
        )

        minimum_distances.sum
      end
    end
  end
end
