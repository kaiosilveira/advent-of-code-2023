require_relative '../lib/solution'

input_part_01 = File.read(File.join(__dir__, "../data/sample_part_01.txt"))
input_part_02 = File.read(File.join(__dir__, "../data/input.txt"))

part_one_result = AoC2023::Day08::Part01.new.solve(input: input_part_01)
part_two_result = AoC2023::Day08::Part02.new.solve(input: input_part_02)

puts "Part 01: #{part_one_result}"
puts "Part 02: #{part_two_result}"
