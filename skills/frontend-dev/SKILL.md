---
name: frontend-dev
description: Use when you build, change, or review frontend code (UI, components, styles, client state, client performance). Priority order is UX, smooth rendering, consistency, efficiency. 建立、修改或審查前端程式碼（UI、元件、樣式、client 狀態、前端效能）時使用：優先順序為使用者體驗、畫面流暢、一致性、效率。
---

# FRONTEND-DEV

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

Priority 優先順序: **1. UX → 2. Smooth rendering → 3. Consistency → 4. Efficiency.** When two rules conflict, the lower number wins. 規則衝突時，編號小者優先。

Apply with `skills/minimal-dev/SKILL.md` (scope), `skills/taste-skill/SKILL.md` (visual design), and `skills/ux-error-messages/SKILL.md` (user-visible messages). 搭配 minimal-dev、taste-skill、ux-error-messages 使用。

## Build 開發

1. **UX 使用者體驗**
   - Each view has all states: loading, empty, error, success, disabled. 每個畫面有完整狀態。
   - A user action gets feedback in 100 ms. Use an optimistic update or a skeleton for a slow call. 操作 100 ms 內有回饋；慢呼叫用樂觀更新或骨架。
   - Keyboard, focus order, visible focus, labels, and contrast meet WCAG 2.2 AA. 鍵盤、焦點、標籤、對比符合 WCAG 2.2 AA。
   - *Don't make me think too much.* One clear primary action per view. Use familiar patterns, plain labels, and safe defaults. A user needs no manual. 每個畫面一個明確主要動作；用常見樣式、白話標籤、安全預設；使用者不需說明書。
   - Do not lose user input on an error or a route change. 錯誤或換頁時不遺失使用者輸入。
2. **Smooth rendering 畫面流暢**
   - Core Web Vitals targets: LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1. 達成 Core Web Vitals 目標。
   - Animate only `transform` and `opacity`. Keep 60 fps. Respect `prefers-reduced-motion`. 動畫僅用 transform、opacity。
   - Reserve space for images, fonts, and async content. No layout shift. 預留空間，避免版面位移。
   - No layout thrash: do not interleave DOM reads and writes. 不交錯讀寫 DOM。
3. **Consistency 一致性**
   - Use the existing design tokens and components. Do not add a one-off color, spacing, size, or component. 用既有 token 與元件，不另做特例。
   - Same action = same wording, icon, position, and behavior across screens. 同一動作在各處用語、圖示、位置、行為一致。
   - A needed new pattern goes into the shared component set first. 需要新樣式時先進共用元件庫。
4. **Efficiency 效率**
   - Ship less: split code by route, lazy-load below-the-fold content, set a bundle budget. 少送：路由分包、延遲載入、設定 bundle 預算。
   - Images: right size, modern format, `loading="lazy"`, explicit width and height. 圖片尺寸、格式、延遲載入。
   - Long lists use virtualization or pagination. Debounce input-driven calls. Cancel stale requests. 長清單虛擬化或分頁；輸入防抖；取消過期請求。
   - Avoid needless re-render: stable keys, memoize only after measure. 避免無謂重繪；先量測再 memo。
   - Cache server data with a clear key and invalidation rule. 伺服器資料快取需有明確 key 與失效規則。

## Testing 測試

Do not use TDD as a rule. Test what is worth the cost. 不強制 TDD，只測值得測的。

- Write tests for shared components, business logic, critical user flows, and each bug fix. 為共用元件、商業邏輯、關鍵使用者流程、每個 bug 修復寫測試。
- Do not test styling, markup details, or framework code. 不測樣式、標記細節、框架程式。
- While you work, run only the tests that the change affects. Run the full suite once before you finish. 開發中只跑受影響的測試，完成前跑一次完整測試。

## Review 審查

Check each item in Build against the diff. Use the levels of `skills/review-code/SKILL.md`. 對照上列逐項檢查 diff，層級依 review-code。

| Finding 發現 | Level |
|---|---|
| Missing state (error, empty), lost input, no keyboard access, broken a11y | Major |
| Layout shift, animation on layout properties, INP or LCP regression | Major |
| One-off style or component that duplicates a shared one | Major |
| Bundle or image growth with no budget check, needless re-render | Minor |

Measure before you claim a perf problem: Lighthouse, the browser Performance panel, or the bundle report. 主張效能問題前先量測。
