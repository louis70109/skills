---
name: minimal-dev
description: Use before you design or write code. Build the smallest change that works. Do not over-design. Do not over-engineer. 設計或撰寫程式碼前使用：只做最小可行的變更，不過度設計、不過度工程。
---

# MINIMAL-DEV

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

**Rule:** Build only what the task needs now. Make it work, make it correct, and stop.
規則：只做當下任務需要的事；讓它能運作、正確，然後停手。

## 1. Before you write 動手前

1. State the task in one sentence. State what "done" means. 一句話說明任務與「完成」的定義。
2. Find the **smallest change** that meets it. Prefer: change a line > add a function > add a module > add a service. 找出最小變更：改一行 > 加函式 > 加模組 > 加服務。
3. Read the existing code. Reuse what is there. 先讀現有程式碼並重用。
4. If the need is unclear, ask one question. Do not guess a large design. 需求不明時問一個問題，不猜測大型設計。

## 2. Do not build 不要做

| Do not | Why |
|---|---|
| A feature, option, or flag nobody asked for | Cost without value (YAGNI) |
| An abstraction, interface, or plugin system for one use | Add it at the **third** use, not the first |
| A config for a value that never changes | More paths to test |
| A new layer, wrapper, or pattern "for later" | "Later" often does not come |
| A new dependency for a few lines of code | CVE and upkeep cost |
| A new service, queue, or cache without measured need | Run cost and failure modes |
| Early optimization | Measure first |
| A rewrite or refactor outside the task | Large diff, new risk |

## 3. Always build 必須做

The minimum is **not** zero quality. Keep these even in the smallest change. 最小不等於低品質，下列一律保留：

- Correct behavior and a test for it (and for the main failure path). 正確行為與測試。
- Input validation at the boundary. 邊界輸入驗證。
- No secret or personal data in code or logs (`skills/loki-logging/SKILL.md`). 無密鑰與個資。
- A timeout on each network call. 網路呼叫逾時。
- Clear user-facing errors (`skills/ux-error-messages/SKILL.md`). 清楚的使用者錯誤訊息。
- Basic metrics and logs for a **new** endpoint or job (`skills/prometheus-guide/SKILL.md`): count, duration, outcome, one `ERROR` log with cause. 新端點或工作的基本指標與 log。
- `skills/cve-check/SKILL.md` when you add a dependency. 新增依賴時執行 cve-check。

## 4. Grow by need 依需求成長

- Add a feature when a real user or a measured problem needs it. 有真實使用者或實測問題才加。
- Add resilience (retry, circuit breaker, cache, queue) when a failure or load figure shows the need. Write that evidence in the commit or PR. 有失效或負載數據佐證才加韌性機制，並將證據寫入 commit/PR。
- Prefer a simple, **easy to remove** solution over a flexible one. 偏好容易移除的簡單方案，而非彈性方案。
- Copy once is fine. Abstract at the third copy. 重複一次可接受，第三次再抽象。

## 5. Self-check 自我檢查

Answer before you finish. 完成前回答：

- [ ] Does each changed line serve the stated task? 每一行變更都服務於任務？
- [ ] Can I delete a file, function, option, or dependency and still meet "done"? If yes, delete it. 能刪掉任何檔案、函式、選項、依賴而仍達成目標？能就刪。
- [ ] Would a new teammate understand it in five minutes? 新同事五分鐘內能看懂？
- [ ] Is each "for the future" item removed or backed by evidence? 每個「為了未來」的項目都已移除或有證據？
- [ ] Did I keep all items in section 3? 第 3 節項目都保留了？

If you cannot do the minimum safely, say so. Report what you did not do and why. 若無法安全完成最小版本，必須說明；並回報未做的項目與原因。
