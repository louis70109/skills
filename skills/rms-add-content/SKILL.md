---
name: rms-add-content
description: Use when you add or change content in the RMS guide site (Wayback page, hand-written static page, category, NPC mapping, LEECH data). 新增或修改 RMS 攻略庫內容：Wayback 頁、手寫靜態頁（論壇翻譯）、新分類、NPC 對照、LEECH 資料。
---

# RMS-ADD-CONTENT

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

適用範圍：MapleRoyals 攻略庫建置 repo `louis70109/rms-data-build`（私人）。檔名與指令都相對於該 repo。
Scope: the `louis70109/rms-data-build` repo (private). Paths and commands are relative to it.

先讀 `AGENTS.md` 第 4～10 節。ID 的驗證見 `rms-verify-game-data`。

## A. 新增 Wayback 存檔頁

密碼保護頁不可抓，也不可繞過。

1. 執行 `python -I fetch_wayback_page.py <slug> "<原始網址>"`。
2. 在 `build_spa.py` 的 `PAGES` 加 `("<slug>", "<分類>", "<標題>")`。
3. 新分類必須同時加入 JS 的 `ORDER` 與 `DESC`。
4. 建置。
5. 執行 `python -I download_images.py --parallel 8`。
6. 再建置一次。
7. 依 `rms-release` 檢查與發佈。

## B. 新增手寫靜態頁（論壇文章中文整理）

1. 用 `curl --compressed` 取得主樓與回覆。不加 `--compressed` 會得到亂碼。
2. 把作者在回覆補充的內容整理進文章。
3. 建立 `static_<名稱>.html.part`。用繁體中文，保留作者語氣、署名與出處連結。
4. 在 `build_spa.py` 的 `PAGES` 加 slug（慣例 `static-xxx`），並在 `STATIC_PARTS` 對應片段檔。
5. 術語依站內用詞：Hyper Body 必須寫「聖火」，不寫「神聖祈禱」。
6. 靜態頁不經過 `link_items`、`link_bosses`、`link_npcs`。連結必須手動寫 `<a>`。
7. NPC 連結格式：`https://wiki.royals.ms/npcs/<id>`。

## C. NPC 連結

1. 驗證 ID（`rms-verify-game-data`）。
2. 把名稱與 ID 加入 `npc_map.json`。
3. 執行 `python -I fetch_npc_cards.py`，補圖鑑卡片與頭像。
4. 確認 `assets/npc/` 有新圖。

## D. LEECH 資料

1. 修改 `leech.json`。來源維持「出處不詳」，除非使用者提供出處。
2. 執行 `python -I fetch_leech.py`。
3. 處理所有未通過驗證的「怪物＋地圖」。

## 注意

- 新圖放在 `assets/<子資料夾>/`。新子資料夾必須加進 `publish.sh` 的 `for d in …` 清單。
- 用 Edit 工具改 `build_spa.py`。不可用含反斜線的 `sed`。
- 內容規則見 `AGENTS.md` 第 6 節。
