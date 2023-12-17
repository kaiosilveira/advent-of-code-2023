module AoC2023
  module DayN
    module Part01
      def self.solve(input:)
        tiles = label_pipes(input.split("\n")).flat_map do |row|
          row.reject { |tile| tile[:type] == :ground }
        end

        tiles.each do |tile|
          connections = find_connections(tiles, point: tile[:position])
          tile.merge!(connections: connections)
        end

        pipe_loop = tiles.select { |t| t[:connections].size == 2 }
        puts "size: #{pipe_loop.size}"
        pipe_loop.size / 2 + pipe_loop.size % 2
      end

      def self.label_pipes(lines)
        lines.map.with_index do |line, row|
          line.split('').map.with_index do |symbol, col|
            {
              type: get_pipe_type(symbol),
              symbol: symbol,
              position: { row: row + 1, col: col + 1}
            }
          end
        end
      end

      def self.find_connections(grid, point:)
        row = point[:row]
        col = point[:col]

        match_left = grid.find do |pipe|
          pipe[:position][:row] == row && pipe[:position][:col] == col - 1
        end

        match_right = grid.find do |pipe|
          pipe[:position][:row] == row && pipe[:position][:col] == col + 1
        end

        match_bottom = grid.find do |pipe|
          pipe[:position][:row] == row + 1 && pipe[:position][:col] == col
        end

        match_top = grid.find do |pipe|
          pipe[:position][:row] == row - 1 && pipe[:position][:col] == col
        end

        connections = [match_left, match_right, match_bottom, match_top].compact
        # connections << grid[y][x + 1] if grid[y][x + 1]
        # connections << grid[y][x - 1] if grid[y][x - 1]
        # connections << grid[y + 1][x] if grid[y + 1][x]
        # connections << grid[y - 1][x] if grid[y - 1][x]

        connections
      end

      def self.get_pipe_type(symbol)
        case symbol
        when "F"
          :ninety_dg_bend
        when "-"
          :horizontal
        when "7"
          :ninety_dg_bend
        when "|"
          :vertical
        when "J"
          :ninety_dg_bend
        when "L"
          :ninety_dg_bend
        when "."
          :ground
        end
      end
    end

    module Part02
      def self.solve(input:)
        1
      end
    end
  end
end
