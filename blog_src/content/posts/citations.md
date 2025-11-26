+++
title = 'Citations'
date = 2025-11-26T06:43:33-08:00
draft = true
+++

This post lists research papers and news articles citing DAMON.  The list is
best effort collection of the papers and articles, so may not be perfect.

- Taehyung Lee, Sumit Monga, Young Ik Eom, and Changwoo Min. 2025. Harnessing
Page Access Frequency Distribution for Efficient Memory Tiering. ACM Trans.
Comput. Syst. Just Accepted (November 2025). https://doi.org/10.1145/3777549
  - Introduces DAMON as a recently introduced way for doing page table based
    access tracking that mitigates the mointoring overhead.  It shows DAMON's
    limitation of fixed monitoring intervals and number of regions limitation,
    with heatmaps of a workload (654.roms) that generated with multiple DAMON
    parameter combinations.  It doesn't explore the monitoring intervals
    auto-tuning, though.
