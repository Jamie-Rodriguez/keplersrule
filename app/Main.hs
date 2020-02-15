{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Prelude hiding       (writeFile) 
import System.Environment   (getArgs)
import Control.Monad        (when)
import Data.ByteString.Lazy

import GHC.Generics (Generic)
import Data.Csv

import Lib (integrate)


-- Data.Csv doesn't allow for encoding Rational numbers?
data TrainingData = TrainingData {
                                   radius :: Double,
                                   x1     :: Double,
                                   x2     :: Double,
                                   area   :: Double
                                 }
        deriving (Generic, Show)

instance FromNamedRecord TrainingData
instance ToNamedRecord   TrainingData
instance DefaultOrdered  TrainingData


-- Formula for a circle of radius 'r', centred at (r, r):
--         y = r - sqrt(2rx - x^2)      for 0 <  y <= r
--         y = r + sqrt(2rx - x^2)      for r <= y <  2r
-- Only care about range
--         0 <= x <= r
--              &
--         0 <= y <= r
semiCircle :: Floating a => a -> a -> a
semiCircle r x = r - sqrt (2*r*x - x*x)


main :: IO ()
main = do
        args <- getArgs
        when (Prelude.null args) (fail "No output file name specified.")
        let [filepath] = args


        -- How many samples of training data to take for 0 <= x <= r
        let samples = 100
        -- How many subdivisions to use for Kepler's method
        -- (more subdivisions = more accurate approximation)
        let n = 1000

        let rInc = 0.1 :: Rational
        let rStart = 0.1 :: Rational
        let rEnd = 10 :: Rational
        let rSecond = rStart + rInc


        let trainingData = [ TrainingData (fromRational r) (fromRational a) (fromRational b) i | r <- [rStart, rSecond .. rEnd] :: [Rational],
                                                                                                 let delta = r/samples,
                                                                                                 a <- [0, delta     .. r]       :: [Rational],
                                                                                                 b <- [a, (a+delta) .. r]       :: [Rational],
                                                                                                 let i = integrate (semiCircle (fromRational r)) (fromRational a) (fromRational b) n]

        let csvData = encodeDefaultOrderedByName trainingData
        writeFile filepath csvData
