# AGENTS.md

## Required first step 強制第一步

Before any action, read and apply `skills/ste-zh/SKILL.md`.
Do this for every task. Do not skip it. Do not start work before it.

在執行任何動作之前，必須先讀取並套用 `skills/ste-zh/SKILL.md`。
每個任務都要做。不可跳過。不可先動工。

## Routing table 路由表

After the first step, find each row that matches the task. Read and apply **every** matching skill. A task can match many rows.
第一步之後，找出所有符合任務的列，並讀取、套用**每一個**符合的 skill。一個任務可以符合多列。

| # | When 情境 | Apply 套用 |
|---|---|---|
| 0 | Every task 每個任務 | `skills/ste-zh/SKILL.md` |
| 1 | You design or write code 設計或撰寫程式碼 | `skills/minimal-dev/SKILL.md` |
| 2 | You add, update, or ship Node/Python dependencies 新增、更新、發布 Node/Python 依賴 | `skills/cve-check/SKILL.md` |
| 3 | You create or change a backend service 建立或修改後端服務 | `skills/prometheus-guide/SKILL.md` |
| 4 | You create or change a logger or log output 建立或修改 logger／log 輸出 | `skills/loki-logging/SKILL.md` |
| 5 | You create or change a message that a user sees (error, warning, alert) 建立或修改使用者看到的錯誤、警告、提醒 | `skills/ux-error-messages/SKILL.md` |
| 6 | You review a code change, or you finish one 審查程式碼變更，或完成程式碼變更前 | `skills/review-code/SKILL.md` |
| 7 | You ship code 發布程式碼 | `SECURITY-CHECKLIST.md` |
| 8 | You find where content or code lives in the RMS guide repo 在 RMS 攻略庫查內容或程式位置 | `skills/rms-find-content/SKILL.md` |
| 9 | You add or change RMS guide content (page, static page, category, NPC map, LEECH) 新增或修改 RMS 攻略庫內容 | `skills/rms-add-content/SKILL.md` |
| 10 | You cite or link a game ID (NPC, monster, item, map), or cross-check game data 引用、連結或交叉驗證遊戲資料 ID | `skills/rms-verify-game-data/SKILL.md` |
| 11 | You change CSS, JS, or the Service Worker of the RMS guide site 修改 RMS 攻略庫的 CSS／JS／Service Worker | `skills/rms-frontend-pitfalls/SKILL.md` |
| 12 | You ship the RMS guide site or its desktop app 發佈 RMS 攻略庫網站或桌面版 | `skills/rms-release/SKILL.md`, `SECURITY-CHECKLIST.md` |
| 13 | You design, build, redesign, or review a web page, landing page, dashboard, or app screen 設計、建立、改版或審查網頁、landing page、dashboard、App 畫面 | `skills/taste-skill/SKILL.md` |

If no row matches, apply row 0 only. If you are not sure, apply the row. 沒有符合的列時只套用第 0 列；不確定時就套用。

## After context compaction 上下文壓縮後

After a context compaction or at the start of a new session, read this table again. Then read again each skill that the current task needs. Do not work from a summary of a skill.
上下文被壓縮後，或新 session 開始時，必須重新讀取本表，並重讀目前任務需要的每個 skill。不可只憑 skill 的摘要工作。

## Order 順序

1. Read row 0 (`ste-zh`). 讀取第 0 列。
2. Restate the task in STE. 以 STE 重述任務。
3. List the matching rows. 列出符合的列。
4. Do the task. 執行任務。
5. Check the output against each matching skill. 對照每個符合的 skill 檢查輸出。

## Add a new skill 新增 skill

Follow these rules for each new skill. 新增 skill 時必須遵守：

1. **Read** this table first. Do not repeat a rule that another skill has. Link to that skill. 先讀本表；不重複其他 skill 已有的規則，改為連結。
2. **Add a row** to the table in the same change. A skill without a row is not valid. Write a clear "When" that an agent can match. 同一次變更中新增一列；未登記的 skill 無效；「情境」必須清楚到 agent 能比對。
3. **Put** the skill at `skills/<name>/SKILL.md`. The front matter needs `name` and `description`. The `description` says when to use it, in EN and ZH. 放在 `skills/<name>/SKILL.md`;front matter 需有 `name` 與中英文 `description`（說明何時使用）。
4. **Start** the skill body with: "Write in STE. See `ste-zh`." 內文開頭加：「Write in STE. See `ste-zh`.」
5. **Keep** it short. Apply `skills/minimal-dev/SKILL.md` to the skill itself. 保持精簡，skill 本身也套用 minimal-dev。
6. **Check** if an existing row, `review-code`, or `SECURITY-CHECKLIST.md` must link to the new skill. Update them. 檢查是否需讓既有列、`review-code`、`SECURITY-CHECKLIST.md` 連結新 skill,並一併更新。
7. **Commit** the skill and the table change together. 新 skill 與表格變更同一個 commit。

## Upstream skills 上游 skill

Some skills come from another repo. `upstream.json` lists each one, its source, the pinned commit, and the mode.
部分 skill 來自其他 repo。`upstream.json` 列出每個 skill、來源、鎖定的 commit 與模式。

| Skill | Source 來源 | Mode 模式 | License 授權 |
|---|---|---|---|
| `skills/taste-skill` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | sync | MIT, `skills/taste-skill/LICENSE` |
| `skills/asd-ste100` | [danyuchn/asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) | sync | MIT, `skills/asd-ste100/LICENSE` |
| `skills/ste-zh` | [danyuchn/asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) | notify | MIT, `skills/ste-zh/LICENSE` |

- **sync**: an exact copy of the source. Do not edit its files. The next sync replaces them. Rules 3 and 4 above do not apply. sync：來源的完整複本。不可修改，下次同步會覆蓋。上方第 3、4 條不適用。
- **notify**: an adaptation of the source. A person updates it by hand. notify：來源的改編版，由人工更新。
- `skills/asd-ste100` is the original of `ste-zh`. It has no routing row. Agents apply `ste-zh` (row 0). `skills/asd-ste100` 是 `ste-zh` 的原文，不列入路由表。代理套用 `ste-zh`（第 0 列）。

The workflow `.github/workflows/upstream-sync.yml` runs each Monday. When a source changes:
工作流程 `.github/workflows/upstream-sync.yml` 每週一執行。來源有變更時：

1. For a **sync** skill, it opens one PR that copies the new files. Read the upstream diff before you merge (`SECURITY-CHECKLIST.md` section 1). sync：開一個 PR 複製新檔案。合併前必須先讀上游 diff。
2. For a **notify** skill, it opens one issue with the upstream diff. Update the skill. Then set its `commit` in `upstream.json` to the new commit. The issue stays open until you do this. notify：開一個 issue，附上游 diff。更新 skill 後，將 `upstream.json` 中的 `commit` 改為新 commit。改之前 issue 會持續存在。

To add an upstream skill: copy the source and its `LICENSE`, add an entry to `upstream.json`, and add a row to the table above. 新增上游 skill：複製來源與 `LICENSE`，在 `upstream.json` 新增一筆，並在上表新增一列。
