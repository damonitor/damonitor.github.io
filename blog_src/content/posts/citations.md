+++
title = 'Citations'
date = 2025-11-26T06:43:33-08:00
draft = false
+++

This post lists research papers and news articles citing DAMON in a not just
simple listing way.  The list is best effort collection of the papers and
articles, so may not be perfect.

Yet another way to get the list would be using the Google Scholar for DAMON
author-published paper ciataions
([1](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=5046280136836673051&as_sdt=5),
[2](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=12959341493842439999&as_sdt=5)).

- Tong Xing, Jiaxun Yang, Javier Picorel, and Antonio Barbalace. 2026.
  Rethinking Tiered Memory Management in Cloud Data Centers. In Proceedings of
  the 2025 ACM Symposium on Cloud Computing (SoCC '25). Association for
  Computing Machinery, New York, NY, USA, 74–87.
  https://doi.org/10.1145/3772052.3772213
  - Summary is TBD.
- Taehyung Lee, Sumit Monga, Young Ik Eom, and Changwoo Min. 2025. Harnessing
Page Access Frequency Distribution for Efficient Memory Tiering. ACM Trans.
Comput. Syst. Just Accepted (November 2025). https://doi.org/10.1145/3777549
  - Introduces DAMON as a recently introduced way for doing page table based
    access tracking that mitigates the mointoring overhead.  It shows DAMON's
    limitation of fixed monitoring intervals and number of regions limitation,
    with heatmaps of a workload (654.roms) that generated with multiple DAMON
    parameter combinations.  It doesn't explore the monitoring intervals
    auto-tuning, though.
- Baumstark, Alexander; Paradies, Marcus; Sattler, Kai-Uwe (2025): Lightweight
  Memory Access Monitoring for Dynamic Data Placement in Tiered Memory Systems.
  Datenbanksysteme für Business, Technologie und Web (BTW 2025). DOI:
  10.18420/BTW2025-12. Gesellschaft für Informatik, Bonn. EISSN: 2944-7682. pp.
  265-276. Research Track. Bamberg. 3.-7. März 2025
- Kavya Shekar and Dan Williams. 2025. SchedBPF - Scheduling BPF programs. In
  Proceedings of the 3rd Workshop on eBPF and Kernel Extensions (eBPF '25).
  Association for Computing Machinery, New York, NY, USA, 45–47.
  https://doi.org/10.1145/3748355.3748366
- Wanju Doh, Yaebin Moon, Seoyoung Ko, Seunghwan Chung, Kwanhee Kyung, Eojin
  Lee, and Jung Ho Ahn. 2025. PET: Proactive Demotion for Efficient Tiered
  Memory Management. In Proceedings of the Twentieth European Conference on
  Computer Systems (EuroSys '25). Association for Computing Machinery, New
  York, NY, USA, 854–869. https://doi.org/10.1145/3689031.3717471
- Fisher, Max Henry. Analysis of Memory Access Patterns for Large Language
  Model Inference. Diss. Virginia Tech, 2025.
  https://hdl.handle.net/10919/135946
- Jie Ren, Dong Xu, Junhee Ryu, Kwangsik Shin, Daewoo Kim, and Dong Li. 2024.
  MTM: Rethinking Memory Profiling and Migration for Multi-Tiered Large Memory.
  In Proceedings of the Nineteenth European Conference on Computer Systems
  (EuroSys '24). Association for Computing Machinery, New York, NY, USA,
  803–817. https://doi.org/10.1145/3627703.3650075
- Nair, Alan, SANDEEP KUMAR, and ARAVINDA PRASAD. "Telescope: Profiling Memory
  Access Patterns at the Terabyte-scale." 2024 USENIX Annual Technical
  Conference (USENIX ATC 24). 2024.
- Sai Sha, Chuandong Li, Yingwei Luo, Xiaolin Wang, and Zhenlin Wang. 2023.
  VTMM: Tiered Memory Management for Virtual Machines. In Proceedings of the
  Eighteenth European Conference on Computer Systems (EuroSys '23). Association
  for Computing Machinery, New York, NY, USA, 283–297.
  https://doi.org/10.1145/3552326.3587449
- Juneseo Chang, Wanju Doh, Yaebin Moon, Eojin Lee, and Jung Ho Ahn. 2024. IDT:
  Intelligent Data Placement for Multi-tiered Main Memory with Reinforcement
  Learning. In Proceedings of the 33rd International Symposium on
  High-Performance Parallel and Distributed Computing (HPDC '24). Association
  for Computing Machinery, New York, NY, USA, 69–82.
      https://doi.org/10.1145/3625549.3658659
