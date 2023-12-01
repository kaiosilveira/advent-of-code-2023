require_relative '../lib/solution'

input = File.readlines(File.join(__dir__, "../data/input.txt"))

part_one_result = AoC2023::Day01::Part01.get_combined_calibration_value(input: input)
part_two_result = AoC2023::Day01::Part02.get_combined_calibration_value(input: input)

puts "Part 01: #{part_one_result}" # Part 01: 55029
puts "Part 02: #{part_two_result}" # Part 02: 55686
