# Lab 2. 12-Queen

In ICLab Lab 2, the task was to solve the 12-Queen problem. Given partial queen placements, the hardware must determine the positions for the remaining queens and sequentially output the corresponding row for each column. The grading for this lab focused on the number of cycles required to complete a single computation, requiring a design that ensures the entire process runs efficiently within a sequential circuit.
<br>
<br>
In terms of architecture, I converted the backtracking search—which is typically handled all at once in software—into an FSM-controlled sequential flow. I partitioned the input, search, place, backtrack, and output phases into multiple clock cycles. To maintain the occupancy status of rows and diagonals, I used a bitmap approach, allowing placement checks to be completed within a single cycle. Both input and output data were designed as shift registers, enabling data to move rhythmically with the clock; this not only simplified the control logic but also made the overall timing behavior easier to analyze.
<br>
<br>
From a performance perspective, there is still room for optimization. For instance, by identifying the specific columns that require placement before the search begins and only performing search and backtrack operations across those columns, one could avoid re-locating the next available column every time, further reducing unnecessary cycles. Through this lab, I learned how to implement backtracking solutions, commonly found in software, using hardware. I also experienced the benefits of pre-computation—calculating values in advance that will be repeatedly used—which provides a speedup similar to memoization in software dynamic programming.

<p align="center"><img src="/images/12-queen.png" alt="12-QUEEN" width="480" /></p>
