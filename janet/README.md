# AOC 2024: Janet Solutions

Solutions will be published the following day.

## Setup

Use [devenv](https://devenv.sh) to quickly set up a development environment
for this project.

### Running solution tests

#### Quickyl

Run `just test` to trigger the judge testrunner.

```console
$ just test
judge
# exercises/day01.janet

3 passed
```

#### In a clean environment

Run `devenv test` or `just test-isolated`. Devenv's builtin testing support
will set up a clean environment from scratch to run the tests.

### Running the exercises

Use `just sample EX` to run an exercise against the question's sample input.

```console
$ just sample day01
jpm -l janet "exercises/day01.janet" < "inputs/day01_sample"
The answer to part 1 is: 11
The answer to part 2 is: 31
```

Use `just solution EX` to run an exercise against the question's real input.

**NOTE:** Input data are individualised. The data in this repo will not solve
your question!

```console
$ just solution day01
jpm -l janet "exercises/day01.janet" < "inputs/day01_solution"
The answer to part 1 is: <your answer>
The answer to part 2 is: <your answer>
```

## Miscellaneous

### Generating test snapshots

The solutions here use `judge`, a snapshot testing framework.
To generate snapshots for tests without test cases, run

```console
$ just snapshot
```

### REPL

You can obtain a REPL with all of the module declarations in scope with `just repl EX`.
Example:

```console
$ just repl day01
jpm -l janet -l "./exercises/day01"
Janet 1.33.0-release macos/aarch64/clang - '(doc)' for help
repl:1:>
```

