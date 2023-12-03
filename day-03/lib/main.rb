require_relative '../lib/solution'

engine_schematic = File.readlines(File.join(__dir__, "../data/sample_part_01.txt"))

part_one_result = AoC2023::Day03::Part01.get_sum_of_engine_part_numbers(engine_schematic)
part_two_result = AoC2023::Day03::Part02.get_sum_of_gear_ratios(engine_schematic)

puts "Part 01: #{part_one_result}"
puts "Part 02: #{part_two_result}"
