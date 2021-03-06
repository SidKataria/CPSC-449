--CPSC 449
--Winter 2018
--Assignment 2
--Name: Siddharth Kataria
--UCID: 30000880 
{-
References:
http://learnyouahaskell.com/input-and-output
https://rosettacode.org/wiki/Category:Haskell
http://book.realworldhaskell.org/read/io.html
https://www.reddit.com/r/haskellquestions/
https://stackoverflow.com/questions/27196642/what-is-an-example-implementation-of-exit-code-for-haskell-program-that-returns
https://en.wikibooks.org/wiki/Haskell/Lists_and_tuples
https://wiki.haskell.org/Tutorials/Programming_Haskell/String_IO
https://en.wikibooks.org/wiki/Haskell/Control_structures
http://julio.meroh.net/2006/08/split-function-in-haskell.html
https://stackoverflow.com/questions/19275100/string-split-into-6-parts-every-character-in-haskell
https://codereview.stackexchange.com/questions/6992/approach-to-string-split-by-character-in-haskell
https://github.com/haskell/filepath/blob/master/Generate.hs
https://www.youtube.com/watch?v=FufhKV3dEis
-}

--File for pasrsing text file
import System.Environment
import System.IO
import System.Directory
import System.Exit (exitSuccess)
import Data.List
import Data.String
import Data.Char
import Control.Exception 

-- checks the machine task booleans
isValid :: [Bool] -> Bool
isValid x = elem True x

-- checks inside our list of booleans
checkBool :: [Bool] -> Bool
checkBool [] = True
checkBool (x:xs) = x && (checkBool xs)

{-Fuctions for booleaning checking in main (Not Working)
checkBool2pair :: [String] -> Bool
checkBool2pair [] = False
checkBool2pair x
    | checkBool (map check2Pair(removeEmpty x)) == True = True
    | otherwise = False

checkBool3pair :: [String] -> Bool
checkBool3pair [] = False
checkBool3pair x
    | checkBool (map check3Pair(removeEmpty x)) == True = True
    | otherwise = False
-}  
-- returns the last charecter in the string
lastChar :: String -> String
lastChar []  = []
lastChar (x) 
    | last x == ' '   = lastChar (init x)
    | last x == '\t'  = lastChar (init x)
    | otherwise = x
    
-- checks if the file has empty lines
checkEmpty :: String -> String
checkEmpty [] = []
checkEmpty (x:xs) 
    | x == '\r' = checkEmpty xs
    | otherwise = x: checkEmpty xs

-- returns the left hand side of the string
takeTo :: String -> [String] -> [String]
takeTo _ [] = []
takeTo [] x = x
takeTo y (x:xs)    
    | y /= x = x:(takeTo y xs)
    | otherwise = []

-- returns the right hand side of the string
takeFrom :: String -> [String] -> [String]
takeFrom _ [] = []
takeFrom [] x = x
takeFrom y (x:xs) 
    | y /= x    = takeFrom y xs
    | otherwise = xs

--Part the string into different givin sections
partString :: String -> String -> [String] -> [String]
partString _ _ [] = []
partString [] y z = takeTo y z
partString x [] z = takeFrom x z
partString x y z  = takeFrom x (takeTo y z)

-- checks the number of commas in a given string
checkComma :: String -> Int
checkComma []  = 0
checkComma (x:xs)  
    | (x == ',')= 1 + (checkComma xs)
    | otherwise = checkComma xs

-- checks for a given pair of 2 in the text and returns true if so
check2Pair :: String -> Bool
check2Pair [] = False
check2Pair (x)  
    | ((head x) == '(') && ((last x) == ')') && ((checkComma x) == 1)  = True   --Pairs look like: (_,_)
    | otherwise  = False

-- checks for a given pair of 3 in the text and returns true if so
check3Pair :: String -> Bool
check3Pair [] = False
check3Pair x  
    | ((head x) == '(') && ((last x) == ')') && ((checkComma x) == 2)  = True   --Pairs look like: (_,_,_)
    | otherwise  = False

-- checks if the given task is a valid take
-- Tasks can be from the following: {A,B,C,D,E,F,G,H}
checkTask :: Char -> Bool
checkTask x  
    | x == 'A'  = True
    | x == 'B'  = True
    | x == 'C'  = True
    | x == 'D'  = True
    | x == 'E'  = True
    | x == 'F'  = True
    | x == 'G'  = True
    | x == 'H'  = True
    | otherwise = False

-- deletes empty spaces from the file
removeEmpty :: [String] -> [String]
removeEmpty [] = []
removeEmpty (x:xs) 
    | lastChar x == "" = removeEmpty xs
    | otherwise = x:(removeEmpty xs)

-- the main function with gets the filePaths and parses the input file
main = do
    args <- getArgs
    handle <- openFile (args !! 0) ReadMode
    contents <- (hGetContents handle)
    {-
     -Enter error handling to check if file exists
     -filecontent not contails all of the contents in the file. 
     -check file list using enums as using their positions for the next part (Not Working)
     -}
    let setFile = map lastChar (lines (checkEmpty (map toUpper contents)))  -- Converting all strings to upper charecters for checking
        --Get sections of strings from the file to check for parsing
        partName   = partString "NAME:" "FORCED PARTIAL ASSIGNMENT:" setFile
        partForced = partString "FORCED PARTIAL ASSIGNMENT:" "FORBIDDEN MACHINE:" setFile
        partForbid = partString "FORBIDDEN MACHINE:" "TOO-NEAR TASKS:" setFile
        part2near  = partString "TOO-NEAR TASKS:" "MACHINE PENALTIES:" setFile
        partMpenal = partString "MACHINE PENALTIES:" "TOO-NEAR PENALTIES:" setFile
        part2penal = partString "TOO-NEAR PENALTIES:" "" setFile

    {-
     - Convert if-else to guards (Not Working)
    -}
    -- to check if the name is given in the file
    if ((length(removeEmpty partName) == 1))
    then return()
    else do writeFile (last args) "Error parsing the input file"
            exitSuccess

    -- to check if the forced partial assignment are a pair of two elements
    if(checkBool (map check2Pair(removeEmpty partForced)))
    then return()
    else do writeFile (last args) "invalid machine/task"
            exitSuccess
 
    -- to check if the forbidden machines are a pair of two elements
    if(checkBool (map check2Pair(removeEmpty partForbid)))
    then return()
    else do writeFile (last args) "invalid machine/task"
            exitSuccess

    -- to check if the too-near tasks are a pair of two elements
    if(checkBool (map check2Pair(removeEmpty part2near)))
    then return()
    else do writeFile (last args) "invalid machine/task"
            exitSuccess

    {-Fuction not working correctly (Not Working)
    -- to check if the total given machine penalties is 8x8
    if(length partMpenal == 64)
    then return()
    else do writeFile (last args) "machine penalty error"
            exitSuccess
    -}

    -- to check if the too-near penalties are a pair of three elements
    if(checkBool (map check3Pair(removeEmpty part2penal)))
    then return()
    else do writeFile (last args) "invalidd machine/task"
            exitSuccess

    -- The text has been successfully passed
    writeFile (last args) "file parsed without problems"
    exitSuccess