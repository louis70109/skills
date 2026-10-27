---
name: rms-verify-game-data
description: Use when you cite or link a game ID (NPC, monster, item, map) or cross-check data with the wiki or library API. 查證遊戲資料：NPC／怪物／道具／地圖的 wiki ID、等級、出沒地圖，以及交叉驗證與填地圖。
---

# RMS-VERIFY-GAME-DATA

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

適用範圍：MapleRoyals 攻略庫建置 repo `louis70109/rms-data-build`（私人）。檔名與指令都相對於該 repo。
Scope: the `louis70109/rms-data-build` repo (private). Paths and commands are relative to it.

**規則：** ID 必須用 API 驗證。不可憑圖示或記憶推測。曾因猜 ID 造成 37 個線上連結錯誤。

## 資料來源

| 來源 | 用途 |
|---|---|
| `https://wiki.royals.ms/api/npcs` | NPC：id、名稱、地點 |
| `https://wiki.royals.ms/api/monsters` | 怪物：id、名稱、等級、`spawnMaps` |
| `https://wiki.royals.ms/api/items` | 道具（已存成 `wiki_items.json`） |
| `https://royals-library.netlify.app/api/v1/*` | 圖書館 API |
| `https://wiki.royals.ms/npcs/<id>` | NPC 連結格式 |

- 用 `curl -fsSL --retry 3`。WebFetch 打不開 royals.ms。
- 環境網路白名單必須含 `royals.ms`、`wiki.royals.ms`、`royals-library.netlify.app`。

## 步驟

1. 取得 API JSON，存到 scratchpad。不可存進 repo。
2. 用名稱加輔助條件比對：NPC 用名稱加地點；怪物用名稱加等級；地圖看 `spawnMaps`。
3. 同名多筆時，用出沒地圖或等級挑選，並在資料檔註明。
4. 把結果寫進資料檔。
5. 重跑對應腳本：

| 資料 | 指令 |
|---|---|
| NPC | `python -I fetch_npc_cards.py` |
| LEECH | `python -I fetch_leech.py`（列出不通過的怪物＋地圖） |
| BOSS | `python -I fetch_boss_monsters.py` |
| 物品 | `python -I fetch_wiki_items.py` |

6. 建置後執行 `python -I site_query.py grep "<名稱>"`，確認連結出現在預期頁面。

## 已知陷阱

- Slimy 與 Selkie 是不同怪物。Blood Harp 不是 Bloody Harp。
- 地名的羅馬數字與大小寫必須與 API 一致（例：Ulu Estate）。
- 驗不出來的項目放進 `npc_map.json` 的 `_待確認`。不可硬連。
