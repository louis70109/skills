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
