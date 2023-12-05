require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day05

    def self.input
      %[
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
      ]
    end

    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_parse_seeds
          raw_seeds = ["seeds: 79 14 55 13"]
          assert_equal [79, 14, 55, 13], Part01.parse_seeds(raw_seeds)
        end

        def test_parse_input
          result = Part01.parse_input(Day05.input)

          seeds = [79, 14, 55, 13]
          assert_equal seeds, result[:seeds]

          seed_to_soil = [[(50..51), (98..99)], [(52..99), (50..97)]]
          assert_equal seed_to_soil, result[:seed_to_soil]
          
          soil_to_fertilizer = [
            [
              (0..36), (15..51)],
              [(37..38), (52..53)],
              [(39..53), (0..14)]
          ]
          assert_equal soil_to_fertilizer, result[:soil_to_fertilizer]

          fertilizer_to_water = [
            [(49..56), (53..60)],
            [(0..41), (11..52)],
            [(42..48), (0..6)],
            [(57..60), (7..10)]
          ]
          assert_equal fertilizer_to_water, result[:fertilizer_to_water]

          water_to_light = [
            [(88..94), (18..24)],
            [(18..87), (25..94)]
          ]
          assert_equal water_to_light, result[:water_to_light]

          light_to_temperature = [
            [(45..67), (77..99)],
            [(81..99), (45..63)],
            [(68..80), (64..76)]
          ]
          assert_equal light_to_temperature, result[:light_to_temperature]

          temperature_to_humidity = [
            [(0..0), (69..69)],
            [(1..69), (0..68)]
          ]          
          assert_equal temperature_to_humidity, result[:temperature_to_humidity]

          humidity_to_location = [
            [(60..96), (56..92)],
            [(56..59), (93..96)]
          ]
          assert_equal humidity_to_location, result[:humidity_to_location]
        end

        def test_finds_minimum_location
          assert_equal 35, Part01.solve(input: Day05.input)
        end

        def test_parse_dest_src_map
          map = [
            "seed-to-soil map:",
            "50 98 2",
            "52 50 48"
          ]
  
          expected_output = [[(50..51), (98..99)], [(52..99), (50..97)]]
          assert_equal expected_output, Part01.parse_dest_src_map(map)
        end
  
        def test_find_location_for_seed
          mappings = Day05::Part01.parse_input(Day05.input)
  
          assert_equal 82, Part01.find_location_for_seed(mappings, seed: 79)
          assert_equal 43, Part01.find_location_for_seed(mappings, seed: 14)
          assert_equal 86, Part01.find_location_for_seed(mappings, seed: 55)
          assert_equal 35, Part01.find_location_for_seed(mappings, seed: 13)
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_parse_seeds
          raw_seeds = ["seeds: 79 14 55 13"]
          assert_equal [(79..92), (55..67)], Part02.parse_seeds(raw_seeds)
        end

        def test_finds_minimum_location
          assert_equal 46, Part02.solve(input: Day05.input)
        end

        def test_parse_dest_src_map
          map = [
            "seed-to-soil map:",
            "50 10 2",
            "52 50 3"
          ]
  
          valid_range = [10..12, 15..20]
          expected_output = [
            { dest: [50, 51], src: [10, 11] },
            { dest:[52, 54], src: [50, 52] }
          ]
          assert_equal expected_output, Part02.parse_dest_src_map(map)
        end

        def test_find_dest_or_identity
          assert_equal 1, Part02.find_dest_or_identity([{ dest: [1, 2], src: [3, 4] }], token: 3)
          assert_equal 1, Part02.find_dest_or_identity([{ dest: [1, 2], src: [3, 4] }], token: 1)
        end

        def test_find_src_or_identity
          assert_equal 3, Part02.find_src_or_identity([{ dest: [1, 2], src: [3, 4] }], token: 1)
          assert_equal 7, Part02.find_src_or_identity([{ dest: [1, 2], src: [3, 4] }], token: 7)
        end

        def test_find_seed_for_location
          mappings = Part02.parse_input(Day05.input)

          assert_equal 79, Part02.find_seed_for_location(mappings, location: 82)
          assert_equal 14, Part02.find_seed_for_location(mappings, location: 43)
          assert_equal 55, Part02.find_seed_for_location(mappings, location: 86)
          assert_equal 13, Part02.find_seed_for_location(mappings, location: 35)
        end
      end
    end
  end
end
