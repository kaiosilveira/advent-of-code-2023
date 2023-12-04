require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day03

    class Day03Test < Test::Unit::TestCase
      def test_extract_numbers_and_their_metadata
        line = "467..114..114"

        expected_result_with_metadata = [
          { number: "467", range: (0..2), line: 1 },
          { number: "114", range: (5..7), line: 1 },
          { number: "114", range: (10..12), line: 1 },
        ]

        assert_equal expected_result_with_metadata, Day03.extract_numbers_with_metadata(
          line,
          line_idx: 1
        )
      end

      def test_extract_symbols_and_their_metadata
        line = "/.@.*.$.=.&.#.-.+.%.&."
        expected_result_with_metadata = [
          { symbol: '/', index: 0, line: 2 },
          { symbol: '@', index: 2, line: 2 },
          { symbol: '*', index: 4, line: 2 },
          { symbol: '$', index: 6, line: 2 },
          { symbol: '=', index: 8, line: 2 },
          { symbol: '&', index: 10, line: 2 },
          { symbol: '#', index: 12, line: 2 },
          { symbol: '-', index: 14, line: 2 },
          { symbol: '+', index: 16, line: 2 },
          { symbol: '%', index: 18, line: 2 },
          { symbol: '&', index: 20, line: 2 },
        ]

        assert_equal expected_result_with_metadata, Day03.extract_symbols_with_metadata(
          line, line_idx: 2
        )
      end

      def test_symbol_adjacent_to_number_top
        # schematic = %w[
        #  +......
        #  ..467..
        # ]
        assert_equal false, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 0, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .+.....
        #  ..467..
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 1, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  ..+....
        #  ..467..
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 2, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  ...+...
        #  ..467..
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 3, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  ....+..
        #  ..467..
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 4, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .....+.
        #  ..467..
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 5, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )
        
        # schematic = %w[
        #  ......+
        #  ..467..
        # ]
        assert_equal false, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 6, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )
      end

      def test_symbol_adjacent_to_number_bottom
        # schematic = %w[
        #  .......
        #  ..467..
        #  /......
        # ]
        assert_equal false, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '/', index: 0, line: 2 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .......
        #  ..467..
        #  .@.....
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '@', index: 1, line: 2 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .......
        #  ..467..
        #  ..$....
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '$', index: 2, line: 2 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .......
        #  ..467..
        #  ...+...
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 3, line: 2 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .......
        #  ..467..
        #  ....+..
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 4, line: 2 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .......
        #  ..467..
        #  .....+.
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 5, line: 2 },
          number: { number: '467', range: (2..4), line: 1 } 
        )
        
        # schematic = %w[
        #  .......
        #  ..467..
        #  ......+
        # ]
        assert_equal false, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 6, line: 2 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        # 467..114..
        # ...*......
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '*', index: 3, line: 1 },
          number: { number: '467', range: (0..2), line: 0 } 
        )

        # schematic = %w[
        # 467..114..
        # ...*......
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: "*", index: 3, line: 1 },
          number: { number: "467", range: (0..2), line: 0 }
        )

        # schematic = %w[
        # 467...114
        # ....*....
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: "*", index: 4, line: 1 },
          number: { number: "114", range: (5..7), line: 0 }
        )
      end

      def test_symbol_adjacent_to_number_left
        # schematic = %w[
        #  .......
        #  /.46...
        # ]
        assert_equal false, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '/', index: 0, line: 1 },
          number: { number: '46', range: (2..3), line: 1 } 
        )

        # schematic = %w[
        #  .......
        #  ./47...
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '/', index: 1, line: 1 },
          number: { number: '47', range: (2..3), line: 1 } 
        )
      end

      def test_symbol_adjacent_to_number_right
        # schematic = %w[
        #  .......
        #  ..467.+
        # ]
        assert_equal false, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 6, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )

        # schematic = %w[
        #  .......
        #  ..467+.
        # ]
        assert_equal true, Day03.is_symbol_adjacent_to_number?(
          symbol: { symbol: '+', index: 5, line: 0 },
          number: { number: '467', range: (2..4), line: 1 } 
        )
      end
    end

    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_sums_engine_part_numbers
          expected_sum_of_engine_parts = 467 + 35 + 633 + 617 + 592 + 755 + 664 + 598
          result = Part01.get_sum_of_engine_part_numbers(engine_schematic)
          assert_equal expected_sum_of_engine_parts, result
        end

        def engine_schematic
          %w[
            467..114..
            ...*......
            ..35..633.
            ......#...
            617*......
            .....+.58.
            ..592.....
            ......755.
            ...$.*....
            .664.598..
          ]
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_find_gears
          # schematic = %w[
          # 467..114..
          # ...*......
          # ..35..633.
          # ......#...
          # 617*......
          # ]

          gear = { symbol: '*', index: 3, line: 1 }
          symbols = [
            gear,
            { symbol: '#', index: 6, line: 3 },
            { symbol: '*', index: 0, line: 4 }
          ]

          numbers = [
            { number: '467', range: (0..2), line: 0 },
            { number: '114', range: (5..7), line: 0 },
            { number: '35', range: (2..3), line: 2 },
            { number: '633', range: (6..8), line: 2 },
            { number: '617', range: (0..2), line: 4 },
          ]

          found_gears = Part02.find_gears(numbers, symbols)
          assert_equal 1, found_gears.size
          assert_equal gear, found_gears.first[:symbol]
        end

        def test_get_gear_ratio
          gear = {
            symbol: { symbol: '*', index: 3, line: 1 },
            adjacent_numbers: [
            { number: '467', range: (0..2), line: 0 },
            { number: '35', range: (2..3), line: 2 }
            ]
          }

          assert_equal 467 * 35, Part02.get_gear_ratio(gear)
        end

        def test_get_sum_of_gear_ratios
          assert_equal (467 * 35) + (755 * 598), Part02.get_sum_of_gear_ratios(engine_schematic)
        end

        def engine_schematic
          %w[
            467..114..
            ...*......
            ..35..633.
            ......#...
            617*......
            .....+.58.
            ..592.....
            ......755.
            ...$.*....
            .664.598..
          ]
        end
      end
    end
  end
end
