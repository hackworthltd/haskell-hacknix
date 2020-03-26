{-# LANGUAGE OverloadedStrings #-}

module MyLib (someFunc) where

import Data.Text (Text)
import Paths_hhp

-- | Dummy function with doctests.
--
-- >>> someFunc
-- someFunc
someFunc :: Text
someFunc = "someFunc"
