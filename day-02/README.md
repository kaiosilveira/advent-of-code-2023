## Day 2: Cube Conundrum

URL: https://adventofcode.com/2023/day/2

You're launched high into the atmosphere! The apex of your trajectory just barely reaches the surface of a large island floating in the sky. You gently land in a fluffy pile of leaves. It's quite cold, but you don't see much snow. An Elf runs over to greet you.

The Elf explains that you've arrived at **Snow Island** and apologizes for the lack of snow. He'll be happy to explain the situation, but it's a bit of a walk, so you have some time. They don't get many visitors up here; would you like to play a game in the meantime?

## Part I

As you walk, the Elf shows you a small bag and some cubes which are either red, green, or blue. Each time you play this game, he will hide a secret number of cubes of each color in the bag, and your goal is to figure out information about the number of cubes.

To get information, once a bag has been loaded with cubes, the Elf will reach into the bag, grab a handful of random cubes, show them to you, and then put them back in the bag. He'll do this a few times per game.

You play several games and record the information from each game (your puzzle input). Each game is listed with its ID number (like the `11` in `Game 11: ...`) followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like `3 red, 5 green, 4 blue`).

For example, the record of a few games might look like this:

```
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
```

In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.

The Elf would first like to know which games would have been possible if the bag contained **only 12 red cubes, 13 green cubes, and 14 blue cubes**?

In the example above, games 1, 2, and 5 would have been **possible** if the bag had been loaded with that configuration. However, game 3 would have been **impossible** because at one point the Elf showed you 20 red cubes at once; similarly, game 4 would also have been **impossible** because the Elf showed you 15 blue cubes at once. If you add up the IDs of the games that would have been possible, you get `8`.

Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. **What is the sum of the IDs of those games?**

<details>
<summary>See solution</summary>

We can divide this problem into two main parts: checking the game feasibility (or whether or not it was possible) and getting the sum of the possible game ids.

### Checking the game feasibility

Using the sample data provided above, we can start with a simple test to guide our implementation:

```ruby
def test_check_game_feasibility
  constraints = { red: 12, green: 13, blue: 14 }
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"

  assert_equal true, Part01.is_game_possible?(game_1, constraints)
end
```

Now, we have some work to do.

First, we need to separate the "game name" (the "Game XYZ" part) from the rounds (everything after the `:`). Then, we need to isolate each round (based on the `;`). Finally, we will need to isolate each color used in the round. Let's do it step-by-step below.

To separate the game name from the rounds and then isolate the rounds, we can use `String#spit`:

```ruby
game_name, round_info = game_info.split(':')
all_rounds = round_info.split(';')
```

Then, to find the cubes used in each round, we need to `.split` the round info using the `,` delimiter (which will give us something like `[" 1 green", " 3 red", " 6 blue"]`). Then, we can `.strip` any extra spaces, and finally, `.split` again to separate the color from the number. As a final step, we can convert the resulting `color, number` pair into a hash, so we will have something like `{ green: 3 }`:

```ruby
cubes_per_round = all_rounds.map do |round|
  numbers_and_colors = round.split(',').map(&:strip).map(&:split)
  numbers_and_colors.map { |number, color| { color.to_sym => number.to_i } }
end
```

Moving on, to have a comprehensive view of what cubes were used in each round, we need to merge the partial hashes created above into a single `{ red: x, green: y, blue: z }` hash, which defaults to zero in case no cube with a given color was used. To _reduce_ the partials, we can do the following:

```ruby
def self.get_total_cubes_used_per_round(round)
  round.reduce({ red: 0, green: 0, blue: 0 }) { |total, hash| total.merge(hash) }
end
```

The code above starts with a hash containing the defaults (`{ red: 0, green: 0, blue: 0 }`), then, it traverses the round data, merging the partials (such as `{ green: 3 }`) back into the default hash.

With that in place, we just need to map over all the partials for each round calling `get_total_cubes_used_per_round`:

```ruby
cubes_per_round.map { |round| get_total_cubes_used_per_round(round) }
```

Now, the stage is set and we can start validating whether or not a round was within the predefined constraints. To do so, for each color, we can compare the number of cubes used in a round to the number of cubes defined as the available:

```ruby
within_constraints = %w[red green blue].map(&:to_sym).map do |color|
  total_cubes_used[color] <= constraints[color]
end
```

Then, we need to check whether the game was possible, by verifying the feasibility of each round:

```ruby
within_constraints.all? { |was_possible| was_possible == true }
```

We can encapsulate the logic above in a method:

```ruby
def self.were_round_within_constraints?(total_cubes_used, constraints)
  within_constraints = %w[red green blue].map(&:to_sym).map do |color|
    total_cubes_used[color] <= constraints[color]
  end

  within_constraints.all? { |was_possible| was_possible == true }
end
```

Finally, to assess whether the game itself was possible, we can simply call the function above and make sure that all rounds were possible:

```ruby
round_feasibility_result.all? { |was_possible| was_possible == true }
```

The final code for this setup is:

```ruby
def self.is_game_possible?(game_info, constraints)
  cubes_used_per_round = get_cubes_used_in_each_game_round(game_info)

  round_feasibility_result = cubes_used_per_round.map do |cubes_used|
    were_round_within_constraints?(cubes_used, constraints)
  end

  round_feasibility_result.all? { |was_possible| was_possible == true }
end
```

At this point, our test should be passing using the computed result, so we can remove the return placeholder and expand the test so it covers the other scenarios provided in the sample data as well:

```ruby
def test_check_game_feasibility
  constraints = { red: 12, green: 13, blue: 14 }
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
  game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
  game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
  game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

  assert_equal true, Part01.is_game_possible?(game_1, constraints)
  assert_equal true, Part01.is_game_possible?(game_2, constraints)
  assert_equal false, Part01.is_game_possible?(game_3, constraints)
  assert_equal false, Part01.is_game_possible?(game_4, constraints)
  assert_equal true, Part01.is_game_possible?(game_5, constraints)
end
```

The test should still pass.

### Getting the sum of possible game ids

The test to guide this step uses the data provided in the sample and expects a `get_sum_of_possible_game_ids` to take a list of games and return the sum of the ids of the possible ones:

```ruby
def test_get_sum_of_possible_game_ids
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
  game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
  game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
  game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

  assert_equal 8, Part01.get_sum_of_possible_game_ids(
    games: [game_1, game_2, game_3, game_4, game_5],
    constraints: { red: 12, green: 13, blue: 14 }
  )
end
```

To solve this part, we can start with a placeholder implementation for `get_sum_of_possible_game_ids`, so the test passes:

```ruby
def self.get_sum_of_possible_game_ids(games:, constraints:)
  8
end
```

Then, using the setup built on the previous step, we can simply check `is_game_possible?` for each game and collect the possible games:

```ruby
games.select { |game_info| is_game_possible?(game_info, constraints) }
```

Then, we can map over the possible games, extracting their ids:

```ruby
possible_game_ids = possible_games.map { |game_info| game_info.split(':').first.split(' ').last.to_i }
```

And finally, we need to sum them all:

```ruby
possible_game_ids.reduce(:+)
```

Merging all of the logic above in one:

```ruby
def self.get_sum_of_possible_game_ids(games:, constraints:)
  games
    .select { |game_info| is_game_possible?(game_info, constraints) }
    .map { |game_info| game_info.split(':').first.split(' ').last.to_i }
    .reduce(:+)
end
```

At this point, we should be able to remove the return placeholder and our test should be still passing.

To get the result we need, we just need to feed this code with the input provided in the challenge:

```ruby
part_one_result = AoC2023::Day02::Part01.get_sum_of_possible_game_ids(
  games: input,
  constraints: { red: 12, green: 13, blue: 14 }
)

puts "Part 01: #{part_one_result}"
```

Which, in my case, yields `Part 01: 3099`.

</details>

## Part II

The Elf says they've stopped producing snow because they aren't getting any **water**! He isn't sure why the water stopped; however, he can show you how to get to the water source to check it out for yourself. It's just up ahead!

As you continue your walk, the Elf poses a second question: in each game you played, what is the **fewest number of cubes** of each color that could have been in the bag to make the game possible?

Again consider the example games from earlier:

```
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
```

- In game 1, the game could have been played with as few as 4 red, 2 green, and 6 blue cubes. If any color had even one fewer cube, the game would have been impossible.
- Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue cubes.
- Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
- Game 4 required at least 14 red, 3 green, and 15 blue cubes.
- Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.

The **power** of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together. The power of the minimum set of cubes in game 1 is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up these five powers produces the sum **2286**.

For each game, find the minimum set of cubes that must have been present. **What is the sum of the power of these sets?**

<details>
<summary>See solution</summary>

This solution can be divided into three parts: finding the minimum number of cubes required for a game to be possible, calculating the **power** of the minimum cube set found, and adding up these powers to form the final answer.

### Finding the minimum number of cubes required

The test to guide this part uses data provided in the sample and asserts that the minimum requirements returned by `get_minimum_number_of_cubes_required` matches the expected result:

```ruby
def test_get_minimum_number_of_cubes_required
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  game_1_expected_result = { red: 4, green: 2, blue: 6 }

  assert_equal game_1_expected_result, Part02.get_minimum_number_of_cubes_required(game_1)
end
```

We can implement a placeholder for `get_minimum_number_of_cubes_required`, so our test passes:

```ruby
def get_minimum_number_of_cubes_required(game_info)
  { red: 4, green: 2, blue: 6 }
end
```

And then we can begin our work.

The minimum number of cubes required will be the maximum number of cubes of a given color used in a single round. As we already know how to `get_cubes_used_in_each_game_round`, we just need to get this data and loop over it, keeping the max number for each color:

```ruby
def self.get_minimum_number_of_cubes_required(game_info)
  minimum_cube_requirements = { red: 0, green: 0, blue: 0 }

  cubes_used_per_round = Day02.get_cubes_used_in_each_game_round(game_info)
  cubes_used_per_round.map do |cubes_used|
    cubes_used.map do |color, count|
      minimum_cube_requirements[color] = [count, minimum_cube_requirements[color]].max
    end
  end

  minimum_cube_requirements
end
```

At this point, we can remove our placeholder and our test should still be passing, so we can expand it to add the other scenarios:

```ruby
def test_get_minimum_number_of_cubes_required
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  game_1_expected_result = { red: 4, green: 2, blue: 6 }

  game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
  game_2_expected_result = { red: 1, green: 3, blue: 4 }

  game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
  game_3_expected_result = { red: 20, green: 13, blue: 6 }

  game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
  game_4_expected_result = { red: 14, green: 3, blue: 15 }

  game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  game_5_expected_result = { red: 6, green: 3, blue: 2 }

  assert_equal game_1_expected_result, Part02.get_minimum_number_of_cubes_required(game_1)
  assert_equal game_2_expected_result, Part02.get_minimum_number_of_cubes_required(game_2)
  assert_equal game_3_expected_result, Part02.get_minimum_number_of_cubes_required(game_3)
  assert_equal game_4_expected_result, Part02.get_minimum_number_of_cubes_required(game_4)
  assert_equal game_5_expected_result, Part02.get_minimum_number_of_cubes_required(game_5)
end
```

### Calculating the power of the "minimum cube set"

The test for this part uses the expected result derived from the sample data and defines a `get_minimum_game_cube_set_power` method:

```ruby
def test_get_minimum_game_cube_set_power
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  assert_equal 48, Part02.get_minimum_game_cube_set_power(game_1)
end
```

The implementation is straightforward. We can find the minimum cube requirements (implemented in the step below):

```ruby
minimum_cube_requirements = get_minimum_number_of_cubes_required(game_info)
```

And then multiply the number of cubes for each color:

```ruby
%w[red green blue].map { |color| minimum_cube_requirements[color.to_sym] }.reduce(:*)
```

The final method looks like this:

```ruby
def self.get_minimum_game_cube_set_power(game_info)
  minimum_cube_requirements = get_minimum_number_of_cubes_required(game_info)
  %w[red green blue].map { |color| minimum_cube_requirements[color.to_sym] }.reduce(:*)
end
```

With our test passing, we can expand it to consider the other games:

```ruby
def test_get_minimum_game_cube_set_power
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
  game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
  game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
  game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

  assert_equal 48, Part02.get_minimum_game_cube_set_power(game_1)
  assert_equal 12, Part02.get_minimum_game_cube_set_power(game_2)
  assert_equal 1560, Part02.get_minimum_game_cube_set_power(game_3)
  assert_equal 630, Part02.get_minimum_game_cube_set_power(game_4)
  assert_equal 36, Part02.get_minimum_game_cube_set_power(game_5)
end
```

### Adding up the powers

Finally, we can add a test to verify that all partial game powers are added up at `get_sum_of_minimum_game_cube_set_powers`:

```ruby
def test_get_sum_of_minimum_game_cube_set_powers
  game_1 = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  game_2 = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
  game_3 = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
  game_4 = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
  game_5 = "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

  assert_equal 48 + 12 + 1560 + 630 + 36, Part02.get_sum_of_minimum_game_cube_set_powers(
    games: [game_1, game_2, game_3, game_4, game_5]
  )
end
```

Which looks like this:

```ruby
def self.get_sum_of_minimum_game_cube_set_powers(games:)
  games
    .map { |game_info| get_minimum_game_cube_set_power(game_info) }
    .reduce(:+)
end
```

Putting everything together:

```ruby
input = File.readlines(File.join(__dir__, "../data/input.txt"))

part_two_result = AoC2023::Day02::Part02.get_sum_of_minimum_game_cube_set_powers(games: input)
puts "Part 02: #{part_two_result}"
```

Which yields `Part 02: 72970`. And that's it for day 2!

</details>

---

## My questions to Copilot

Solving these challenges using AI wouldn't be that fun, would it?! So, to keep things as clear as possible, here are the questions I made to Copilot during the resolution session:

- How to access a method in the parent module in ruby?
- How to initialize a hash with default values in ruby when using array#to_h?
- How to initialize a hash with a dynamic key and a value in ruby?
