require_relative '../lib/solution'

input = File.readlines(File.join(__dir__, "../data/input.txt"))

part_two_result = AoC2023::Day02::Part02.get_sum_of_minimum_game_cube_set_powers(games: input)
part_one_result = AoC2023::Day02::Part01.get_sum_of_possible_game_ids(
  games: input,
  constraints: { red: 12, green: 13, blue: 14 }
)

puts "Part 01: #{part_one_result}"
puts "Part 02: #{part_two_result}"
