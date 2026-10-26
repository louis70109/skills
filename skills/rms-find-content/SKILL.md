---
name: rms-find-content
description: Use when you must find where content or code lives in the RMS guide site (which page, which source file, which link rule). 查詢 RMS 攻略庫的內容與程式位置：某句話在哪一頁、某頁由哪個檔案產生、某 NPC／怪物／道具有沒有連結、某功能在 build_spa.py 哪裡。
---

# RMS-FIND-CONTENT

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

適用範圍：MapleRoyals 攻略庫建置 repo `louis70109/rms-data-build`（私人）。檔名與指令都相對於該 repo。
Scope: the `louis70109/rms-data-build` repo (private). Paths and commands are relative to it.

## 查頁面內容

`index.html` 的內容已編碼。不可用 grep 直接搜 `index.html`。

1. 若沒有 `index.html`，執行 `python -I build_spa.py "$PWD"`。
2. 執行下列其中一個指令：
   - `python -I site_query.py list`：列出全部頁面（slug、分類、字數、標題）。
   - `python -I site_query.py grep "<關鍵字>"`：列出含關鍵字的頁面。
   - `python -I site_query.py show <slug>`：印出該頁純文字。
   - `python -I site_query.py html <slug>`：印出該頁 HTML（查 class、連結）。

## 查頁面由哪個檔案產生

1. 在 `build_spa.py` 的 `PAGES` 找 slug。
2. 依頁面類型找來源：

| 類型 | 來源 |
|---|---|
| 一般頁 | `<slug>.html`（Wayback 存檔） |
| 靜態頁 | `STATIC_PARTS` 對應的 `static_*.html.part` |
| `leech-guide` | `leech_layout.py`、`leech.json` |
| `npc-gallery` | `npc_gallery.py`、`npc_cards.json` |
| `forum-en-bosses` | `boss_layout.py`、`boss_monsters.json` |
| APQ 兩篇 | `apq_layout.py`、`apq_blocks.py` |

3. 分類順序與說明在 `build_spa.py` 內 JS 的 `ORDER`、`DESC`。

## 查連結規則

| 問題 | 位置 |
|---|---|
| NPC 連到哪個 wiki ID | `npc_map.json`。同名多筆用 `名稱@slug` 覆寫。 |
| BOSS、物品為何沒連結 | `AGENTS.md` 第 8、9 節。 |
| 貓、滑動換頁、更新彈窗在哪 | 在 `build_spa.py` 搜 `catSpawn`、`swipe`、`CHANGELOG`。 |
| 線上版本是否等於本地 | 比對 `curl -s https://rms-data.fly.dev/sw.js \| head -1` 與本地 `sw.js` 的 `VERSION`。 |

## 禁止

- 不可建議把來源檔推到公開 repo。
- 不可把 CSV 放到公開網址。
