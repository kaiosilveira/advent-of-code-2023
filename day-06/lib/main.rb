require_relative '../lib/solution'

# input = File.readlines(File.join(__dir__, "../data/sample_part_01.txt"))
input = File.readlines(File.join(__dir__, "../data/input.txt"))

# part_one_result = AoC2023::DayN::Part01.solve(input: input)
part_two_result = AoC2023::DayN::Part02.solve(input: input)

# puts "Part 01: #{part_one_result}"
puts "Part 02: #{part_two_result}"
