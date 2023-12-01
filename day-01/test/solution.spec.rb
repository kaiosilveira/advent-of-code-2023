require 'test/unit'
require_relative '../lib/solution'

module AoC2023
  module Day01
    module Part01
      class Part01Test < Test::Unit::TestCase
        def test_identifies_digits
          assert_equal 12, Part01.get_calibration_value_from("1abc2")
        end
  
        def test_selects_only_first_and_last_digits
          assert_equal 15, Part01.get_calibration_value_from("a1b2c3d4e5f")
        end
  
        def test_duplicates_digit_if_it_is_the_only_digit_present
          assert_equal 77, Part01.get_calibration_value_from("treb7uchet")
        end
  
        def test_returns_142_for_sample_input
          assert_equal 142, Part01.get_combined_calibration_value(
            input: ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]
          )
        end
      end
    end

    module Part02
      class Part02Test < Test::Unit::TestCase
        def test_parses_number_names_to_digits
          assert_equal 11, Part02.get_calibration_value_from("1one")
          assert_equal 11, Part02.get_calibration_value_from("one1")

          assert_equal 22, Part02.get_calibration_value_from("2two")
          assert_equal 22, Part02.get_calibration_value_from("two2")

          assert_equal 33, Part02.get_calibration_value_from("3three")
          assert_equal 33, Part02.get_calibration_value_from("three3")

          assert_equal 44, Part02.get_calibration_value_from("4four")
          assert_equal 44, Part02.get_calibration_value_from("four4")

          assert_equal 55, Part02.get_calibration_value_from("5five")
          assert_equal 55, Part02.get_calibration_value_from("five5")

          assert_equal 66, Part02.get_calibration_value_from("6six")
          assert_equal 66, Part02.get_calibration_value_from("six6")

          assert_equal 77, Part02.get_calibration_value_from("7seven")
          assert_equal 77, Part02.get_calibration_value_from("seven7")

          assert_equal 88, Part02.get_calibration_value_from("8eight")
          assert_equal 88, Part02.get_calibration_value_from("eight8")

          assert_equal 99, Part02.get_calibration_value_from("9nine")
          assert_equal 99, Part02.get_calibration_value_from("nine9")
        end

        def test_handle_naming_overlaps
          value = "oneight"
          assert_equal 18, Part02.get_calibration_value_from(value)
        end

        def test_returns_281_for_sample_input
          assert_equal 281, Part02.get_combined_calibration_value(
            input: [
              "two1nine",
              "eightwothree",
              "abcone2threexyz",
              "xtwone3four",
              "4nineeightseven2",
              "zoneight234",
              "7pqrstsixteen",
            ]
          )
        end
      end
    end
  end
end
