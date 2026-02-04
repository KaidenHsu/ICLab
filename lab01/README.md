# Lab 1. Chinese Course

In ICLab Lab 1, the primary task involves inputting the scores of 7 students (4-bit each) and outputting their sorted student IDs based on a specified mode signaled by opt (signed/unsigned, ascending/descending). After sorting, the circuit performs linear transformations, calculates the average and the passing score according to specific rules, and finally outputs the count of students who passed. Overall, this exercise integrates sorting, arithmetic operations, and conditional logic into a purely combinational circuit, requiring the handling of both signed and unsigned datapaths simultaneously.
<br>
<br>
The grading focus for this lab is circuit area. Initially, I implemented a sorter using an intuitive approach with numerous conditional statements (determining ranking through extensive pairwise comparisons). While functionally correct, the high volume of comparators and selection logic resulted in a larger circuit area. I subsequently adopted a "minimum area sorting network for 7 elements" architecture, which decomposes the sorting into a fixed number of interconnected compare-and-swap modules. The advantage of a sorting network lies in its fixed number of comparators and consistent connection structure, which allows for better optimization by synthesis tools and more predictable area constraints.
<br>
<br>
In the implementation, I designed each compare-and-swap unit to output both the "sorted score" and the "corresponding original student ID." This eliminates the need to trace back sources at the end to retrieve the sorted IDs. To support both signed and unsigned sorting, I performed preprocessing at the input stage: in signed mode, the MSB is treated as a sign extension, while in unsigned mode, it is zero-extended. This ensures that the subsequent comparators operate on a uniform data width throughout the entire sorting network. I also incorporated a student ID tie-break rule for cases where scores are identical, ensuring the output matches the specification requirements.
<br>
<br>
Beyond sorting, I applied small area-saving techniques for calculating the average and passing scores. For the unsigned average, I replaced a direct division by 7 with a constant division approximation (multiplying by a magic number and then shifting), which avoids the need for a large, dedicated hardware divider. Even though modern synthesizers are highly proficient at these low-level optimizations, understanding the underlying hardware architecture remains crucial for a designer. This knowledge directly influences the trade-offs between PPA (Power, Performance, Area) and code maintainability.

<p align="center"><img src="/images/sorting_network.png" alt="sorting network" width="600" /></p>
