import Data.Array
import Data.Map
import Data.List
import Data.Maybe
import Debug.Trace
import Data.Int

mat = makeBoardStep [0,0,3,0,0,0,2,0,5,0,0,0,9,0,5,0,0,7,5,8,0,3,0,9,0,1,4,0,0,1,0,0,4,0,0,0,9,0,0,5,1,2,0,0,3,0,0,0,7,0,0,9,0,0,7,5,0,2,0,1,0,6,9,3,0,0,6,0,7,0,0,0,1,0,6,0,0,0,8,0,0]
blk = makeBoardStep [1,1,2,2,2,3,3,3,3,1,1,2,1,2,2,2,3,3,1,1,1,1,5,2,2,3,3,4,4,4,4,5,5,6,6,3,4,4,4,5,5,5,6,6,6,7,4,4,5,5,6,6,6,6,7,7,8,8,5,9,9,9,9,7,7,8,8,8,9,8,9,9,7,7,7,7,8,8,8,9,9]
valList :: [Int]
valList = [0,0,3,0,0,0,2,0,5,0,0,0,9,0,5,0,0,7,5,8,0,3,0,9,0,1,4,0,0,1,0,0,4,0,0,0,9,0,0,5,1,2,0,0,3,0,0,0,7,0,0,9,0,0,7,5,0,2,0,1,0,6,9,3,0,0,6,0,7,0,0,0,1,0,6,0,0,0,8,0,0]
blkList :: [Int]
blkList = [1,1,2,2,2,3,3,3,3,1,1,2,1,2,2,2,3,3,1,1,1,1,5,2,2,3,3,4,4,4,4,5,5,6,6,3,4,4,4,5,5,5,6,6,6,7,4,4,5,5,6,6,6,6,7,7,8,8,5,9,9,9,9,7,7,8,8,8,9,8,9,9,7,7,7,7,8,8,8,9,9]

squigglySudoku = do
       putStrLn "enter value for valList: "
       input1 <- getLine
       putStrLn "enter value for blkList: " 
       input2 <- getLine 
       let x = (read input1 :: [Int])
       let y = (read input2 :: [Int])
       putStrLn "-  -   -   result : " 
       print (squigglySudokuCal x y )

squigglySudokuCal :: [Int] -> [Int] -> [Int]
squigglySudokuCal (x:xs) (y:ys) =
    Data.Map.elems $ head 
    $solveSudoku (makeBoardStep  (x:xs)) (makeBoardStep  (y:ys))
type Pos = (Int,Int)
type Value = Int
type Cell = (Pos,Value)
type Matrix = Map Pos Int

debug = flip trace

-- Making Board
makeBoardStep :: [Int] -> Matrix
makeBoardStep (x:xs) = boardToMatrix $ makeBoard $ makeAssocs $ makeArray (x:xs)

makeArray :: [Int] -> Array Int Int
makeArray (x:xs) = a where a = listArray (1,81) (x:xs)
   
makeAssocs :: Array Int Int -> [(Int,Int)]
makeAssocs a = Data.Array.assocs a

makePosFromIdx :: Int -> Pos
makePosFromIdx x = ((x - 1) `div` 9 + 1, (x - 1) `mod` 9 + 1)

makeBoard :: [(Int,Int)] -> [Cell]
makeBoard [] = []
makeBoard (x:xs) = (makePosFromIdx $ fst x, snd x):makeBoard xs
                                                   
boardToMatrix :: [Cell] -> Matrix
boardToMatrix a = fromList a


--MARK: Solving Sudoku

solveSudoku :: Matrix -> Matrix -> [Matrix]
solveSudoku a b 
    |target == (-1,-1) = [a]
    |otherwise = guesses a b target
        where target = findUnassignedLocation a

--MARK: guess

setNum :: Matrix -> Pos -> Int -> Matrix
setNum a p num = Data.Map.adjust (\x -> num) p a

guesses :: Matrix -> Matrix -> Pos -> [Matrix]
guesses a b p = [solution | v <- safeValues a b p,
        solution <- solveSudoku (setNum a p v) b ]

--MARK: find possibilities
findUnassignedLocation :: Matrix -> Pos
findUnassignedLocation a
    |Data.Map.size a == 0 = (0,0)
    |findVZero a == [] = (-1,-1) -- Sudoku solved
    |otherwise = fst $head $ findVZero a   
        where findVZero a = Data.Map.toList $Data.Map.filter (==True) $ Data.Map.map (==0) a

isSafe :: Matrix -> Matrix -> Pos -> Int -> Bool
isSafe a b p num
    |usedInRow newMat p 0 == False 
    && usedInCol newMat p 0 == False 
    && usedInBlk newMat b p 1 == False 
    = True
    |otherwise = False
        where newMat = setNum a p num

safeValues :: Matrix -> Matrix -> Pos -> [Int]
safeValues a b p = [v| v <- [1..9], isSafe a b p v]

--MARK: checking..
usedInRow :: Matrix -> Pos-> Int-> Bool
usedInRow a p iter 
    |iter == 10 = False
    |iter == col = usedInRow a p (iter+1)
    |Data.Map.lookup (row,iter) a == num = True
    |otherwise = usedInRow a p (iter+1)
        where num = Data.Map.lookup p a
              row = fst p 
              col = snd p

usedInCol :: Matrix -> Pos-> Int-> Bool
usedInCol a p iter 
    |iter == 10 = False
    |iter == row  = usedInCol a p (iter+1)
    |Data.Map.lookup (iter,col) a == num = True
    |otherwise = usedInCol a p (iter+1)
        where num = Data.Map.lookup p a
              row = fst p 
              col = snd p

             

--USAGE: usedInBlk mat blk (3,1) 1
usedInBlk :: Matrix -> Matrix ->  Pos -> Int -> Bool
usedInBlk a b p iter
    |iter == 10 = False
    |sameBlk /= p  && (Data.Map.lookup sameBlk a == num )= 
        --True `debug` concat [(show sameBlk), (show blkNum)]
        True
    |otherwise = usedInBlk a b p (iter+1)
        where num = Data.Map.lookup p a
              blkNum = Data.Map.lookup p b
              sameBlk = searchBlk b (fromJust blkNum) iter 
--MEAN: fromJust -> for convert maybe to actual

searchBlk :: Matrix -> Int -> Int -> Pos
searchBlk b bnum iter  
    |iter == 10 = (0,0)
    |Data.Map.size b == 0 = (0,0)
    |otherwise = fst ((findVBnum b) !! (iter +(-1)))    
        where findVBnum b = Data.Map.toList $Data.Map.filter (==True) $Data.Map.map (==bnum) b

