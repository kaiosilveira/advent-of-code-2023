require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day06
    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_parse_input
          records = [
            { time: 7, distance: 9 },
            { time: 15, distance: 40 },
            { time: 30, distance: 200 },
          ]

          assert_equal records, Part01.parse_input(boat_race_records: input)
        end

        def test_get_possible_acceleration_distributions
          record = { time: 7, distance: 9 }

          assert_equal [
            { acceleration: 1, total_distance: 6 },
            { acceleration: 2, total_distance: 10 },
            { acceleration: 3, total_distance: 12 },
            { acceleration: 4, total_distance: 12 },
            { acceleration: 5, total_distance: 10 },
            { acceleration: 6, total_distance: 6 },
          ], Part01.get_possible_acceleration_distributions_for(record: record)
        end

        def test_get_record_breaking_acceleration_distributions
          target_distance = 9
          distributions = [
            { acceleration: 1, total_distance: 6 },
            { acceleration: 2, total_distance: 10 },
            { acceleration: 3, total_distance: 12 },
            { acceleration: 4, total_distance: 12 },
            { acceleration: 5, total_distance: 10 },
            { acceleration: 6, total_distance: 6 },
          ]

          assert_equal [
            { acceleration: 2, total_distance: 10 },
            { acceleration: 3, total_distance: 12 },
            { acceleration: 4, total_distance: 12 },
            { acceleration: 5, total_distance: 10 },
          ], Part01.get_record_breaking_acceleration_distributions(
            target_distance: target_distance,
            distributions: distributions
          )
        end

        def test_get_product_of_record_breaking_possibilities
          records = [
            { time: 7, distance: 9 },
            { time: 15, distance: 40 },
            { time: 30, distance: 200 },
          ]

          assert_equal 288, Part01.get_product_of_record_breaking_possibilities(records: records)
        end

        def input
          [
            "Time:      7  15   30",
            "Distance:  9  40  200"
          ]
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_parse_input
          expected_result = { time: 71530, distance:  940200 }
          assert_equal expected_result, Part02.parse_input(input: input)
        end

        def test_get_record_breaking_acceleration_distributions
          assert_equal 4, Part02.get_number_of_record_breaking_acceleration_distributions_for(
            record: { time: 7, distance: 9 }
          )

          assert_equal 8, Part02.get_number_of_record_breaking_acceleration_distributions_for(
            record: { time: 15, distance: 40 }
          )

          assert_equal 9, Part02.get_number_of_record_breaking_acceleration_distributions_for(
            record: { time: 30, distance: 200 }
          )

          assert_equal 71503, Part02.get_number_of_record_breaking_acceleration_distributions_for(
            record: { time: 71530, distance: 940200 }
          )
        end

        def input
          [
            "Time:      7  15   30",
            "Distance:  9  40  200"
          ]
        end
      end
    end
  end
end
