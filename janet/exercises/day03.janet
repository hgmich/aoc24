(use judge)

(use ../lib/util)

(def input-peg (peg/compile
  ~{:main (some (+ :mul 1))
    :num (between 1 3 :d)
    :mul (/
      (+
        (sequence
          (constant :op)
          (constant :mul)
          "mul("
          (constant :p1)
          (number :num)
          ","
          (constant :p2)
          (number :num)
          ")")
        (sequence "do()" (constant :op) (constant :do))
        (sequence "don't()" (constant :op) (constant :dont)))
      ,table)}))

(test (peg/match input-peg "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
  @[@{:op :mul :p1 2 :p2 4}
    @{:op :dont}
    @{:op :mul :p1 5 :p2 5}
    @{:op :mul :p1 11 :p2 8}
    @{:op :do}
    @{:op :mul :p1 8 :p2 5}])

(defn filter-do [ops]
  (var doing? true)
  (let [muls @[]]
    (each op ops
      (match op
        {:op :mul :p1 p1 :p2 p2} (if doing? (array/push muls [p1 p2]))
        {:op :do} (set doing? true)
        {:op :dont} (set doing? false)))
    muls))

(test (filter-do [{:op :mul :p1 3 :p2 9} {:op :dont} {:op :mul :p1 5 :p2 1} {:op :do} {:op :mul :p1 9 :p2 3}]) @[[3 9] [9 3]])

(defn part1 [input]
  (let [muls (peg/match input-peg input)
        results (map (fn [op] (match op {:op :mul :p1 a :p2 b} (* a b) _ 0)) muls)]
    (print "The answer to part 1 is: " (+ ;results))))

(defn part2 [input]
  (let [ops (peg/match input-peg input)
        muls (filter-do ops)
        results (map (fn [[a b]] (* a b)) muls)]
    (print "The answer to part 2 is: " (+ ;results))))

(defn main [&]
  (def input (string/trim (file/read stdin :all)))
  (part1 input)
  (part2 input))
