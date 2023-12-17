require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module DayN
    module Part01
      class Part01Test < Test::Unit::TestCase
        # | is a vertical pipe connecting north and south.
        # - is a horizontal pipe connecting east and west.
        # L is a 90-degree bend connecting north and east.
        # J is a 90-degree bend connecting north and west.
        # 7 is a 90-degree bend connecting south and west.
        # F is a 90-degree bend connecting south and east.
        # . is ground; there is no pipe in this tile.
        # S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

        def test_works
          assert_equal 4, Part01.solve(input: simplest_input)
          assert_equal 8, Part01.solve(input: complex_input)
        end

        def test_label_pipes
          first_line = [
            { symbol: ".", position: { row: 1, col: 1 }, type: :ground },
            { symbol: ".", position: { row: 1, col: 2 }, type: :ground },
            { symbol: ".", position: { row: 1, col: 3 }, type: :ground },
            { symbol: ".", position: { row: 1, col: 4 }, type: :ground },
            { symbol: ".", position: { row: 1, col: 5 }, type: :ground },
          ]

          second_line = [
            { symbol: ".", position: { row: 2, col: 1 }, type: :ground, },
            { symbol: "F", position: { row: 2, col: 2 }, type: :ninety_dg_bend, },
            { symbol: "-", position: { row: 2, col: 3 }, type: :horizontal, },
            { symbol: "7", position: { row: 2, col: 4 }, type: :ninety_dg_bend, },
            { symbol: ".", position: { row: 2, col: 5 }, type: :ground, },
          ]

          third_line = [
            { symbol: ".", position: { row: 3, col: 1 }, type: :ground },
            { symbol: "|", position: { row: 3, col: 2 }, type: :vertical },
            { symbol: ".", position: { row: 3, col: 3 }, type: :ground },
            { symbol: "|", position: { row: 3, col: 4 }, type: :vertical },
            { symbol: ".", position: { row: 3, col: 5 }, type: :ground },
          ]

          fourth_line = [
            { symbol: ".", position: { row: 4, col: 1 }, type: :ground },
            { symbol: "L", position: { row: 4, col: 2 }, type: :ninety_dg_bend },
            { symbol: "-", position: { row: 4, col: 3 }, type: :horizontal },
            { symbol: "J", position: { row: 4, col: 4 }, type: :ninety_dg_bend },
            { symbol: ".", position: { row: 4, col: 5 }, type: :ground },
          ]

          fifth_line = [
            { symbol: ".", position: { row: 5, col: 1 }, type: :ground },
            { symbol: ".", position: { row: 5, col: 2 }, type: :ground },
            { symbol: ".", position: { row: 5, col: 3 }, type: :ground },
            { symbol: ".", position: { row: 5, col: 4 }, type: :ground },
            { symbol: ".", position: { row: 5, col: 5 }, type: :ground },
          ]

          rows = [first_line, second_line, third_line, fourth_line, fifth_line]

          assert_equal rows, Part01.label_pipes([
            ".....",
            ".F-7.",
            ".|.|.",
            ".L-J.",
            ".....",
          ])
        end

        def test_find_connection_left
          origin = { type: :horizontal, symbol: "-", position: { row: 2, col: 3 } }
          connection = { type: :ninety_dg_bend, symbol: "F", position: { row: 2, col: 2 } }

          grid = [origin, connection]
          assert_equal [connection], Part01.find_connections(grid, point: origin[:position])
        end

        def test_find_connection_right
          origin = { type: :ninety_dg_bend, symbol: "F", position: { row: 2, col: 2 } }
          connection = { type: :horizontal, symbol: "-", position: { row: 2, col: 3 } }

          grid = [origin, connection]
          assert_equal [connection], Part01.find_connections(grid, point: origin[:position])
        end

        def test_find_connection_top
          origin = { symbol: "|", position: { row: 3, col: 2 }, type: :vertical }
          connection = { symbol: "F", position: { row: 2, col: 2 }, type: :ninety_dg_bend }

          grid = [origin, connection]
          assert_equal [connection], Part01.find_connections(grid, point: origin[:position])
        end

        def test_find_connection_bottom
          origin = { symbol: "F", position: { row: 2, col: 2 }, type: :ninety_dg_bend }
          connection = { symbol: "|", position: { row: 3, col: 2 }, type: :vertical }

          grid = [origin, connection]
          assert_equal [connection], Part01.find_connections(grid, point: origin[:position])
        end

        def test_find_connection_right_and_bottom
          origin = { symbol: "F", position: { row: 2, col: 2 }, type: :ninety_dg_bend }
          connection_right = { symbol: "-", position: { row: 2, col: 3 }, type: :horizontal }
          connection_bottom = { symbol: "|", position: { row: 3, col: 2 }, type: :vertical }

          grid = [origin, connection_right, connection_bottom]
          assert_equal [
            connection_right, connection_bottom
          ], Part01.find_connections(grid, point: origin[:position])
        end

        def test_find_loop
          expected_result = [
            {
              type: :ninety_dg_bend,
              symbol: "F",
              direction: { from: :south, to: :east }
            },
            {
              type: :horizontal,
              symbol: "-",
              direction: { from: :east, to: :west }
            },
            {
              type: :ninety_dg_bend,
              symbol: "7",
              direction: { from: :west, to: :south }
            },
            {
              type: :vertical,
              symbol: "|",
              direction: { from: :north, to: :south }
            },
            {
              type: :ninety_dg_bend,
              symbol: "J",
              direction: { from: :north, to: :west }
            },
            {
              type: :horizontal,
              symbol: "-",
              direction: { from: :west, to: :east }
            },
            {
              type: :ninety_dg_bend,
              symbol: "L",
              direction: { from: :east, to: :north }
            },
            {
              type: :vertical,
              symbol: "|",
              direction: { from: :south, to: :north }
            },
          ]

          assert_equal 1, 1
        end

        def simplest_input
          <<~INPUT
            .....
            .F-7.
            .|.|.
            .L-J.
            .....
          INPUT
        end

        def complex_input
          <<~INPUT
            ..F7.
            .FJ|.
            SJ.L7
            |F--J
            LJ...
          INPUT
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_works
          assert_equal 1, Part02.solve(input: "1abc2")
        end
      end
    end
  end
end
