{-# OPTIONS_GHC -Wall #-}

module Lib (integrate) where


generatePolyCoeffs :: Num a => Int -> [a]
generatePolyCoeffs n = generatePolyCoeffs' n []


generatePolyCoeffs' :: Num a => Int -> [a] -> [a]
generatePolyCoeffs' n cs | len >= n-1 = (cs ++ [1])
                         | len < 1    = generatePolyCoeffs' n (cs ++ [1])
                         | even len   = generatePolyCoeffs' n (cs ++ [2])
                         | odd len    = generatePolyCoeffs' n (cs ++ [4])
        where
                len = length cs


integrate :: (Ord a, Fractional a) => (a -> a) -> a -> a -> Int -> a
integrate f a b n = deltaX / 3 * foldr (+) 0 (zipWith (\y c -> c*y) ys cs)
        where
                lower  = min a b
                upper  = max a b
                m = if n `mod` 2 == 0 then n else n + 1

                deltaX = (upper - lower) / fromIntegral m
                xs = getXValues lower upper m
                ys = map f xs
                createCoeffsForYs = generatePolyCoeffs . length
                cs = createCoeffsForYs ys


getXValues :: Fractional a => a -> a -> Int -> [a]
getXValues a b n = getXValues' a b n []


getXValues' :: Fractional a => a -> a -> Int -> [a] -> [a]
getXValues' a b n vals | i <  n+1 = getXValues' a b n (vals ++ [currVal])
                       | i >= n+1 = vals
        where
                -- TODO: Memoize deltaX as it doesn't change value between recursive calls
                deltaX = (b - a) / fromIntegral n
                i = length vals
                currVal = a + (fromIntegral i)*deltaX
