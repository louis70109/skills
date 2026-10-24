# AGENTS.md

## Required first step 強制第一步

Before any action, read and apply `skills/ste-zh/SKILL.md`.
Do this for every task. Do not skip it. Do not start work before it.

在執行任何動作之前，必須先讀取並套用 `skills/ste-zh/SKILL.md`。
每個任務都要做。不可跳過。不可先動工。

## Dependency work 依賴相關

If the task adds, updates, or ships Node or Python dependencies, also apply `skills/cve-check/SKILL.md`.

任務涉及 Node 或 Python 依賴的新增、更新、發布時，另須套用 `skills/cve-check/SKILL.md`。

If the task creates or changes a backend service, also apply `skills/prometheus-guide/SKILL.md`.
任務建立或修改後端服務時，另須套用 `skills/prometheus-guide/SKILL.md`。

If the task creates or changes a logger or log output, also apply `skills/loki-logging/SKILL.md`.
任務涉及 logger 或 log 輸出時，另須套用 `skills/loki-logging/SKILL.md`。

If the task creates or changes an error, warning, or alert message that a user sees, also apply `skills/ux-error-messages/SKILL.md`.
任務涉及使用者看到的錯誤、警告、提醒訊息時，另須套用 `skills/ux-error-messages/SKILL.md`。

Before you ship code, also complete `SECURITY-CHECKLIST.md`.
發布程式碼前，另須完成 `SECURITY-CHECKLIST.md`。

## Order 順序

1. Read `skills/ste-zh/SKILL.md`. 讀取技能。
2. Restate the task in STE. 以 STE 重述任務。
3. Do the task. 執行任務。
4. Check the output against the skill rules. 對照規則檢查輸出。
