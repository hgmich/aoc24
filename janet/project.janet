(declare-project :name "aoc24"
  :dependencies [
    {:url "https://github.com/ianthehenry/judge.git"
     :tag "v2.9.0"}
  ])

(declare-executable
  :name "day01"
  :entry "exercises/day01.janet")

(declare-executable
  :name "day02"
  :entry "exercises/day02.janet")
