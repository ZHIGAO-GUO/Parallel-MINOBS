# Parallel-MINOBS
Parallel-MINOBS is an structure learning algorithm of Bayesian networks that operates on Candidate Parent Sets (CPSs). Parallel-MINOBS applies to combinatorial optimization of CPSs that are up to tens of millions or even more. The details of the algorithm can be found at 

Zhigao Guo, Anthony C. Constantinou. Parallel Sampling for Efficient High-dimensional Bayesian Network Structure Learning, https://arxiv.org/abs/2202.09691.

To run the algorithm, at the fisrt stage, run the "main.m" file with the input CPCS file, by specifying the preferred the number of sets of sampled CPSs, Sets_num (by default, 10). At the second stage, the sampled CPSs are parallelly optimized by running "main.cpp" on Linux.
