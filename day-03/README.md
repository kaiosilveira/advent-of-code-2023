## Day 3: Gear Ratios

URL: https://adventofcode.com/2023/day/3

You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the **water source**, but this is as far as he can bring you. You go inside.

It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

"Aaah!"

You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.

The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can **add up all the part numbers** in the engine schematic, it should be easy to work out which part is missing.

The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently **any number adjacent to a symbol**, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

Here is an example engine schematic:

```
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
```

## Part I

In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is **4361**.

Of course, the actual engine schematic is much larger. **What is the sum of all of the part numbers in the engine schematic?**

<details>
<summary>See solution</summary>

### Extracting numbers
```ruby
def test_extract_numbers_and_their_metadata
  line = "467..114..114"

  expected_result_with_metadata = [
    { number: "467", range: (0..2), line: 1 },
    { number: "114", range: (5..7), line: 1 },
    { number: "114", range: (10..12), line: 1 },
  ]

  assert_equal expected_result_with_metadata, Part01.extract_numbers_with_metadata(
    line,
    line_idx: 1
  )
end
```

```ruby
def test_extract_numbers_and_their_metadata
  line = "467..114..114"

  expected_result_with_metadata = [
    { number: "467", range: (0..2), line: 1 },
    { number: "114", range: (5..7), line: 1 },
    { number: "114", range: (10..12), line: 1 },
  ]

  assert_equal expected_result_with_metadata, Part01.extract_numbers_with_metadata(
    line,
    line_idx: 1
  )
end
```

### Extracting symbols
```ruby
def test_extract_symbols_and_their_metadata
  line = "/.@.*.$.=.&.#.-.+.%.&."
  expected_result_with_metadata = [
    { symbol: '/', index: 0, line: 2 },
    { symbol: '@', index: 2, line: 2 },
    { symbol: '*', index: 4, line: 2 },
    { symbol: '$', index: 6, line: 2 },
    { symbol: '=', index: 8, line: 2 },
    { symbol: '&', index: 10, line: 2 },
    { symbol: '#', index: 12, line: 2 },
    { symbol: '-', index: 14, line: 2 },
    { symbol: '+', index: 16, line: 2 },
    { symbol: '%', index: 18, line: 2 },
    { symbol: '&', index: 20, line: 2 },
  ]

  assert_equal expected_result_with_metadata, Part01.extract_symbols_with_metadata(
    line, line_idx: 2
  )
end
```

```ruby
def self.extract_symbols_with_metadata(line, line_idx:)
  symbol_info = []

  line.scan(/[^.0-9]/) do |symbol|
    idx = Regexp.last_match.offset(0)[0]
    symbol_info << { symbol: symbol, index: idx, line: line_idx }
  end

  symbol_info
end
```

### Checking whether a symbol is adjacent to a number

```ruby
def test_symbol_adjacent_to_number_top
  # schematic = %w[
  #  +......
  #  ..467..
  # ]
  assert_equal false, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 0, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .+.....
  #  ..467..
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 1, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  ..+....
  #  ..467..
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 2, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  ...+...
  #  ..467..
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 3, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  ....+..
  #  ..467..
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 4, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .....+.
  #  ..467..
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 5, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )
  
  # schematic = %w[
  #  ......+
  #  ..467..
  # ]
  assert_equal false, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 6, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )
end

def test_symbol_adjacent_to_number_bottom
  # schematic = %w[
  #  .......
  #  ..467..
  #  /......
  # ]
  assert_equal false, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '/', index: 0, line: 2 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .......
  #  ..467..
  #  .@.....
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '@', index: 1, line: 2 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .......
  #  ..467..
  #  ..$....
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '$', index: 2, line: 2 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .......
  #  ..467..
  #  ...+...
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 3, line: 2 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .......
  #  ..467..
  #  ....+..
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 4, line: 2 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .......
  #  ..467..
  #  .....+.
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 5, line: 2 },
    number: { number: '467', range: (2..4), line: 1 } 
  )
  
  # schematic = %w[
  #  .......
  #  ..467..
  #  ......+
  # ]
  assert_equal false, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 6, line: 2 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  # 467..114..
  # ...*......
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '*', index: 3, line: 1 },
    number: { number: '467', range: (0..2), line: 0 } 
  )

  # schematic = %w[
  # 467..114..
  # ...*......
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: "*", index: 3, line: 1 },
    number: { number: "467", range: (0..2), line: 0 }
  )

  # schematic = %w[
  # 467...114
  # ....*....
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: "*", index: 4, line: 1 },
    number: { number: "114", range: (5..7), line: 0 }
  )
end

def test_symbol_adjacent_to_number_left
  # schematic = %w[
  #  .......
  #  /.46...
  # ]
  assert_equal false, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '/', index: 0, line: 1 },
    number: { number: '46', range: (2..3), line: 1 } 
  )

  # schematic = %w[
  #  .......
  #  ./47...
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '/', index: 1, line: 1 },
    number: { number: '47', range: (2..3), line: 1 } 
  )
end

def test_symbol_adjacent_to_number_right
  # schematic = %w[
  #  .......
  #  ..467.+
  # ]
  assert_equal false, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 6, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )

  # schematic = %w[
  #  .......
  #  ..467+.
  # ]
  assert_equal true, Part01.is_symbol_adjacent_to_number?(
    symbol: { symbol: '+', index: 5, line: 0 },
    number: { number: '467', range: (2..4), line: 1 } 
  )
end
```

```ruby
def self.is_symbol_adjacent_to_number?(symbol:, number:)
  number_start, number_end = number[:range].first, number[:range].last
  number_spread = ([0, number_start - 1].max)..(number_end + 1)
  symbol_spread = (symbol[:line] - 1)..(symbol[:line] + 1)
  number_spread.include?(symbol[:index]) && symbol_spread.include?(number[:line])
end
```

### Checking whether a number is an engine part

```ruby
def self.is_engine_part_number?(number, symbols)
  symbols.any? do |symbol|
    number_start = number[:range].first
    number_end = number[:range].last
    is_symbol_adjacent_to_number?(symbol: symbol, number: number)
  end
end
```

```ruby
def self.get_sum_of_engine_part_numbers(engine_schematic)
  all_symbols = engine_schematic.flat_map.with_index do |line, i|
    extract_symbols_with_metadata(line.strip, line_idx: i)
  end

  all_numbers = engine_schematic.flat_map.with_index do |line, i|
    extract_numbers_with_metadata(line, line_idx: i)
  end

  engine_part_numbers = all_numbers.select do |number|
    is_engine_part_number?(number, all_symbols)
  end

  engine_part_numbers.map { |n| n[:number].to_i }.sum
end
```

### Getting the sum of engine part numbers

```ruby
def test_sums_engine_part_numbers
  expected_sum_of_engine_parts = 467 + 35 + 633 + 617 + 592 + 755 + 664 + 598
  result = Part01.get_sum_of_engine_part_numbers(engine_schematic)
  assert_equal expected_sum_of_engine_parts, result
end

def engine_schematic
  %w[
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  ]
end
```

```ruby
def self.get_sum_of_engine_part_numbers(engine_schematic)
  all_symbols = engine_schematic.flat_map.with_index do |line, i|
    extract_symbols_with_metadata(line.strip, line_idx: i)
  end

  all_numbers = engine_schematic.flat_map.with_index do |line, i|
    extract_numbers_with_metadata(line, line_idx: i)
  end

  engine_part_numbers = all_numbers.select do |number|
    is_engine_part_number?(number, all_symbols)
  end

  engine_part_numbers.map { |n| n[:number].to_i }.sum
end
```

### Final thoughts

- How to handle negatives?
- How to separate isolated symbols from negative number symbols?
- How to find indexes of similar numbers (15, 155) in the same row?

External help:

https://www.reddit.com/r/adventofcode/comments/189q1d2/comment/kbsr3lw/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

</details>

## Part II

The engineer finds the missing part and installs it in the engine! As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.

You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.

Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.

The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to **exactly two part numbers**. Its **gear ratio** is the result of multiplying those two numbers together.

This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.

Consider the same engine schematic again:

```
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
```

In this schematic, there are **two** gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is **not** a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces **467835**.

**What is the sum of all of the gear ratios in your engine schematic?**

<details>
<summary>See solution</summary>

### Finding gears

```ruby
def test_find_gears
  # schematic = %w[
  # 467..114..
  # ...*......
  # ..35..633.
  # ......#...
  # 617*......
  # ]

  gear = { symbol: '*', index: 3, line: 1 }
  symbols = [
    gear,
    { symbol: '#', index: 6, line: 3 },
    { symbol: '*', index: 0, line: 4 }
  ]

  numbers = [
    { number: '467', range: (0..2), line: 0 },
    { number: '114', range: (5..7), line: 0 },
    { number: '35', range: (2..3), line: 2 },
    { number: '633', range: (6..8), line: 2 },
    { number: '617', range: (0..2), line: 4 },
  ]

  found_gears = Part02.find_gears(numbers, symbols)
  assert_equal 1, found_gears.size
  assert_equal gear, found_gears.first[:symbol]
end
```

```ruby
def self.find_gears(numbers, symbols)
  gear_symbols = symbols.select do |s|
    adjacent_numbers = numbers.select do |number|
      Day03::Part01.is_symbol_adjacent_to_number?(symbol: s, number: number)
    end

    s[:symbol] == '*' && adjacent_numbers.size > 1
  end

  gears = gear_symbols.map do |symbol|
    adjacent_numbers = numbers.select do |number|
      Day03::Part01.is_symbol_adjacent_to_number?(symbol: symbol, number: number)
    end

    { symbol: symbol, adjacent_numbers: adjacent_numbers }
  end

  gears
end
```

### Calculating the gear ratio
```ruby
def test_get_gear_ratio
  gear = {
    symbol: { symbol: '*', index: 3, line: 1 },
    adjacent_numbers: [
    { number: '467', range: (0..2), line: 0 },
    { number: '35', range: (2..3), line: 2 }
    ]
  }

  assert_equal 467 * 35, Part02.get_gear_ratio(gear)
end
```

```ruby
def self.get_gear_ratio(gear)
  gear[:adjacent_numbers].map { |n| n[:number].to_i }.reduce(:*)
end
```

### Adding up individual gear ratios

```ruby
def test_get_sum_of_gear_ratios
  assert_equal (467 * 35) + (755 * 598), Part02.get_sum_of_gear_ratios(engine_schematic)
end
```

```ruby
def self.get_sum_of_gear_ratios(engine_schematic)
  all_symbols = engine_schematic.flat_map.with_index do |line, index|
    Day03.extract_symbols_with_metadata(line.strip, line_idx: index)
  end

  all_numbers = engine_schematic.flat_map.with_index do |line, index|
    Day03.extract_numbers_with_metadata(line, line_idx: index)
  end

  gears = find_gears(all_numbers, all_symbols)
  gears.map { |gear| get_gear_ratio(gear) }.sum
end
```

</details>

---

## My questions to Copilot

Solving these challenges using AI wouldn't be that fun, would it?! So, to keep things as clear as possible, here are the questions I made to Copilot during the resolution session:

- How to ignore a certain character using regex?
- How to find all indexes of a character in a string?
- How to filter an array so it contains only unique characters?
- How to create inclusive ranges?
- How to select a character only if it's not followed by a positive or negative number using regex?
- How to combine negatives using regex?
- How to preserve the index position of the item found during a string#scan?
