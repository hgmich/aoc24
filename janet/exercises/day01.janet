(use judge)

(defn unzip2 [ps]
  (let [xs @[] ys @[]]
    (each [x y] ps (do
      (array/push xs x)
      (array/push ys y)))
    [xs ys]))

(defn zip [l1 l2]
  (map tuple l1 l2))

(def input-peg (peg/compile
  ~{:main (any :lines)
    :lines (some (/ :line ,tuple))
    :line (sequence
      (number (some :d))
      (some (any (+ " " "\t")))
      (number (some :d))
      (choice "\n" (any -1)))}))

(test (peg/match input-peg "123  456\n456 789\n") @[[123 456] [456 789]])

(defn sum-dist [l1 l2]
  (let [dists (map (fn [[x y]] (math/abs (- x y))) (zip l1 l2))]
    (+ ;dists)))

(test (sum-dist @[1 2 3 3 3 4] @[3 3 3 4 5 9]) 11)

(defn similarity-score [n l]
  (* n (count (fn [x] (= n x)) l)))

(defn sum-similarity [l1 l2]
  (reduce (fn [acc el] (+ (similarity-score el l2) acc)) 0 l1))

(test (sum-similarity @[1 2 3 3 3 4] @[3 3 3 4 5 9]) 31)

(defn part1 [input]
  (def [l1 l2] (unzip2 (peg/match input-peg input)))
  (sort l1)
  (sort l2)
  (print "The answer to part 1 is: " (sum-dist l1 l2)))

(defn part2 [input]
  (def [l1 l2] (unzip2 (peg/match input-peg input)))
  (print "The answer to part 2 is: " (sum-similarity l1 l2)))

(defn main [&]
  (def input (string/trim (file/read stdin :all)))
  (part1 input)
  (part2 input))
