require_relative '../lib/solution'

input = File.read(File.join(__dir__, "../data/input.txt"))

# part_one_result = AoC2023::Day05::Part01.solve(input: input)
part_two_result = AoC2023::Day05::Part02.solve(input: input)

# puts "Part 01: #{part_one_result}"
puts "Part 02: #{part_two_result}"
