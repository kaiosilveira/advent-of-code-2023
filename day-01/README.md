## Day 1: Trebuchet?!

URL: https://adventofcode.com/2023/day/1

Something is wrong with global snow production, and you've been selected to take a look. The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.

You've been doing this long enough to know that to restore snow operations, you need to check all **fifty stars** by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants **one star**. Good luck!

You try to ask why they can't just use a [weather machine](https://adventofcode.com/2015/day/1) ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a [trebuchet](https://en.wikipedia.org/wiki/Trebuchet) ("please hold still, we need to strap you in").

As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been **amended** by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.

## Part I

The newly-improved calibration document consists of lines of text; each line originally contained a specific **calibration value** that the Elves now need to recover. On each line, the calibration value can be found by combining the **first digit** and the **last digit** (in that order) to form a single **two-digit number**.

For example:

```
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
```

In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces **142**.

Consider your entire calibration document. **What is the sum of all of the calibration values?**

<details>
<summary>See solution</summary>

To solve this problem, we first need to identify all digits inside the string, then select only the first and last digits present, and finally, combine the two digits to form the final calibration value.

### Identifying all digits inside the string

Since we're dealing with a string, we can use Ruby's `String#scan` method to filter only for digits (`/\d/`):

```ruby
numbers = value.scan(/\d/)
```

### Selecting only the first and last digits

Since the result of the previous part is an array, we can use Ruby's `Array#first` and `Array#last` to accomplish this task:

```ruby
first, last = numbers.first, numbers.last
```

### Combining the two digits into the final calibration value

Finally, we just need to combine (not add up!) the two digits to form the final calibration value:

```ruby
"#{first}#{last}".to_i
```

The final code for processing one line of the input looks like this:

```ruby
def self.get_calibration_value_from(value)
  numbers = value.scan(/\d/)
  first, last = numbers.first, numbers.last

  "#{first}#{last}".to_i
end
```

The tests used to guide this first part of the implementation were:

```ruby
def test_identifies_digits
  assert_equal 12, Part01.get_calibration_value_from("1abc2")
end

def test_selects_only_first_and_last_digits
  assert_equal 15, Part01.get_calibration_value_from("a1b2c3d4e5f")
end
```

Before moving on, there's an implicit edge case: if we only have one digit in the provided string, we need to duplicate it to always get two digits as a result:

```ruby
def test_duplicates_digit_if_it_is_the_only_digit_present
  assert_equal 77, Part01.get_calibration_value_from("treb7uchet")
end
```

Thankfully, this behavior is already covered by the `.first` and `.last` approach used above.

Now, we just need to process a list of inputs and add up all of its partial calibration values to form the final calibration value. We can accomplish that by mapping over the input using the method defined above and reducing the map at the end:

```ruby
def self.get_combined_calibration_value(input:)
  input.map { |value| get_calibration_value_from(value) }.reduce(:+)
end
```

We can use the sample data provided in the challenge to validate our solution:

```ruby
def test_returns_142_for_sample_input
  assert_equal 142, Part01.get_combined_calibration_value(
    input: ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]
  )
end
```

Finally, putting everything together:

```ruby
input = File.readlines(File.join(__dir__, "../data/input.txt"))
part_one_result = AoC2023::Day01::Part01.get_combined_calibration_value(input: input)
puts "Part 01: #{part_one_result}" # Part 01: 55029
```

</details>

## Part II

Your calculation isn't quite right. It looks like some of the digits are actually **spelled out** with letters: one, two, three, four, five, six, seven, eight, and nine **also** count as valid "digits".

Equipped with this new information, you now need to find the real first and last digit on each line. For example:

```
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
```

In this example, the calibration values are `29`, `83`, `13`, `24`, `42`, `14`, and `76`. Adding these together produces `281`.

**What is the sum of all of the calibration values?**

<details>
<summary>See solution</summary>

Now things get a little tricky: we need to parse number names, such as `one` and `two`, to their respective digits (`1` and `2`), while still being capable of identifying regular digits inside the string. The main idea is to use a lookup table so we can query the number name and get an index back, this index will be its exact digit representation. The mechanic would be:

```ruby
NUMBER_NAMES = %w[zero one two three four five six seven eight nine]

# later in the code...
NUMBER_NAMES.index("one") # -> 1
```

We also need to expand the initial regex so it also identifies written numbers, alongside regular digits:

```ruby
regex = /([1-9])|(one|two|three|four|five|six|seven|eight|nine)/
```

We need to perform some array stunts here to get rid of `nil` values returned from the regex grouping:

```ruby
.flat_map { |i| i }.filter { |i| !i.nil? }
```

and also to parse written number names back to their actual digits:

```ruby
input.map { |i| i.to_i == 0 ? NUMBER_NAMES.index(i) : i }
```

Note that we used a trick here, trying to parse the written number name to an integer will return `0`, and we're leveraging it (plus the fact that there are no zeroes in the challenge strings) to identify written number names. The test that guided the solution so far was:

```ruby
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
```

So far, so good. Except that this solution won't work for the given edge case: `oneight`: the regex will always capture `one` and ignore the rest. It's not a problem if this happens at the beginning, but when it happens in the end, then this behavior will lead to wrong results. To address that, we need to split the string scan into two parts:

- from beginning to end to find the first digit
- from end to beginning to find the last digit

A good test to guide this refactoring is:

```ruby
def test_handle_naming_overlaps
  value = "oneight"
  assert_equal 18, Part02.get_calibration_value_from(value)
end
```

The resulting implementation looks like this:

```ruby
def self.find_first_digit(value)
  regex = /([1-9])|(one|two|three|four|five|six|seven|eight|nine)/
  first_digit = parse_number_names(scan_input_using_regex(value, regex)).first

  first_digit
end

def self.find_last_digit(value)
  regex = /([1-9])|(#{NUMBER_NAMES.map(&:reverse).join('|')})/
  sanitized_matches = scan_input_using_regex(value.reverse, regex).reverse.map(&:reverse)
  last_digit = parse_number_names(sanitized_matches).last

  last_digit
end
```

With the utilities being:

```ruby
def self.scan_input_using_regex(input, regex)
  input.scan(regex).flat_map { |i| i }.filter { |i| !i.nil? }
end

def self.parse_number_names(input)
  input.map { |i| i.to_i == 0 ? NUMBER_NAMES.index(i) : i }
end
```

The final form for the `get_calibration_value_from(value)` method in part two, then, looks beautifully simple:

```ruby
def self.get_calibration_value_from(value)
  first = find_first_digit(value)
  last = find_last_digit(value)

  "#{first}#{last}".to_i
end
```

Executing the input data against the final solution yields:

```ruby
input = File.readlines(File.join(__dir__, "../data/input.txt"))
part_two_result = AoC2023::Day01::Part02.get_combined_calibration_value(input: input)
puts "Part 02: #{part_two_result}" # Part 02: 55686
```

And that's it!

</details>

---

## My questions to Copilot

Solving these challenges using AI wouldn't be that fun, would it?! So, to keep things as clear as possible, here are the questions I made to Copilot during the resolution session:

- How to get the position of a letter in the alphabet using ruby?
- How to read a file in ruby?
- How to get the current directory using the File module in ruby?
- How to get all matches of a regex in ruby?
- How to define two possible subgroups in a regex?
- How to scan a string backward using regexes in ruby?
- How to start scanning a string from end to start using regexes in ruby?
- How to resolve relative path when loading a file in Ruby?
- How to get the written name of a number in ruby?
- How to convert the written name of a number to its digit representation in ruby?
