require_relative '../lib/solution'

input = File.readlines(File.join(__dir__, "../data/input.txt"))

# part_one_result = AoC2023::Day04::Part01.solve(scratchcards: input)
part_two_result = AoC2023::Day04::Part02.solve(scratchcards: input)

# puts "Part 01: #{part_one_result}"
puts "Part 02: #{part_two_result}"
