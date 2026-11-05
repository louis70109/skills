---
name: backend-dev
description: Use when you build, change, or review backend code (API, service logic, database, jobs, integrations). Priority order is flexibility, extensibility, efficiency. 建立、修改或審查後端程式碼（API、服務邏輯、資料庫、背景工作、整合）時使用：優先順序為彈性、擴充性、效率。
---

# BACKEND-DEV

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

Priority 優先順序: **1. Flexibility → 2. Extensibility → 3. Efficiency.** When two rules conflict, the lower number wins. 規則衝突時，編號小者優先。

Apply with `skills/minimal-dev/SKILL.md`, `skills/prometheus-guide/SKILL.md`, `skills/loki-logging/SKILL.md`, and `skills/cve-check/SKILL.md`. 搭配這些 skill 使用。

Extensibility means a **stable seam** at a real point of change (API contract, schema, config, event). It does not mean an abstraction for a guess. Follow `minimal-dev`: add an abstraction at the third use. 擴充性指在真實會變動處留穩定接縫，不是為猜測而抽象。

## Build 開發

1. **Flexibility 彈性**
   - Behavior that changes by environment or customer comes from config or env with a safe default. 隨環境或客戶變動的行為來自 config／env，附安全預設。
   - Keep the service stateless. State goes to the database, cache, or queue. This lets you add instances. 服務無狀態，狀態放資料庫、快取、佇列。
   - A risky change ships behind a flag and can roll back. 高風險變更用 flag 並可回滾。
   - A schema change is backward compatible: expand, migrate, then contract. Old and new code run together. 結構變更向下相容：先擴充、遷移、再收斂。
   - Timeouts, bounded retries, and idempotent writes (see `review-code` section 2). 逾時、有限重試、冪等寫入。
2. **Extensibility 擴充性**
   - An API change is **additive**: new optional fields, no removed or renamed field. A break gets a new version. API 變更只增不減，破壞性變更開新版本。
   - *Don't make me think too much.* An API has clear names, safe defaults, and one obvious way to do a task. A caller needs no guess. API 命名清楚、預設安全、做一件事只有一種明顯做法；呼叫者不必猜。
   - A clear contract (OpenAPI or schema) is the source of truth. Validate input at the boundary. 以明確契約為準，邊界驗證輸入。
   - Each module has one job and one-way dependencies. Hide a third-party service behind a thin interface of your own. 模組單一職責、單向依賴；第三方服務以薄介面隔離。
   - Slow or fan-out work goes to a job or an event, not the request path. 慢或扇出的工作走背景工作或事件。
   - A list endpoint has pagination, filter, and sort from the start. 列表端點一開始就有分頁、篩選、排序。
3. **Efficiency 效率**
   - Measure first, then fix: slow-query log, profiler, the metrics from `prometheus-guide`. 先量測再優化。
   - Remove N+1 queries. Batch reads and writes. Select only needed columns. 消除 N+1、批次讀寫、只取需要欄位。
   - Every query filter, join, and sort has an index. Check with `EXPLAIN`. 每個篩選、join、排序有索引並以 EXPLAIN 驗證。
   - Use a connection pool with a limit. Cache with a TTL and an invalidation rule. 連線池有上限；快取有 TTL 與失效規則。
   - Bound payload size. Stream or paginate large results. 限制 payload；大結果串流或分頁。

## Domain model 領域模型 (DDD)

Use Domain-Driven Design where the business rules are complex. For plain CRUD, skip it (`minimal-dev`). 業務規則複雜時才用 DDD；單純 CRUD 不用。

- Use the business words in code: class, function, and field names match the **ubiquitous language**. 程式命名與業務用語一致（通用語言）。
- Put business rules in the domain layer (entity, value object, aggregate). Not in a controller, a query, or a UI handler. 業務規則放領域層，不放 controller、查詢或 UI。
- One **bounded context** = one module. Contexts talk through an interface or an event. They do not share tables. 一個限界上下文一個模組；以介面或事件溝通，不共用資料表。
- An **aggregate** is one consistency boundary and one transaction. Refer to another aggregate by id. 聚合是一個一致性邊界與一個交易；以 id 參照其他聚合。
- The domain defines the repository interface. The infrastructure layer implements it. 領域層定義 repository 介面，基礎設施層實作。

## Testing 測試

Do not use TDD as a rule. Test what is worth the cost. 不強制 TDD，只測值得測的。

- Write tests for domain rules, critical paths, and each bug fix (a test that fails before the fix). 為領域規則、關鍵路徑、每個 bug 修復寫測試。
- Do not test trivial code, framework code, or private details. 不測瑣碎程式、框架程式、內部實作細節。
- While you work, run only the tests that the change affects. Run the full suite once before you finish. 開發中只跑受影響的測試，完成前跑一次完整測試。

## Review 審查

Check each item in Build against the diff. Use the levels of `skills/review-code/SKILL.md`. 對照上列逐項檢查 diff，層級依 review-code。

| Finding 發現 | Level |
|---|---|
| Breaking API or schema change with no version or migration path | Blocker |
| Hard-coded environment value, in-process state that blocks scale-out | Major |
| N+1 query, missing index on a hot query, unbounded list or payload | Major |
| Slow work in the request path, no timeout on a dependency call | Major |
| Abstraction with one use "for later" | Major (over-design, see `review-code` section 0) |
| Missing cache TTL, small batch gap | Minor |

Measure before you claim a perf problem. 主張效能問題前先量測。
