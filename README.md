# skills

個人用的 AI coding agent 規範與 skills 集合。適用 OpenCode、Claude Code、Codex 等讀取 `AGENTS.md` 與 `SKILL.md` 的工具。

## 功用

- `AGENTS.md`：一個標記區塊，指示 agent 先讀 `skill-router`。另含本 repo 的維護規則。
- `skills/`：各個 skill。每個 skill 一個資料夾，內含 `SKILL.md`。路由表在 `skills/skill-router/SKILL.md`。
- 專案層：每個專案在 `.agents/` 保存自己的記憶與 skills。見下方「專案層」。
- `upstream.json` 與 `.github/workflows/upstream-sync.yml`：追蹤上游 skill。每週日自動檢查，有更新時開 PR 或 issue（需人工審查後合併）。

### Skills

| Skill | 用途 |
|---|---|
| `ste-zh` | 每個任務開始前使用。用台灣繁體中文或清楚的技術英文，簡短、不含糊。 |
| `skill-router` | 每個任務開始前使用。路由表：依情境與訊號決定要套用哪些 skill，並讀取專案層。 |
| `repo-memory` | 在專案中開始或結束任務時使用。建立與更新 `.agents/` 的專案記憶與專案 skills。 |
| `minimal-dev` | 設計或寫程式前使用。只做最小可行的變更；含測試原則（不強制 TDD）、「Don't make me think too much」與工具規則（先用 bash 與已安裝的工具，不為單一任務安裝工具）。 |
| `frontend-dev` | 前端開發與審查。優先順序：UX、畫面流暢、一致性、效率。 |
| `backend-dev` | 後端開發與審查。優先順序：彈性、擴充性、效率；含 DDD 建模。 |
| `review-code` | 審查變更或自我檢查。涵蓋可用性、彈性、維護性、可觀測性、CVE。 |
| `cve-check` | 新增、更新、發布依賴前，掃描 lockfile 的已知漏洞。Python lockfile 用附帶的 bash 腳本（只需要 `curl`）查詢 OSV。 |
| `prometheus-guide` | 建立或修改後端服務時，設定 Prometheus metrics。 |
| `loki-logging` | 建立或修改 logger 時，讓 log 符合 Loki 設計。 |
| `ux-error-messages` | 使用者看得到的錯誤、警告訊息的寫法。 |
| `security-checklist` | 發布程式碼前的安全檢查清單。 |
| `ai-scaffold-release` | 上游 skill（`aws-samples/ai-skills`，sync）。設定發布流程：依 Conventional Commits 推算版本號、git-cliff、release 腳本與 CI。只在使用者要求時執行，需要 `uv`。 |
| `ai-adr` | 上游 skill（`aws-samples/ai-skills`，sync）。維護架構決策紀錄（ADR）。只在使用者要求時執行。 |
| `rea-docker-analysis` | 逆向分析或反編譯 .exe、.dll 等原生執行檔。在隔離的 Docker 容器內用 REA + Ghidra 做靜態分析。需要 Docker。 |
| `asd-ste100` | `ste-zh` 的上游原文（英文 ASD-STE100）。沒有路由，不需要安裝。 |
| `taste-skill` | 外部 skill，不在此 repo。網頁與 landing page 的視覺設計（SKILL.md 內 name 為 `design-taste-frontend`）。見下方「外部 skill」。 |

## 安裝

用 [APM（Agent Package Manager）](https://github.com/microsoft/apm) 安裝，macOS 與 Windows 指令相同。

### 1. 安裝 Git 與 APM

macOS：

```bash
brew install git apm
apm --version
```

Windows（PowerShell）：

```powershell
winget install --id Git.Git --exact
winget install --id Microsoft.APM --exact --source winget
apm --version
```

沒有 winget 時，APM 可改用：`irm https://aka.ms/apm-windows | iex`。安裝後重新開啟終端機。

### 2. 安裝 skills

macOS 與 Windows 都執行同一行（整行貼上）：

```
apm install -g --target agent-skills,codex louis70109/skills/skills/ste-zh louis70109/skills/skills/skill-router louis70109/skills/skills/repo-memory louis70109/skills/skills/security-checklist louis70109/skills/skills/minimal-dev louis70109/skills/skills/frontend-dev louis70109/skills/skills/backend-dev louis70109/skills/skills/review-code louis70109/skills/skills/cve-check louis70109/skills/skills/prometheus-guide louis70109/skills/skills/loki-logging louis70109/skills/skills/ux-error-messages louis70109/skills/skills/ai-scaffold-release louis70109/skills/skills/ai-adr louis70109/skills/skills/rea-docker-analysis
```

只裝其中幾個時，保留需要的項目即可。

安裝位置：

| 系統 | 路徑 |
|---|---|
| macOS | `~/.agents/skills/` |
| Windows | `%USERPROFILE%\.agents\skills\` |

確認結果：

```bash
ls ~/.agents/skills            # macOS
dir $env:USERPROFILE\.agents\skills   # Windows PowerShell
```

### 3. Claude Code（每個專案各裝一次）

Claude Code 的全域 skill 目錄（`~/.claude/skills`）在這台機器是符號連結，APM 不會透過符號連結部署，所以全域安裝會失敗。改在專案內安裝，產生專案內的 `.claude/skills/`：

```
cd /path/to/your-project
apm install --target claude louis70109/skills/skills/ste-zh louis70109/skills/skills/skill-router louis70109/skills/skills/repo-memory louis70109/skills/skills/security-checklist louis70109/skills/skills/minimal-dev louis70109/skills/skills/frontend-dev louis70109/skills/skills/backend-dev louis70109/skills/skills/review-code louis70109/skills/skills/cve-check louis70109/skills/skills/prometheus-guide louis70109/skills/skills/loki-logging louis70109/skills/skills/ux-error-messages louis70109/skills/skills/ai-scaffold-release louis70109/skills/skills/ai-adr louis70109/skills/skills/rea-docker-analysis "Leonxlnx/taste-skill/skills/taste-skill#b900a8075fd7a2449bd6f414a2ae79657e95363c"
```

會在專案產生 `apm.yml`、`apm.lock.yaml`、`.claude/skills/`，並在 `.gitignore` 加入 `apm_modules/`。要不要 commit 由你決定。更新時在專案內執行 `apm update --target claude`。

### 4. 讓每個專案自動套用（每台電腦一次）

把下方區塊貼到各工具的全域指示檔。之後在任何專案開啟 agent，它都會先讀 `skill-router`。

| 工具 | 全域指示檔 |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| OpenCode | `~/.config/opencode/AGENTS.md`（這個檔案不存在時，OpenCode 會改讀 `~/.claude/CLAUDE.md`） |

```md
<!-- louis70109/skills:start -->
## Skills
Before any action, read and apply the skill `skill-router`.
Find it at `<folder>/skill-router/SKILL.md`. Look in `.claude/skills/`, `.agents/skills/`, `skills/`, `~/.claude/skills/`, and `~/.agents/skills/`.
If you cannot find it, tell the user.
<!-- louis70109/skills:end -->
```

這個區塊與本 repo 的 `AGENTS.md`、`repo-memory` 第 5 節相同。Claude Code 的全域 skill 目錄不能用時，它會依區塊中的路徑讀取 `~/.agents/skills/`。

### 5. 建立專案層（每個專案一次）

在專案中請 agent 執行 `repo-memory init`。agent 發現專案沒有 `.agents/` 時，也會主動提議。`init` 會：

1. 讀取專案程式碼，依 `skill-router` 的訊號欄列出需要的 skill，並提供 `apm install` 指令。
2. 建立 `.agents/memory.md`。
3. 在專案的 `AGENTS.md` 插入上方區塊。其他內容不動。
4. 確認 `CLAUDE.md` 有 `@AGENTS.md`。

變更會先給你審查，再 commit。區塊寫進專案後，隊友與 CI 不需要全域設定也能讀到。

### 更新與移除

```bash
apm update -g --target agent-skills,codex
apm uninstall -g --target agent-skills,codex louis70109/skills/skills/minimal-dev
```

若要固定版本，在路徑後加 `#<tag 或 commit>`，例如 `louis70109/skills/skills/minimal-dev#<commit>`。不固定時，`apm update -g` 會取最新的 `main`。

**一定要加 `--target agent-skills,codex`**。不加的話，APM 會自動偵測到 `~/.claude`，嘗試部署到 Claude，而 `~/.claude/skills` 是指向 dotfiles 的符號連結，安裝會失敗。

## 專案層

```
your-project/
├── AGENTS.md          # 只插入標記區塊，其他內容是專案自己的
├── CLAUDE.md          # 含 @AGENTS.md
└── .agents/
    ├── memory.md      # 專案記憶：事實、決策、曾犯的錯、缺口
    ├── project.md     # 專案路由列與規則（第一條規則獲得同意後才建立）
    └── project-skills/<name>/SKILL.md
```

| 動作 | 方式 |
|---|---|
| 依任務選 skill、讀專案記憶 | 自動，每個任務 |
| 任務結束時更新記憶 | 自動，寫進當次任務的變更，隨變更審查 |
| 發現專案沒有 `.agents/`，提議 `init` | 自動提議，你同意後才執行 |
| 安裝缺少的 skill | agent 提供指令，你同意後才執行 |
| 新增專案規則或專案 skill | 同一錯誤有 3 個證據時提議，你同意後才寫入 |

規則優先順序：專案規則優先於基礎規則。例外是專案規則不能放寬 `ste-zh`、`security-checklist` 與 `minimal-dev` 第 3 節。

這些行為依靠 agent 遵守文字指示，不是強制機制，agent 仍可能漏做。

## 外部 skill

`taste-skill` 來自 [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill)。體積大（約 39 MB）且含會啟動瀏覽器的腳本，所以不放進此 repo。固定在審查過的 commit 安裝：

```
apm install -g --target agent-skills,codex "Leonxlnx/taste-skill/skills/taste-skill#b900a8075fd7a2449bd6f414a2ae79657e95363c"
```

安裝後資料夾為 `taste-skill`。需要 Node 22 以上與 Chrome、Edge 或 Chromium（上游說明）。它的腳本會啟動瀏覽器並對外抓取資料，使用前請自行檢視。

升級時先把上方 commit 改為新值（經過審查後），再重新執行同一行指令。

## 驗證狀態

- macOS：已用 APM 0.35.0 完成遷移。9 個 skill 與 `taste-skill` 都經 APM 全域安裝，內容與本 repo 一致。
- Windows：安裝步驟依 APM 官方文件整理，路徑與指令尚未在 Windows 實測。
- Codex：安裝成功（與 OpenCode 共用 `~/.agents/skills`）。本機沒有 Codex CLI，尚未確認 Codex 實際讀取。
- `skill-router`、`repo-memory`、專案層：尚未在真實專案實測。
- Claude Code：全域安裝不支援（`~/.claude/skills` 是符號連結）。改為每個專案安裝，見步驟 3。在暫存專案實測通過。
