# Advent of Code 2023

This repo contains code solutions for the Advent of Code challenges (2023), with detailed challenge descriptions and step-by-step solution details, including code snippets and tests.

## Programming language choice

To focus on speed and simplicity, Ruby was chosen as the primary programming language for these challenges, its API completeness and fast setup are characteristics that always appeal to me in these situations.

## Repository structure

This monorepo is structured to hold all the code for all days of the advent of code. Each directory that starts with `day`-` contains all the details about the challenge for that day and also all the code implemented to solve it. The file tree looks like this:

```
├── README.md
└── day-01
    ├── README.md
    ├── data
    │   ├── input.txt
    │   ├── sample_part_01.txt
    │   └── sample_part_02.txt
    ├── lib
    │   ├── main.rb
    │   └── solution.rb
    └── test
        └── solution.spec.rb
.
. ... day 02 to day n-1
.
└── day-n
    ├── README.md
    ├── data
    │   ├── input.txt
    │   ├── sample_part_01.txt
    │   └── sample_part_02.txt
    ├── lib
    │   ├── main.rb
    │   └── solution.rb
    └── test
        └── solution.spec.rb
```

Each `day-n` project looks similar, containing:

- a `README.md` with the challenge URL, description, and the solution details
- a `sample.txt` file, containing the sample provided in the challenge
- a `input.txt` file, containing the actual input provided by the challenge
- a `src/index.(spec.)rb` file, containing the actual implementation and tests
- a `src/main.rb` file, containing the code that loads the input data, parses it and calls the implementation

## Solutions

The table below contains references to all days, including the completion status for parts I and II.

| day | title | implementation | part I | part II |
| --- | ----- | -------------- | ------ | ------- |
| #1  | TBD   | Coming soon    | -      | -       |

- ✅ = **solved and documented**
- 🚧 = **solved, but without documentation**
- ❌ = **Not solved yet**
