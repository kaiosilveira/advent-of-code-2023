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
- a `/data` directory, containing the samples provided for parts one and two and the final input for the challenge
- a `lib/solution.(spec.)rb` file, containing the actual implementation and tests
- a `lib/main.rb` file, containing the code that loads the input data, parses it and calls the implementation

## Templating and automations

To speed things up, a template was created with the base structure for each day, containing the common structure mentioned above.

A Rake script was created to copy the files from the template and kick-off a new day. The execution looks like this: `rake "create_day[02]"`, and the output is something like:

```console
➜ rake "create_day[02]"
Creating day-02...
Copying files from template dir into day-02...
Copying /data...
Copying /lib...
Copying /test...
Copying /README.md...
All set ✅
Happy hacking! 🚀
```

## Solutions

The table below contains references to all days, including the completion status for parts I and II.

| day | title          | implementation    | part I | part II |
| --- | -------------- | ----------------- | ------ | ------- |
| #1  | Trebuchet?!    | [here](./day-01/) | ✅     | ✅      |
| #1  | Cube Conundrum | [here](./day-02/) | ✅     | ✅      |
| #1  | Gear Ratios    | [here](./day-03/) | 🚧     | 🚧      |

- ✅ = **solved + documented**
- 🚧 = **solved, missing documentation**
- ❌ = **Not solved yet**
