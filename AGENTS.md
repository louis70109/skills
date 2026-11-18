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
| 8 | You design, build, redesign, or review a web page, landing page, dashboard, or app screen 設計、建立、改版或審查網頁、landing page、dashboard、App 畫面 | `taste-skill` (external skill, see Upstream skills) |
| 9 | You build, change, or review frontend code (UI, components, styles, client state, client performance) 開發、修改或審查前端程式碼（UI、元件、樣式、client 狀態、前端效能） | `skills/frontend-dev/SKILL.md` |
| 10 | You build, change, or review backend code (API, service logic, database, jobs, integrations) 開發、修改或審查後端程式碼（API、服務邏輯、資料庫、背景工作、整合） | `skills/backend-dev/SKILL.md` |

If no row matches, apply row 0 only. If you are not sure, apply the row. 沒有符合的列時只套用第 0 列；不確定時就套用。

## Recheck skills during a task 任務途中重新檢查 skills

Recheck the skill catalog when a new phase starts, the task scope changes, or a new technical need appears.
Read and apply all additional applicable skills. Keep existing rules that still apply, then continue the task.

開始新階段、任務範圍改變，或發現新的技術需求時，重新檢查技能目錄。讀取所有新增且適用的 Skills，保留仍適用的既有規則，再繼續任務。

## Main agent roles and dispatch 主 agent 職責與派工

The main agent owns Router and Controller duties. It assigns implementation work and keeps final acceptance authority.
These are responsibilities, not separate agents by default. Model means domain and data logic, not the language model.
主 agent 負責 Router 與 Controller，明確分配實作工作，並保留最終驗收責任。
以下是職責劃分，不要求每個角色都建立獨立 agent。Model 指業務與資料邏輯，不是語言模型。

| Role 角色 | Owner 負責者 | Responsibility 職責 |
|---|---|---|
| Router | Main agent 主 agent | Match the task against every routing row and select all applicable skills. 比對所有路由列，選出全部適用的 skills。 |
| Middleware | Main agent and each worker 主 agent 與每個執行者 | Apply matching shared rules, such as language, logging, and dependency checks. Do not create an agent for each rule. 套用符合情境的語言、logging、依賴檢查等共通規則；不為每條規則建立 agent。 |
| Controller | Main agent 主 agent | Split tasks, define interfaces and dependencies, assign owners, and verify and integrate results. 拆解任務、定義介面與相依關係、指派負責者，並驗收、整合結果。 |
| Model | Assigned implementer 指定的實作者 | Implement domain rules, data access, and related tests within the assigned scope. 在指定範圍實作業務規則、資料存取與相關測試。 |
| View | Assigned presenter 指定的呈現者 | Build UI or present results using agreed interfaces. Keep domain rules in Model. 依約定介面實作 UI 或呈現結果，業務規則由 Model 負責。 |

### Dispatch rules 派工規則

1. Before execution, the Controller lists each task's role, owner, dependencies, inputs, expected outputs, and acceptance criteria. Include applicable skill paths and allowed file scope. The main agent may own a task, but must name its role.
   執行前，Controller 列出每項任務的角色、負責者、相依關係、輸入、預期產物與驗收條件，並指定 skill 路徑與可修改範圍。主 agent 可自行執行，但須標明當下角色。
2. Delegate independent Model or View tasks with clear ownership when the host supports subagents and applicable permissions allow delegation. Otherwise, the main agent executes them and states the reason. Use the handoff rules below for every delegation.
   宿主支援 subagent，且適用權限允許委派時，將可獨立處理、權責清楚的 Model 或 View 任務交給 subagent。其餘由主 agent 執行並說明原因；每次委派都遵守下方交接規則。
3. Run tasks in parallel only when they are independent and their write scopes do not overlap. Run dependent tasks or tasks that modify the same files in sequence.
   只有彼此獨立且修改範圍不重疊的任務可並行。有相依關係或修改同一檔案的任務，必須依序執行。
4. Before dispatch, attach applicable Middleware requirements to each task. Check them at acceptance. If a check fails, the Controller returns the task and failure evidence to its owner for correction.
   派工前，為每項任務附上適用的 Middleware 要求，並在驗收時檢查。檢查未通過時，Controller 將任務與失敗證據交回負責者修正。
5. The Controller verifies returned evidence before integrating results. A subagent report alone does not establish that acceptance criteria passed. View work may use agreed interfaces before implementation finishes; final reporting must use accepted results.
   Controller 驗證回報證據後，才整合結果。不可只憑 subagent 的完成回報，就認定驗收通過。View 可先依約定介面開發；最終報告必須使用已驗收的結果。

## Subagent delegation and handoff Subagent 委派與交接

1. When delegating, provide the task objective, assigned role, inputs, expected outputs, dependencies, and allowed file scope. Include applicable skill paths, constraints, and acceptance criteria.
   委派任務時，交代任務目標、指定角色、輸入、預期產物、相依關係、可修改的檔案範圍、適用 skill 路徑、限制與驗收條件。
2. Before starting work, the subagent must read this `AGENTS.md` and every applicable skill. Do not assume it receives the parent agent's conversation or previously loaded skills.
   Subagent 開始工作前，必須讀取本 `AGENTS.md` 與所有適用的 skill。不可假設它已收到主 agent 的對話或已載入的 skills。
3. During execution, follow [Recheck skills during a task](#recheck-skills-during-a-task-任務途中重新檢查-skills).
   執行途中，遵守上方「任務途中重新檢查 skills」規則。
4. On completion, report changes, verification results, and unfinished work. The parent agent reviews and integrates the results.
   完成後，回報變更、驗證結果與未完成事項。主 agent 負責檢查並整合結果。

## After context compaction 上下文壓縮後

After a context compaction or at the start of a new session, read this table again. Then read again each skill that the current task needs. Do not work from a summary of a skill.
上下文被壓縮後，或新 session 開始時，必須重新讀取本表，並重讀目前任務需要的每個 skill。不可只憑 skill 的摘要工作。

### Compaction limit 壓縮門檻

Keep auto-compaction on. The limit is **75% of the context window by default**. You may lower it to **60%** for a task. Never go above 75% or below 60%. 必須開啟自動壓縮。預設在 context 視窗的 75% 觸發；依任務可調低至 60%；不可高於 75%、不可低於 60%。

| Tool 工具 | Default 預設 (75%) | Lower 調低 (60%) |
|---|---|---|
| Claude Code | `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=75` in `env` of `~/.claude/settings.json` | Run `/compact` by hand at about 60%, or start with a lower `--autocompact` value |
| Codex | `model_auto_compact_token_limit = 204000` in `~/.codex/config.toml` (75% of a 272,000-token window) | Add `model_post_turn_compact_threshold_percent = 60` (compacts after a final answer) |

- Do not set `DISABLE_AUTO_COMPACT`, `DISABLE_COMPACT`, or `autoCompactEnabled: false` in Claude Code. 不可在 Claude Code 關閉自動壓縮。Codex cannot turn it off. Codex 無法關閉。
- Claude Code has no range setting. The env var holds one value, so use it for the 75% default. Claude Code 沒有範圍設定，環境變數只放預設的 75%。
- For another window size, use 75% of that size. Codex has no percent setting for the token limit, so update the number when the model window changes. 其他視窗大小取該大小的 75%；Codex 的 token 門檻沒有百分比設定，模型視窗改變時要同步調整。

## Order 順序

1. Read row 0 (`ste-zh`). 讀取第 0 列。
2. Restate the task in STE. 以 STE 重述任務。
3. List the matching rows. 列出符合的列。
4. Declare roles and ownership using the dispatch rules above, then execute the task. 依上方派工規則宣告角色與負責者，再執行任務。
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
| `taste-skill` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | external | MIT, `LICENSE` in the installed folder |
| `skills/asd-ste100` | [danyuchn/asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) | sync | MIT, `skills/asd-ste100/LICENSE` |
| `skills/ste-zh` | [danyuchn/asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) | notify | MIT, `skills/ste-zh/LICENSE` |

- **sync**: an exact copy of the source. Do not edit its files. The next sync replaces them. Rules 3 and 4 above do not apply. sync：來源的完整複本。不可修改，下次同步會覆蓋。上方第 3、4 條不適用。
- **external**: not stored in this repo (it is large and has scripts). Install the pinned commit with APM (see README, "外部 skill"). Its folder is `taste-skill` and its front matter name is `design-taste-frontend`. Rules 3 and 4 above do not apply. external：不放在此 repo（體積大且含腳本）。執行 `scripts/install-external.sh` 安裝鎖定的 commit 到 `~/.agents/skills`（可用 `SKILLS_DIR` 覆寫）。第 3、4 條不適用。
- **notify**: an adaptation of the source. A person updates it by hand. notify：來源的改編版，由人工更新。
- `skills/asd-ste100` is the original of `ste-zh`. It has no routing row. Agents apply `ste-zh` (row 0). `skills/asd-ste100` 是 `ste-zh` 的原文，不列入路由表。代理套用 `ste-zh`（第 0 列）。

The workflow `.github/workflows/upstream-sync.yml` runs each Sunday. When a source changes:
工作流程 `.github/workflows/upstream-sync.yml` 每週日執行。來源有變更時：

1. For a **sync** skill, it opens one PR that copies the new files. Read the upstream diff before you merge (`SECURITY-CHECKLIST.md` section 1). sync：開一個 PR 複製新檔案。合併前必須先讀上游 diff。
2. For a **notify** skill, it opens one issue with the upstream diff. Update the skill. Then set its `commit` in `upstream.json` to the new commit. The issue stays open until you do this. notify：開一個 issue，附上游 diff。更新 skill 後，將 `upstream.json` 中的 `commit` 改為新 commit。改之前 issue 會持續存在。
3. For an **external** skill, it opens one issue. Read the upstream diff, set `commit` in `upstream.json` to the new commit, then reinstall it with APM. external：開一個 issue。讀上游 diff，將 `commit` 改為新 commit，再用 APM 重新安裝。

To add an upstream skill: copy the source and its `LICENSE`, add an entry to `upstream.json`, and add a row to the table above. 新增上游 skill：複製來源與 `LICENSE`，在 `upstream.json` 新增一筆，並在上表新增一列。
