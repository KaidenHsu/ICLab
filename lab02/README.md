在 ICLab Lab2 中，題目為 12-Queen 問題，要求在已給定部分皇后位置的情況下，由硬體完成剩餘皇后的擺放，並依序輸出每一個 column 對應的 row。本次評分重點放在完成一次計算所需的 cycle 數，因此設計時要思考如何讓整體流程在循序電路中有效率的運行。
<br>
<br>
整體架構上，我將原本在軟體中一次完成的 backtracking 搜尋，改寫成以 FSM 控制的循序流程，將 input、search、place、backtrack 與 output 拆成多個 cycle 逐步執行。行與對角線的佔用狀態以 bitmap 方式維護，使擺放檢查能在單一 cycle 內完成。輸入與輸出資料則設計成 shift register 的形式，讓資料隨 clock 規律移動，不僅簡化了控制邏輯，也讓整體時序行為更容易分析。
<br>
<br>
從效能角度來看，目前的解法仍有優化空間，例如在搜尋開始前先整理出需要填入的 column，後續只在這些 column 間 search 與 backtrack，就能避免每次都重新尋找下一個 column，進一步減少不必要的 cycle。從這個 lab 我學到了軟體中需要 backtrack 解法的題目如何使用硬體實現相應功能。並體會了事先算好一些之後處理會反覆用到的值帶來的好處，此優化類似於軟體中 dynamic programming 的 memoization 的提速。
