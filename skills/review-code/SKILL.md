---
name: review-code
description: Use when you review a code change (diff, PR, or file) or check your own change before you finish. Check usability, resilience, maintainability, observability, and CVE. 審查程式碼變更（diff、PR、檔案）或完成前自我檢查時使用：檢查可用性、彈性、維護性、可觀測性與 CVE。
---

# REVIEW-CODE

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

## Workflow 流程

1. **Read** the diff and its purpose. State the purpose in one sentence. 讀 diff 與目的，以一句話重述。
2. **Check** each area in sections 1–6. Skip an area only if it does not apply. 逐項檢查，不適用才略過。
3. **Run** the tests, the linter, and `skills/cve-check/SKILL.md` if dependencies changed. 執行測試、lint;依賴有變時執行 cve-check。
4. **Report** by the format in section 7. 依第 7 節格式回報。

Review the change, not the author. Give a reason and a fix for each finding. 針對變更不針對人；每項發現都附理由與建議。

## 1. Usability 可用性

- Does the change do what the purpose says? Does it handle the empty, null, large, and wrong input? 是否達成目的？是否處理空值、極端值、錯誤輸入？
- User-facing text and errors follow `skills/ux-error-messages/SKILL.md`. 使用者可見文字與錯誤符合 ux-error-messages。
- API: names are clear, defaults are safe, errors have a stable `code`, status codes are right. API 命名清楚、預設安全、錯誤有穩定 `code`。
- A breaking change has a version bump, a migration path, and a note. 破壞性變更需有版本、遷移路徑與說明。
- Docs and `--help` text match the new behavior. 文件與說明文字與行為一致。

## 2. Availability and resilience 可用性（服務）與彈性

- Every network and disk call has a **timeout**. 每個網路／磁碟呼叫都有 timeout。
- A retry uses a limit, backoff, and jitter. A retry only runs on an **idempotent** call (or uses an idempotency key). 重試有上限、退避、抖動，且僅用於冪等呼叫。
- A failed dependency does not stop the whole service: fallback, queue, or fast failure. 依賴失效不拖垮整體：降級、佇列或快速失敗。
- Resources are bounded: pool size, queue size, memory, request size, rate limit. 資源有上限：連線池、佇列、記憶體、請求大小、限流。
- The service has health and readiness checks and a graceful shutdown (finish in-flight work, then exit). 有健康檢查、就緒檢查與優雅關閉。
- A new setting comes from config or env, with a safe default. No hard-coded URL, limit, or secret. 新設定來自 config/env 並有安全預設；不寫死 URL、上限、密鑰。
- A risky change can go out behind a flag and can roll back. Data migrations can go forward and back. 高風險變更可用 flag 控制並能回滾；資料遷移可前進可後退。
- Concurrency: no shared mutable state without a lock; no race on check-then-act. 並行：無未保護的共享可變狀態。

## 3. Maintainability 維護性

- One function = one job. One module = one reason to change. 一函式一職責。
- Names say what a thing is. No abbreviation that needs a guess. 命名清楚。
- No copy-paste. No dead code. No commented-out code. 無重複、無死碼、無註解掉的程式碼。
- Dependencies point one way. No circular import. A new dependency has a reason (see section 6). 依賴單向；新依賴要有理由。
- Comments explain **why**, not what. 註解說明「為什麼」。
- Tests cover the new behavior, the error paths, and the edge cases. A bug fix has a test that fails before the fix. 測試涵蓋新行為、錯誤路徑、邊界；修 bug 須附先失敗的測試。
- Tests are fast and do not depend on order, time, or network. 測試快速且獨立。
- The change is small enough to review. If not, ask to split it. 變更過大則要求拆分。

## 4. Observability — metrics 指標

Check against `skills/prometheus-guide/SKILL.md`. 對照 prometheus-guide:

- A new endpoint, job, or dependency call has the required metrics (count, duration, outcome). 新端點、工作、依賴呼叫都有必備指標。
- Labels have low cardinality. No user id, URL, or error text in a label. 標籤低基數。
- Metric names, units, and types follow the guide. 命名、單位、類型符合指南。
- A new failure mode has an alert or a note on why it needs none. 新的失效模式有告警，或說明為何不需要。

## 5. Observability — logs 日誌

Check against `skills/loki-logging/SKILL.md` and section B of `prometheus-guide`. 對照 loki-logging:

- One JSON line per event, on stdout. Stack is in `error.stack`. 單行 JSON、stdout、堆疊在欄位內。
- Labels are only the allowed ones. IDs are in the line, not in labels. 標籤僅限允許清單。
- Each error has `event`, `error.*`, `trace_id`, `request_id`, and enough context to debug without a re-run. 每個錯誤都有足以不重跑就能除錯的資訊。
- The level fits the impact. An expected user mistake is not `ERROR`. An error is logged one time. 層級合適；錯誤只記一次。
- **No personal data or secret** in a log, label, metric, or error text. 日誌、標籤、指標、錯誤文字皆無個資與密鑰。
- No log in a tight loop. 緊密迴圈內無逐筆 log。

## 6. Security and CVE 安全與 CVE

- Dependencies changed? Run `skills/cve-check/SKILL.md`. List each finding with package, version, ID, severity, and fixed version. 依賴有變就執行 cve-check 並列出發現。
- Is each new package needed, maintained, and spelled right (typosquatting)? Is the license OK? 新套件是否必要、持續維護、名稱正確、授權可接受？
- A lockfile is in the change. Versions are pinned. 含 lockfile 並鎖版本。
- Input is validated at the boundary. Queries are parameterized. Output is escaped. 邊界驗證輸入、參數化查詢、輸出轉義。
- Authentication and authorization are checked on each new path. 新路徑皆檢查驗證與授權。
- No secret in code, config, test data, or log. 程式、設定、測試資料、log 皆無密鑰。
- Complete the applicable items of `SECURITY-CHECKLIST.md`. 完成 `SECURITY-CHECKLIST.md` 的適用項目。

## 7. Report format 回報格式

| Level | Meaning | Action |
|---|---|---|
| **Blocker** | Security hole, data loss, known high/critical CVE, personal data in logs, broken behavior | Must fix before merge |
| **Major** | Missing timeout/test/metric, high-cardinality label, poor error handling | Fix before merge, or record a ticket with the owner |
| **Minor** | Naming, small duplication, doc gap | Fix soon |
| **Nit** | Style | Optional |

For each finding write: `[Level] file:line — problem. Why. Fix.`
每項發現格式：`[層級] 檔案:行號 — 問題。原因。建議修正。`

End with: the purpose, the areas checked, the areas skipped (with reason), the test and scan results, and the decision: **Approve**, **Approve with comments**, or **Request changes**. Any Blocker = Request changes.
結尾列出：目的、已檢查範圍、略過範圍與原因、測試與掃描結果、結論（通過／附註通過／要求修改）。有 Blocker 一律要求修改。
