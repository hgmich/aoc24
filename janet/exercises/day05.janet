(use judge)

(use ../lib/util)

(def ordering-peg (peg/compile
  ~{:main (any :lines)
    :lines (some (/ :line ,tuple))
    :line (sequence
      (some
        (sequence
          (number (some :d))
          "|"
          (number (some :d))))
      (choice "\n" (any -1)))}))

(def pages-peg (peg/compile
  ~{:main (any :lines)
    :lines (some (/ :line ,tuple))
    :line (sequence
      (some
        (sequence
          (number (some :d))
          (opt ",")))
      (choice "\n" (any -1)))}))

(defn page-ords [orderings pages]
  (let [ord-set-tbl @{}
        pages-set-tbl (table-set pages)]
    (each ord orderings
      (if (every? (map pages-set-tbl ord)) (set (ord-set-tbl ord) true)))
    (keys ord-set-tbl)))

(test
  (page-ords
    @[[47 53] [97 13] [97 61] [97 47] [75 29] [61 13] [75 53] [29 13] [97 29] [53 29] [61 53] [97 53] [61 29] [47 13] [75 47] [97 75] [47 61] [75 61] [47 29] [75 13] [53 13]]
    [75 47 61 53 29])
  @[[53 29]
    [75 47]
    [75 29]
    [47 29]
    [61 29]
    [75 53]
    [47 53]
    [75 61]
    [61 53]
    [47 61]])

(test
  (page-ords
    @[[47 53] [97 13] [97 61] [97 47] [75 29] [61 13] [75 53] [29 13] [97 29] [53 29] [61 53] [97 53] [61 29] [47 13] [75 47] [97 75] [47 61] [75 61] [47 29] [75 13] [53 13]]
    [75 97 47 61 53])
  @[[97 61]
    [75 47]
    [97 47]
    [97 75]
    [75 53]
    [97 53]
    [47 53]
    [75 61]
    [61 53]
    [47 61]])

(defn is-ordered? [orderings pages]
  (let [in-order? (fn [[lt gt]] (< (index-of lt pages) (index-of gt pages)))]
    (every? (map in-order? orderings))))

(test (is-ordered? @[[53 29] [75 47] [75 29] [47 29] [61 29] [75 53] [47 53] [75 61] [61 53] [47 61]] [75 47 61 53 29]) true)
(test (is-ordered? @[[97 61] [75 47] [97 47] [97 75] [75 53] [97 53] [47 53] [75 61] [61 53] [47 61]] [75 97 47 61 53]) false)

(defn middle-number [l]
  (l (math/floor (/ (length l) 2))))

(test (middle-number [1 2 3]) 2)
(test (middle-number [1]) 1)
(test (middle-number [1 2 3 4 5 6 7 8 9]) 5)

(defn get-middle-ordered-page-fn [orderings]
  (fn [pages]
    (let [our-ords (page-ords orderings pages)]
      (if (is-ordered? our-ords pages) (middle-number pages) nil))))

(defn total-ordering [orderings]
  (let [ords @{}]
    (each [lhs rhs] orderings
      (if (not (ords lhs)) (set (ords lhs) 0))
      (set (ords rhs) (if (ords rhs) (+ (ords rhs) 1) 1)))
    (sort-by ords (keys ords))))

(test (total-ordering @[[97 61] [75 47] [97 47] [97 75] [75 53] [97 53] [47 53] [75 61] [61 53] [47 61]]) @[97 75 47 61 53])

(defn middle-ordered-pages [orderings pages-list]
  (filter truthy? (map (get-middle-ordered-page-fn orderings) pages-list)))

# Assuming the solution input is totally ordered, the total ordering of the filtered orderings
# is identical to the correctly sorted list.
(defn get-middle-unordered-page-fn [orderings]
  (fn [pages]
    (let [our-ords (page-ords orderings pages)]
      (if (not (is-ordered? our-ords pages)) (middle-number (total-ordering our-ords)) nil))))

(defn middle-unordered-pages [orderings pages-list]
  (filter truthy? (map (get-middle-unordered-page-fn orderings) pages-list)))

(test (middle-ordered-pages @[[53 29] [75 47] [75 29] [47 29] [61 29] [75 53] [47 53] [75 61] [61 53] [47 61]] [[75 47 61 53 29]]) @[61])
(test (middle-unordered-pages @[[97 61] [75 47] [97 47] [97 75] [75 53] [97 53] [47 53] [75 61] [61 53] [47 61]] [[75 97 47 61 53]]) @[47])

(defn part1 [input]
  (let [[orderings pages-list] (string/split "\n\n" input)
        orderings (peg/match ordering-peg orderings)
        pages-list (peg/match pages-peg pages-list)]
    (print "The answer to part 1 is: " (+ ;(middle-ordered-pages orderings pages-list)))))

(defn part2 [input]
  (let [[orderings pages-list] (string/split "\n\n" input)
        orderings (peg/match ordering-peg orderings)
        pages-list (peg/match pages-peg pages-list)]
    (print "The answer to part 2 is: " (+ ;(middle-unordered-pages orderings pages-list)))))

(defn main [&]
  (def input (string/trim (file/read stdin :all)))
  (part1 input)
  (part2 input))
