module FlipCoin where
flipCoin :: String -> [Int]
flipCoin xs = flipFront xs 0

flipFront :: String -> Int -> [Int]
flipFront [] index = []
flipFront [x] index
    | x == 'H' = [0]
    | otherwise = [index + 1, 0]

flipFront (x:xs) index
    | x == (head xs) = flipFront xs (index+1)
    | otherwise = [index + 1] ++ flipFront xs (index + 1)

    
