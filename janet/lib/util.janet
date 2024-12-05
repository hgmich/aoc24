(use judge)

(defn unzip2 [ps]
  (let [xs @[] ys @[]]
    (each [x y] ps (do
      (array/push xs x)
      (array/push ys y)))
    [xs ys]))

(test (unzip2 []) [@[] @[]])
(test (unzip2 @[]) [@[] @[]])
(test (unzip2 [[1 2] [3 4]]) [@[1 3] @[2 4]])
(test (unzip2 [@[1 2] [3 4]]) [@[1 3] @[2 4]])
(test (unzip2 [@[1 2] @[3 4]]) [@[1 3] @[2 4]])
(test (unzip2 @[[1 2] [3 4]]) [@[1 3] @[2 4]])
(test (unzip2 @[@[1 2] [3 4]]) [@[1 3] @[2 4]])
(test (unzip2 @[@[1 2] @[3 4]]) [@[1 3] @[2 4]])

(defn zip [& ls]
  (map tuple ;ls))

(test (zip [1 2] [3 4]) @[[1 3] [2 4]])
(test (zip [1 2] @[3 4]) @[[1 3] [2 4]])
(test (zip @[1 2] [3 4]) @[[1 3] [2 4]])
(test (zip @[1 2] @[3 4]) @[[1 3] [2 4]])
(test (zip [] []) @[])
(test (zip [1 2 3] [4 5]) @[[1 4] [2 5]])

(defn string-zip [& ls]
  (map string/from-bytes ;ls))

(defn table-set
  "Turn an indexable (array, tuple, etc) into a table with keys set to true, for use like a set."
  [ind]
  (table ;(mapcat (fn [i] [i true]) ind)))
