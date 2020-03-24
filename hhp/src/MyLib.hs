{-# LANGUAGE OverloadedStrings #-}

module MyLib (someFunc) where

import Data.Text (Text)

-- | Dummy function with doctests.
--
-- >>> someFunc
-- someFunc
someFunc :: Text
someFunc = "someFunc"
