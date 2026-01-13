# Lab 1. Chinese Course

在 ICLab Lab1 中，主要任務是：輸入 7 位學生的分數（每位 4-bit），依照 opt 訊號指定的模式（signed/unsigned、升冪/降冪）輸出排序後的學號，並且在完成排序後再依照題目規則做線性轉換、計算平均與通過分數，最後輸出通過（或未通過）的人數。整體來說是一個把「排序 + 分數運算 + 條件判斷」整合成純組合邏輯的練習，而且必須同時處理 signed 與 unsigned 的資料路徑 (datapath)。
<br>
<br>
這個 lab 的評分重點是電路面積（area），一開始我先用直覺作法寫了一版比較多條件判斷的 sorter（透過大量 pairwise comparison 推出 ranking），雖然功能正確，但比較器與選擇邏輯數量比較多，電路面積會比較大。後來我改採用網路上查到的「7 個 element 的最小面積 sorting network」架構 (下圖)，將排序拆成固定層數的 compare-and-swap 模組串接。這種 sorting network 的好處是比較器數量與連線結構都固定，合成時容易被工具優化，而且面積通常比一般寫法更可控。
<br>
<br>
在實作上，我把每次 compare-and-swap 同時輸出「排序後的值」以及「對應的原始學號」，因此最後不需要額外回推來源，就能直接得到排序後的學號。另外，為了支援 signed/unsigned 的排序，我在輸入端先做預處理：signed 模式下把 MSB 當作符號延伸、unsigned 模式下補 0，讓後續比較器都用同一套資料寬度跑完整個 sorting network。遇到分數相同時，我也加入以學號作為 tie-break 的規則，確保輸出排序結果符合題目要求。
<br>
<br>
除了排序以外，平均值與 passing score 的計算也有一些節省面積的小技巧。像 unsigned 平均我用常數除法的近似（乘上 magic number 再位移）來取代直接除以 7，讓硬體不需要真的推導出一個大除法器。即使現在的合成軟體（synthesizer）對於這類底層優化大多已經做得很好，但理解「最後會被合成成什麼硬體架構」對設計師仍然十分重要，會直接影響設計師在 PPA 及程式碼可維護性下的取捨。

<p align="center"><img src="/images/sorting_network.png" alt="sorting network" width="600" /></p>
