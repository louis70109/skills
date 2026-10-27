---
name: rms-frontend-pitfalls
description: Use before you change CSS or JS in build_spa.py (layout, cat, swipe, update popup, PWA, Service Worker). 修改 build_spa.py 的 CSS／JS 前必讀：樣式沒生效、TDZ 錯誤、圖片沒載入、SW 快取的已知陷阱與測試方法。
---

# RMS-FRONTEND-PITFALLS

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

適用範圍：MapleRoyals 攻略庫建置 repo `louis70109/rms-data-build`（私人）。檔名與指令都相對於該 repo。
Scope: the `louis70109/rms-data-build` repo (private). Paths and commands are relative to it.

## CSS

- 全域 `#content …` 規則（id 權重）會蓋掉元件 class。元件樣式必須寫成 `#content .cls`。受影響：ul、p 邊距，`a{word-break:break-all}`，`img` 的邊框、放大游標與燈箱點擊。
- 首頁 `.card h2` 被 `#content h2` 覆蓋。這是已知問題，尚未修。
- SVG `<symbol>` 內的選擇器不可用祖先選擇器。
- `bounceTitle`：ASCII 連續字用 nowrap，CJK 逐字包裝。否則手機長標題會溢出。

## JS

- `const`、`let` 若宣告在第一次 `route()` 呼叫之後，會出現 TDZ 錯誤。貓咪常數必須在 `function home` 之前。
- 貓（`catSpawn`、`catSwat`、`catSchedule`、`catCall`）不可影響排版。使用者可拍掉、拖走，或用 `#catbtn` 叫回。狀態存在 `sessionStorage rms_cat_quiet`。
- 更新彈窗用 `CHANGELOG`（來自 `changelog.json`）與 localStorage `rms_seen_ver`。
- 桌面版（Tauri）不註冊 Service Worker。外部連結交給系統瀏覽器。用 `window.__TAURI__` 偵測。

## PWA 與快取

- `sw.js` 由 `pwa/sw.template.js` 產生。`__VERSION__` 是內容雜湊。
- 導覽請求用 `fetch(req,{cache:'no-cache'})`。install 用 `cache:'reload'`。
- 公開 repo 的 `server.py` 對所有回應加 `Cache-Control: no-cache`，並關閉目錄列表。
- 原地替換同名圖片時，必須把 `ASSET_CACHE`（`rms-assets-v1`）版本加一。
- 改 SW 後執行 `node pwa/test_sw.mjs sw.js`。13 項必須全過。

## 瀏覽器測試（Playwright）

- 環境已有 Chromium 與 Playwright。用 `require('playwright')`。不可重裝。
- 用 `python3 -m http.server <port>` 起本機伺服器。用 PID 結束它。`pkill -f` 會殺掉自己的 shell。
- 測圖片前，先把 lazy 圖片的 `loading` 設成 `eager`。否則無頭測試不會 decode。
- 用 touch 事件模擬手勢。
- SW 必須在 `http://127.0.0.1` 或 HTTPS 才能註冊。
- 驗證圖片看檔案回應碼。不可依賴截圖。

## 編輯 build_spa.py

1. 用 Edit 工具。不可用含反斜線的 `sed` 或 heredoc（曾寫入退格字元）。
2. 執行 `python -I -c "import ast;ast.parse(open('build_spa.py',encoding='utf-8').read())"`。
3. 建置。
