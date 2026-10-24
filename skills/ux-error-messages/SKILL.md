---
name: ux-error-messages
description: Use when you create or change an error, warning, or alert message that a user sees (form, toast, banner, error page, API error text). Follow UI/UX and accessibility rules. 建立或修改使用者會看到的錯誤、警告、提醒訊息（表單、toast、banner、錯誤頁、API 錯誤文字）時使用。
---

# UX-ERROR-MESSAGES

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。
Show the message in the user language. Keep the technical detail in the log. 訊息用使用者語言；技術細節留在 log。

## 1. Message content 訊息內容

Use this order: **what happened → why (if known) → what to do.**
順序：發生什麼事 → 原因（若已知）→ 使用者該怎麼做。

- Use plain words. No error code alone, no stack, no jargon. 用白話，不只丟錯誤碼、堆疊、術語。
- Do not blame the user. 不責怪使用者。
- Say how to fix it. Give the format or an example. 說明如何修正，給格式或範例。
- Keep it short: one or two sentences. 一到兩句。
- Do not use "Oops", jokes, or all caps. 不用「哎呀」、玩笑、全大寫。

| ✗ Bad | ✓ Good |
|---|---|
| `Error 500` | `We could not save your changes. Try again in a minute.` 無法儲存變更，請稍後再試。 |
| `Invalid input` | `Enter a date as YYYY-MM-DD. Example: 2026-10-24.` 日期格式為 YYYY-MM-DD,例如 2026-10-24。 |
| `You entered a wrong password!` | `The email or password is not correct.` 電子郵件或密碼不正確。 |

## 2. Where and when 位置與時機

| Case | Pattern |
|---|---|
| Field input error | **Inline**, below the field. Show it on blur or on submit. Not on each key press. 欄位下方；blur 或送出時顯示，不在每次按鍵時顯示。 |
| Many field errors | Error **summary** at the top with links to each field. Move focus to the summary or the first bad field. 頂部摘要＋連結，焦點移到摘要或第一個錯誤欄位。 |
| Action failed (save, send) | **Banner** or **toast** near the action, with a **Retry** button. 動作附近的 banner/toast，附「重試」。 |
| Page or system failure | Full **error page** with a way out (home, retry, contact). 完整錯誤頁，提供出口。 |
| Offline or network | Persistent banner. Keep the user data. Retry when the network returns. 持續顯示，保留資料。 |
| Destructive action | **Confirm dialog** that names the item and the result. 確認對話框，說明對象與後果。 |

- **Warning:** Do not auto-dismiss an error toast. The user must have time to read it. Auto-dismiss is only for success and info.
  **警告：** 錯誤 toast 不可自動消失。
- Do not clear what the user typed. 不清除使用者已輸入的內容。
- Do not use a modal for a small error. 小錯誤不用 modal。

## 3. Severity 嚴重程度

Match the log level (see `prometheus-guide`). 對應 log 層級。

| UI type | Use when | Log level |
|---|---|---|
| Info | Neutral news | `INFO` |
| Success | Action done | `INFO` |
| Warning | User can continue, but must check | `WARN` |
| Error | Action failed. User must act | `ERROR` |
| Critical | Service is down | `FATAL` |

## 4. Visual and accessibility 視覺與無障礙

- Use **icon + text + color**. Do not use color alone. 圖示＋文字＋顏色，不單靠顏色。
- Text contrast: at least 4.5:1 (WCAG AA). Use the design token, not a new color. 對比度至少 4.5:1,使用設計 token。
- Inline error: link it to the field with `aria-describedby`. Set `aria-invalid="true"`. 以 `aria-describedby` 連結欄位並設 `aria-invalid`。
- Dynamic message: `role="alert"` (error) or `aria-live="polite"` (info, success). 動態訊息使用 `role="alert"` 或 `aria-live`。
- Keep the focus order. Move focus only on submit. 只在送出時移動焦點。
- Do not rely on a placeholder or a tooltip for the error text. 不用 placeholder 或 tooltip 當錯誤文字。
- Make the message text work in each language. No string joins. 支援多語言，不拼接字串。

## 5. Safety 安全

- **Warning:** Do not show a stack, SQL, path, or internal id to the user. 不顯示堆疊、SQL、路徑、內部 ID。
- Sign-in: do not say which part is wrong. Do not say if the account exists. 登入錯誤不透露是帳號或密碼錯，也不透露帳號是否存在。
- Show a **support code** (the `request_id`) so support can find the log. Show it in small text, with a copy button. 顯示 `request_id` 作為支援代碼，附複製按鈕。
- Do not put personal data in the message or the URL. 訊息與 URL 不放個人資料。

## 6. API errors 後端錯誤回應

Return a stable shape. The UI maps `code` to text. 回傳固定結構，由 UI 依 `code` 對應文字。

```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Check the highlighted fields.",
    "fields": [{ "name": "date", "code": "INVALID_FORMAT" }],
    "request_id": "7f3c9e..."
  }
}
```

- Use the right HTTP status (400, 401, 403, 404, 409, 422, 429, 5xx). 使用正確的 HTTP 狀態碼。
- For 429, return `Retry-After`. 429 回傳 `Retry-After`。

## Check 檢查
- [ ] The message says what happened, why, and what to do.
- [ ] The place and time fit the table in section 2.
- [ ] Icon, text, and color are present. Contrast is at least 4.5:1.
- [ ] Screen reader support is set (`role`, `aria-*`).
- [ ] No technical detail or personal data is shown. A support code is shown.
- [ ] User input is kept.
