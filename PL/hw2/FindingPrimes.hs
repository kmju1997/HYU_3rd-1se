module FindingPrimes where

primes :: [Int] 
primes = sieve [2..]
    where sieve (x:xs) = x : sieve [t| t<- xs, t `mod` x /= 0] 

findingPrimes:: Int -> Int -> [Int]
findingPrimes a b = take b $ filter (>=a) primes
