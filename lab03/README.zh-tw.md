# Lab3. Subway Surfers

在 lab3 中，題目要求主角在一個 4×64 的地圖上前進，地圖中包含 road、lower obstacle、higher obstacle 與 train 等元素，主角可以透過 forward、left、right、jump 四種動作來探索地圖，成功跑到最後一個 column 就算完成。我延續 lab2 的 FSM 設計，採取 input、forward 與 backtrack 搜尋、最後 output 結果的整體設計流程，使控制邏輯與資料流向更為清楚。值得一提的是，針對 4×64 的地圖表示，我以 4 個 shift register 來實作地圖的推進，而非使用 4 個大型的 mux，這樣可以避免複雜的選擇邏輯，有效節省電路面積，也讓資料移動的行為更貼近實際硬體的運作方式。
<br>
<br>
這個 lab 比起 RTL 設計本身，更著重於功能完整的 testbench 撰寫。我在本 lab 中採用 random testing，總共產生 300 組測資，用來檢驗 RTL 在各種不同地圖與初始條件下的正確性。testbench 會依照題目規範自行產生 4×64 的地圖內容，並模擬主角在地圖中的行為。同時，題目一共定義了 10 個 specs，我的 testbench 必須逐一檢查設計是否滿足這些規格，確保輸出結果在時序與功能上皆符合要求，嚴謹檢查輸出的正確性與效能。
<br>
<br>
本實驗的核心則放在驗證在 VLSI 設計流程中的重要性。從電路設計一路到實際製造，越晚發現瑕疵，所造成的時間與成本損失就越大，因此完善的驗證流程對於降低風險至關重要。在驗證策略上，單靠 random testing 往往難以達到 100% coverage，因此在驗證後期通常需要加入 directed testing，針對特定的 corner case 主動設計測資，以找出難以發現的 bug。整體流程可粗分為 preliminary verification、broad spectrum verification 與 corner case verification，逐步擴大測試範圍。實作過程中，也能善用 file I/O，搭配高階語言產生測資，並透過 task 與 function 提升 testbench 的可讀性與可維護性。
<br>
<br>
此外，Verilog 本身提供了一些與時序檢查相關的語法，這也是我未來希望進一步探索的方向。而 SystemVerilog 則提供 SVA、random generation 以及 OOP 等方便的功能，使驗證環境能更模組化且具備良好的擴充性。透過這次 lab，我對驗證在實務 IC 設計中的地位有了更全面且具體的理解，也親身體悟到「優秀的硬體設計者同時也是優秀的驗證者」，有效的驗證對於設計功能正確的晶片至關重要。

<p align="center"><img src="/images/subway_surfer.png" alt="subway surfer" width="840" /></p>
