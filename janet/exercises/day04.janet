(use judge)

(use ../lib/util)

(defn lines [s] (string/split "\n" s))

(test (lines "abc\ndef") @["abc" "def"])
(test (lines "abc\ndef\n") @["abc" "def" ""])
(test (lines "\nabc\ndef\n") @["" "abc" "def" ""])
(test (lines "\nabc\n\ndef\n") @["" "abc" "" "def" ""])
(test (lines "\n\n") @["" "" ""])
(test (lines "") @[""])

(defn chars [s] (peg/match ~(any (<- 1)) s))

(defn columns [ls] (string-zip ;ls))

(test (columns (lines "abc\ndef")) @["ad" "be" "cf"])

(defn grid-nxn [n ls x y]
  (map
    (fn [s] (slice s x (+ x n)))
    (slice ls y (+ y n))))

(test (grid-nxn 4 (lines "abcde\nfghij\nklmno\npqrst\nuvwxy") 0 0) @["abcd" "fghi" "klmn" "pqrs"])
(test (grid-nxn 4 (lines "abcde\nfghij\nklmno\npqrst\nuvwxy") 0 1) @["fghi" "klmn" "pqrs" "uvwx"])
(test (grid-nxn 4 (lines "abcde\nfghij\nklmno\npqrst\nuvwxy") 1 0) @["bcde" "ghij" "lmno" "qrst"])
(test (grid-nxn 4 (lines "abcde\nfghij\nklmno\npqrst\nuvwxy") 1 1) @["ghij" "lmno" "qrst" "vwxy"])

(defn is-xmas? [s] (or (= s "XMAS") (= s "SAMX")))

(defn count-xmas-diag-4x4 [g4x4]
  (let [diag-ltr (string/from-bytes ((g4x4 0) 0) ((g4x4 1) 1) ((g4x4 2) 2) ((g4x4 3) 3))
        diag-rtl (string/from-bytes ((g4x4 0) 3) ((g4x4 1) 2) ((g4x4 2) 1) ((g4x4 3) 0))]
    (+
      (if (is-xmas? diag-ltr) 1 0)
      (if (is-xmas? diag-rtl) 1 0))))

# The idea here is that XMAS/SAMX cannot be spelled in more than 1
# 4x4 region within the text.
(defn count-xmas-diag [ls]
  (var out 0)
  (let [h (length ls)
        w (length (ls 0))]
    (loop [x :range [0 (- w 3)]
           y :range [0 ( - h 3)]
           :let [g4x4 (grid-nxn 4 ls x y)
                 xmas-diag-count (count-xmas-diag-4x4 g4x4)]]
      (set out (+ out xmas-diag-count)))
    out))

(test (count-xmas-diag (lines "..X...\n.SAMX.\n.A..A.\nXMAS.S\n.X....")) 1)

(def xmas-peg (peg/compile
  ~(some
    (+
      (sequence
        "XMAS"
        (constant 1)) 1))))

(def samx-peg (peg/compile
  ~(some
    (+
      (sequence
        "SAMX"
        (constant 1)) 1))))

(defn count-xmas-line [l]
  (+ ;(peg/match xmas-peg l) ;(peg/match samx-peg l)))

(defn count-xmas-hrz [ls]
  (+ ;(map count-xmas-line ls)))

(defn count-xmas [ls]
  (+
    (count-xmas-diag ls)
    (count-xmas-hrz ls)
    (count-xmas-hrz (columns ls))))

(test (count-xmas (lines "..X...\n.SAMX.\n.A..A.\nXMAS.S\n.X....")) 4)

(defn is-mas? [s] (or (= s "MAS") (= s "SAM")))

(defn count-mas-x-3x3 [g3x3]
  (let [diag-ltr (string/from-bytes ((g3x3 0) 0) ((g3x3 1) 1) ((g3x3 2) 2))
        diag-rtl (string/from-bytes ((g3x3 0) 2) ((g3x3 1) 1) ((g3x3 2) 0))]
    (*
      (if (is-mas? diag-ltr) 1 0)
      (if (is-mas? diag-rtl) 1 0))))

(test (count-mas-x-3x3 (lines "M.M\n.A.\nS.S")) 1)
(test (count-mas-x-3x3 (lines "M.S\n.A.\nM.S")) 1)
(test (count-mas-x-3x3 (lines "M..\n.A.\n..S")) 0)

(defn count-mas-x [ls]
  (var out 0)
  (let [h (length ls)
        w (length (ls 0))]
    (loop [x :range [0 (- w 2)]
           y :range [0 ( - h 2)]
           :let [g3x3 (grid-nxn 3 ls x y)
                 xmas-diag-count (count-mas-x-3x3 g3x3)]]
      (set out (+ out xmas-diag-count)))
    out))

(defn part1 [input]
  (print "The answer to part 1 is: " (count-xmas (lines input))))

(defn part2 [input]
  (print "The answer to part 2 is: " (count-mas-x (lines input))))

(defn main [&]
  (def input (string/trim (file/read stdin :all)))
  (part1 input)
  (part2 input))
