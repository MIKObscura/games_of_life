import Control.Concurrent
import System.Process
import System.Random
import Data.Array.ST
import Control.Monad
import Control.Monad.ST
import Data.STRef

createUniverse :: Int -> Int -> [Int]
createUniverse w h = [0 | x <- [0..((w + 2) * (h + 2))]]

isEdge :: Int -> Int -> Int -> Bool
isEdge i w h = i < (w + 1)
            || i > ((w + 2) * (h + 2) - (w + 2))
            || (i `mod` (w + 2)) == 0
            || ((i + 1) `mod` (w + 2)) == 0

shuffle' :: [a] -> StdGen -> ([a],StdGen)
shuffle' xs gen = runST (do
        g <- newSTRef gen
        let randomRST lohi = do
                (a,s') <- liftM (randomR lohi) (readSTRef g)
                writeSTRef g s'
                return a
        ar <- newArray n xs
        xs' <- forM [1..n] $ \i -> do
                j <- randomRST (i,n)
                vi <- readArray ar i
                vj <- readArray ar j
                writeArray ar j vi
                return vj
        gen' <- readSTRef g
        return (xs',gen'))
    where
        n = length xs
        newArray :: Int -> [a] -> ST s (STArray s Int a)
        newArray n = newListArray (1,n)

generateInitialLives :: Int -> [Int] -> [Int]
generateInitialLives amount availableTiles = take amount (fst (shuffle' availableTiles (mkStdGen 69)))

initialGeneration :: [Int] -> [Int] -> [Int]
initialGeneration universe indexes = [if x `elem` indexes then 1 else 0 | x <- [0..(length universe - 1)]]

computeCell :: Int -> [Int] -> Int
computeCell cell neighbors | sum neighbors == 3 = 1
                            | sum neighbors == 2 = 1
                            | otherwise = 0

getNeighbors :: Int -> Int -> Int -> [Int] -> [Int]
getNeighbors i w h universe = [universe !! (i + 1),
                                universe !! (i - 1),
                                universe !! (i - (w + 1)),
                                universe !! (i - (w + 2)),
                                universe !! (i - (w + 3)),
                                universe !! (i + (w + 1)),
                                universe !! (i + (w + 2)),
                                universe !! (i + (w + 3))]

newGeneration :: [Int] -> Int -> Int -> [Int]
newGeneration universe w h = [if isEdge x w h then 0 else computeCell (universe !! x) (getNeighbors x w h universe)
                                | x <- [0..(length universe - 1)]]

universeToStr :: [Int] -> Int -> Int -> [String]
universeToStr universe w h = [if isEdge x w h then ""
                            else if (x + 2) `mod` w == 0 then " | " ++ show (universe !! x) ++ " |\n"
                            else " | " ++ show (universe !! x)
                            | x <- [0..(length universe - 1)]]

mainLoop u w h = do
    threadDelay 1000000
    system "clear"
    putStrLn (concat (universeToStr u w h))
    mainLoop (newGeneration u w h) w h

main = do
    let emptyUniverse = createUniverse 40 40
    let initialLivings = generateInitialLives 400 [x | x <- [0..length emptyUniverse - 1], not (isEdge x 40 40)]
    let universe = initialGeneration emptyUniverse initialLivings
    mainLoop universe 40 40