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
      (some
        (sequence
          (number (some :d))
          (opt (any (+ " " "\t")))))
      (choice "\n" (any -1)))}))

(test (peg/match input-peg "1 2 3\n4 5\n6 7 8 9 0\n") @[[1 2 3] [4 5] [6 7 8 9 0]])
(test (peg/match input-peg "1 2 3\n4 5\n6 7 8 9 0") @[[1 2 3] [4 5] [6 7 8 9 0]])

(defn level-dist [xs]
  (map (fn [[x y]] (- y x)) (zip (slice xs 0 (- (length xs) 1)) (slice xs 1 (length xs)))))

(test (level-dist [7 6 4 2 1]) @[-1 -2 -2 -1])

(defn is-safe? [seq]
  (let [dist-seq (level-dist seq)]
    (and
      (every? (map (fn [x]
        (let [x (math/abs x)]
          (and (<= 1 x) (>= 3 x))))
        dist-seq))
      (= ;(map (fn [n] (if (< n 0) :neg :pos)) dist-seq)))))

(test (is-safe? [7 6 4 2 1]) true)
(test (is-safe? [1 2 7 8 9]) false)

(defn part1 [input]
  (print "The answer to part 1 is: " (+ ;(map (fn [line] (if (is-safe? line) 1 0)) (peg/match input-peg input)))))

# Contrived, but perm1 takes a tuple/array and returns every permutation
# with 1 element removed.
# e.g [1 2 3] -> @[@[2 3] @[1 3] @[1 2]]
(defn perm1 [ind]
  (let [out @[]]
    (loop [n :range [0 (length ind)]
          :let [perm @[]]]
      (array/concat perm (slice ind 0 n))
      (array/concat perm (slice ind (+ 1 n) -1))
      (array/push out perm))
    out))

(test (perm1 [1 2 3])  @[@[2 3] @[1 3] @[1 2]])

(defn nearly-safe? [line]
  (any? (map is-safe? (perm1 line))))

(test (nearly-safe? [1 2 7 8 9]) false)
(test (nearly-safe? [1 3 2 4 5]) true)

(defn part2 [input]
  (print "The answer to part 2 is: " (+ ;(map (fn [line] (if (nearly-safe? line) 1 0)) (peg/match input-peg input)))))

(defn main [&]
  (def input (string/trim (file/read stdin :all)))
  (part1 input)
  (part2 input))
