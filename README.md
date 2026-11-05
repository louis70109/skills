# skills

個人用的 AI coding agent 規範與 skills 集合。適用 OpenCode、Claude Code、Codex 等讀取 `AGENTS.md` 與 `SKILL.md` 的工具。

## 功用

- `AGENTS.md`：路由表。依任務情境決定要套用哪些 skill，每個任務先套用 `ste-zh`。
- `skills/`：各個 skill。每個 skill 一個資料夾，內含 `SKILL.md`。
- `SECURITY-CHECKLIST.md`：發布程式碼前的安全檢查清單。
- `upstream.json` 與 `.github/workflows/upstream-sync.yml`：追蹤上游 skill。每週日自動檢查，有更新時開 PR 或 issue（需人工審查後合併）。

### Skills

| Skill | 用途 |
|---|---|
| `ste-zh` | 每個任務開始前使用。用台灣繁體中文或清楚的技術英文，簡短、不含糊。 |
| `minimal-dev` | 設計或寫程式前使用。只做最小可行的變更；含測試原則（不強制 TDD）與「Don't make me think too much」。 |
| `frontend-dev` | 前端開發與審查。優先順序：UX、畫面流暢、一致性、效率。 |
| `backend-dev` | 後端開發與審查。優先順序：彈性、擴充性、效率；含 DDD 建模。 |
| `review-code` | 審查變更或自我檢查。涵蓋可用性、彈性、維護性、可觀測性、CVE。 |
| `cve-check` | 新增、更新、發布依賴前，掃描 lockfile 的已知漏洞。 |
| `prometheus-guide` | 建立或修改後端服務時，設定 Prometheus metrics。 |
| `loki-logging` | 建立或修改 logger 時，讓 log 符合 Loki 設計。 |
| `ux-error-messages` | 使用者看得到的錯誤、警告訊息的寫法。 |
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
apm install -g --target agent-skills,codex louis70109/skills/skills/ste-zh louis70109/skills/skills/minimal-dev louis70109/skills/skills/frontend-dev louis70109/skills/skills/backend-dev louis70109/skills/skills/review-code louis70109/skills/skills/cve-check louis70109/skills/skills/prometheus-guide louis70109/skills/skills/loki-logging louis70109/skills/skills/ux-error-messages
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

### 3. 啟用路由表

skill 裝好後，還要讓 agent 讀到路由表。把本 repo 的 `AGENTS.md` 放進你的專案根目錄（或全域設定）。Claude Code 用 `CLAUDE.md` 寫一行 `@AGENTS.md` 引用即可。

### 更新與移除

```bash
apm update -g --target agent-skills,codex
apm uninstall -g --target agent-skills,codex louis70109/skills/skills/minimal-dev
```

若要固定版本，在路徑後加 `#<tag 或 commit>`，例如 `louis70109/skills/skills/minimal-dev#<commit>`。不固定時，`apm update -g` 會取最新的 `main`。

**一定要加 `--target agent-skills,codex`**。不加的話，APM 會自動偵測到 `~/.claude`，嘗試部署到 Claude，而 `~/.claude/skills` 是指向 dotfiles 的符號連結，安裝會失敗。

## 外部 skill

`taste-skill` 來自 [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill)。體積大（約 39 MB）且含會啟動瀏覽器的腳本，所以不放進此 repo。固定在審查過的 commit 安裝：

```
apm install -g --target agent-skills,codex "Leonxlnx/taste-skill/skills/taste-skill#f578e23218be09ffd5b70debbfdec9fe8286d310"
```

安裝後資料夾為 `taste-skill`。需要 Node 22 以上與 Chrome、Edge 或 Chromium（上游說明）。它的腳本會啟動瀏覽器並對外抓取資料，使用前請自行檢視。

升級時先把上方 commit 改為新值（經過審查後），再重新執行同一行指令。

## 驗證狀態

- macOS：已用 APM 0.35.0 完成遷移。9 個 skill 與 `taste-skill` 都經 APM 全域安裝，內容與本 repo 一致。
- Windows：安裝步驟依 APM 官方文件整理，路徑與指令尚未在 Windows 實測。
- Codex：安裝成功（與 OpenCode 共用 `~/.agents/skills`）。本機沒有 Codex CLI，尚未確認 Codex 實際讀取。
- Claude Code：目前不支援全域安裝，因為 `~/.claude/skills` 是符號連結。見上方說明。
