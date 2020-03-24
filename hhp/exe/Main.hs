module Main where

import qualified MyLib (someFunc)

import qualified Data.Text.IO as T (putStrLn)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  T.putStrLn MyLib.someFunc
