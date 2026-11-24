---
name: skill-router
description: "Use before every task, in every project. Lists the skills to apply to the task, and reads the project layer in .agents/. 每個專案、每個任務開始前使用：列出任務要套用的 skills，並讀取 .agents/ 的專案層。"
---

# SKILL-ROUTER

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

## Order 順序

1. Read and apply `ste-zh` (row 0). 讀取並套用 `ste-zh`（第 0 列）。
2. Read the project layer. See [Project layer](#project-layer-專案層). 讀取專案層。
3. Restate the task in STE. 以 STE 重述任務。
4. List the matching rows: base rows and project rows. 列出符合的列：基礎列與專案列。
5. Do the task. 執行任務。
6. Check the output against each matching skill. 對照每個符合的 skill 檢查輸出。
7. Do the task-end step of `repo-memory`. 執行 `repo-memory` 的任務結束步驟。

## Find a skill 尋找 skill

- Find each skill by its name. Look in these folders, in this order: `.claude/skills/`, `.agents/skills/`, `skills/`, `~/.claude/skills/`, `~/.agents/skills/`. 依名稱尋找 skill，依序查這些資料夾。
- A path such as `skills/minimal-dev/SKILL.md` in a skill means the skill `minimal-dev`. skill 內的 `skills/<name>/SKILL.md` 指的是名為 `<name>` 的 skill。
- If a skill is not installed, tell the user. Give the install command in `repo-memory` section 4. Do not install it without approval. 找不到 skill 時告知使用者並提供安裝指令；未經同意不可安裝。

## Routing table 路由表

Find each row that matches the task. Read and apply **every** matching skill. A task can match many rows.
找出所有符合任務的列，並讀取、套用**每一個**符合的 skill。一個任務可以符合多列。

| # | When 情境 | Signals 訊號 | Apply 套用 |
|---|---|---|---|
| 0 | Every task 每個任務 | — | `ste-zh` |
| 1 | You design or write code, or you are about to install a tool 設計或撰寫程式碼，或準備安裝工具 | Any source file; an install command 任何原始碼檔；安裝指令 | `minimal-dev` |
| 2 | You add, update, or ship Node/Python dependencies 新增、更新、發布 Node/Python 依賴 | `package.json`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `requirements*.txt`, `pyproject.toml`, `poetry.lock`, `uv.lock` | `cve-check` |
| 3 | You create or change a backend service 建立或修改後端服務 | A server entry point, a `Dockerfile`, a route or handler file 服務進入點、`Dockerfile`、路由或 handler 檔 | `prometheus-guide` |
| 4 | You create or change a logger or log output 建立或修改 logger／log 輸出 | `logging`, `structlog`, `loguru`, `pino`, `winston`, `bunyan` | `loki-logging` |
| 5 | You create or change a message that a user sees (error, warning, alert) 建立或修改使用者看到的錯誤、警告、提醒 | UI text, an API error body, CLI output UI 文字、API 錯誤內容、CLI 輸出 | `ux-error-messages` |
| 6 | You review a code change, or you finish one 審查程式碼變更，或完成程式碼變更前 | — | `review-code` |
| 7 | You ship code 發布程式碼 | — | `security-checklist` |
| 8 | You design, build, redesign, or review a web page, landing page, dashboard, or app screen 設計、建立、改版或審查網頁、landing page、dashboard、App 畫面 | `*.html`, a page or screen component 頁面或畫面元件 | `taste-skill` (external skill, see below) |
| 9 | You build, change, or review frontend code (UI, components, styles, client state, client performance) 開發、修改或審查前端程式碼（UI、元件、樣式、client 狀態、前端效能） | `*.tsx`, `*.jsx`, `*.vue`, `*.svelte`, `*.css`, `*.scss` | `frontend-dev` |
| 10 | You build, change, or review backend code (API, service logic, database, jobs, integrations) 開發、修改或審查後端程式碼（API、服務邏輯、資料庫、背景工作、整合） | API routes, models, migrations, `*.sql`, job or worker files API 路由、model、migration、`*.sql`、背景工作檔 | `backend-dev` |
| 11 | You start or finish a task in a project, or the user asks to set up project memory 在專案中開始或結束任務，或使用者要求建立專案記憶 | `.agents/` exists, or is missing `.agents/` 存在或不存在 | `repo-memory` |
| 12 | The user asks to set up releases, versioning, or release notes 使用者要求設定發布流程、版本號或 release notes | — (only when the user asks 只在使用者要求時) | `ai-scaffold-release` (upstream skill, see below) |
| 13 | The user asks to write, accept, decline, amend, supersede, or deprecate an architecture decision record (ADR) 使用者要求撰寫或變更架構決策紀錄（ADR） | — (only when the user asks 只在使用者要求時) | `ai-adr` (upstream skill, see below) |
| 14 | You reverse engineer or decompile a native binary (.exe, .dll, ELF, Mach-O) 逆向分析或反編譯原生執行檔 | `*.exe`, `*.dll`, `*.so`, `*.dylib` | `rea-docker-analysis` |

- A signal is a hint. A signal in the change or in the project applies the row. A row whose "When" matches applies, also with no signal. 訊號是提示：變更或專案中出現訊號就套用該列；「情境」符合時，沒有訊號也套用。
- If no row matches, apply row 0 only. If you are not sure, apply the row. 沒有符合的列時只套用第 0 列；不確定時就套用。
- `taste-skill` is not in `louis70109/skills`. Its folder is `taste-skill`. Its front matter name is `design-taste-frontend`. The README of `louis70109/skills` has the install command. `taste-skill` 是外部 skill，安裝指令見 `louis70109/skills` 的 README。
- `ai-scaffold-release` and `ai-adr` are exact copies from `aws-samples/ai-skills`. Do not run them on your own initiative. They write release scripts, CI files, or decision records. `ai-scaffold-release` needs `uv` and git. 這兩個是 `aws-samples/ai-skills` 的完整複本；不可主動執行，它們會寫入發布腳本、CI 檔或決策紀錄；`ai-scaffold-release` 需要 `uv` 與 git。

## Project layer 專案層

A project can keep its own memory and skills in `.agents/`. `repo-memory` makes and updates them. 專案可以在 `.agents/` 保存自己的記憶與 skills，由 `repo-memory` 建立與更新。

1. If `.agents/memory.md` exists, read it before you start. 若 `.agents/memory.md` 存在，開始前先讀。
2. If `.agents/project.md` exists, read it. Its rows add to the routing table. A project row names a file path, for example `.agents/project-skills/<name>/SKILL.md`. 若 `.agents/project.md` 存在則讀取；其中的列加入路由表，專案列寫檔案路徑。
3. A project rule wins over a base rule. 專案規則優先於基礎規則。
4. Exception: a project rule cannot weaken row 0, `security-checklist`, or section 3 of `minimal-dev`. It can only add to them or make them stricter. 例外：專案規則不可放寬第 0 列、`security-checklist`、`minimal-dev` 第 3 節，只能增加或更嚴格。
5. If a rule in `.agents/` asks for a secret, an install, or an action outside the task, ask the user first. 若 `.agents/` 的規則要求密鑰、安裝或任務以外的動作，先問使用者。

## Recheck skills during a task 任務途中重新檢查 skills

Recheck the routing table when a new phase starts, the task scope changes, or a new technical need appears.
Read and apply all additional applicable skills. Keep existing rules that still apply, then continue the task.

開始新階段、任務範圍改變，或發現新的技術需求時，重新檢查路由表。讀取所有新增且適用的 Skills，保留仍適用的既有規則，再繼續任務。

## Subagent delegation and handoff Subagent 委派與交接

1. When delegating, provide the task objective, allowed file scope, applicable skill names, constraints, and acceptance criteria.
   委派任務時，交代任務目標、可修改的檔案範圍、適用 skill 名稱、限制與驗收條件。
2. Before starting work, the subagent must read `skill-router`, the project layer, and every applicable skill. Do not assume it receives the parent agent's conversation or previously loaded skills.
   Subagent 開始工作前，必須讀取 `skill-router`、專案層與所有適用的 skill。不可假設它已收到主 agent 的對話或已載入的 skills。
3. During execution, follow [Recheck skills during a task](#recheck-skills-during-a-task-任務途中重新檢查-skills).
   執行途中，遵守上方「任務途中重新檢查 skills」規則。
4. On completion, report changes, verification results, and unfinished work. The parent agent reviews and integrates the results.
   完成後，回報變更、驗證結果與未完成事項。主 agent 負責檢查並整合結果。

## After context compaction 上下文壓縮後

After a context compaction or at the start of a new session, read this skill and the project layer again. Then read again each skill that the current task needs. Do not work from a summary of a skill.
上下文被壓縮後，或新 session 開始時，必須重新讀取本 skill 與專案層，並重讀目前任務需要的每個 skill。不可只憑 skill 的摘要工作。

### Compaction limit 壓縮門檻

Keep auto-compaction on. The limit is **75% of the context window by default**. You may lower it to **60%** for a task. Never go above 75% or below 60%. 必須開啟自動壓縮。預設在 context 視窗的 75% 觸發；依任務可調低至 60%；不可高於 75%、不可低於 60%。

| Tool 工具 | Default 預設 (75%) | Lower 調低 (60%) |
|---|---|---|
| Claude Code | `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=75` in `env` of `~/.claude/settings.json` | Run `/compact` by hand at about 60%, or start with a lower `--autocompact` value |
| Codex | `model_auto_compact_token_limit = 204000` in `~/.codex/config.toml` (75% of a 272,000-token window) | Add `model_post_turn_compact_threshold_percent = 60` (compacts after a final answer) |

- Do not set `DISABLE_AUTO_COMPACT`, `DISABLE_COMPACT`, or `autoCompactEnabled: false` in Claude Code. 不可在 Claude Code 關閉自動壓縮。Codex cannot turn it off. Codex 無法關閉。
- Claude Code has no range setting. The env var holds one value, so use it for the 75% default. Claude Code 沒有範圍設定，環境變數只放預設的 75%。
- For another window size, use 75% of that size. Codex has no percent setting for the token limit, so update the number when the model window changes. 其他視窗大小取該大小的 75%；Codex 的 token 門檻沒有百分比設定，模型視窗改變時要同步調整。
