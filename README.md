# Kepler's Rule
Implementation of Kelper's rule (also known as Simpson's rule) for the numerical approximation of definite integrals.

The library code (`Lib.hs`) can be used on it's own to compute definite integrals for one-off calculations.

`Main.hs` is used to generate bulk training data for a machine learning problem.

## Usage
When running the executable, the user is required to specify a path to an output file to save training data. Note that the output file doesn't need to already exist on disk.
`$ keplersrule-exe trainingData.csv`

## To-Do
- Implement command-line parsing of parameters
- Profile code and analyse performance bottlenecks
- Memoise constant values in recursive function calls (see `getXValues'`)
- Make pattern matching exhaustive for functions in `Lib.hs`
