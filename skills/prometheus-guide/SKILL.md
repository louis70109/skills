---
name: prometheus-guide
description: Use when you create or change a backend service (Node or Python). Set up Prometheus metrics and structured logs by this guide. 建立或修改後端服務時使用：依此指南設定 Prometheus metrics 與結構化 log。
---

# PROMETHEUS-GUIDE

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。
Every backend service must follow this guide. 所有後端服務都必須遵守。

## A. Metrics

### Endpoint 端點
- Expose `GET /metrics` in the Prometheus text format. Use a separate internal port if you can.
  提供 `GET /metrics`;可以的話使用獨立的內部埠。
- Do not put personal data in metrics. 不可在 metrics 放個人資料。

### Naming 命名
- Format: `<app>_<subsystem>_<name>_<unit>`. Use `snake_case`. Use base units (`seconds`, `bytes`).
  格式如上，使用 snake_case 與基本單位。
- Counter names end in `_total`. 計數器以 `_total` 結尾。
- One metric name = one meaning. 一個名稱只有一個意義。

### Required metrics 必備指標

| Metric | Type | Labels | Use |
|---|---|---|---|
| `http_requests_total` | Counter | `method`, `route`, `status` | Rate, errors |
| `http_request_duration_seconds` | Histogram | `method`, `route` | Latency |
| `http_requests_in_flight` | Gauge | — | Saturation |
| `app_log_messages_total` | Counter | `level` | Log volume per level |
| `app_dependency_requests_total` | Counter | `dependency`, `outcome` | DB, cache, API calls |
| `app_dependency_duration_seconds` | Histogram | `dependency` | Dependency latency |
| `app_build_info` | Gauge (=1) | `version`, `commit` | Release trace |
| `app_job_last_success_timestamp_seconds` | Gauge | `job` | Background job health |

Add business metrics for each key action (for example `orders_created_total`). 為每個關鍵動作加業務指標。

### Labels 標籤
- **Warning:** Each label value creates a new time series. Keep labels low-cardinality.
  **警告：** 每個標籤值都會產生新時間序列，必須低基數。
- Allowed: `method`, `route` (template, for example `/users/:id`), `status`, `outcome`, `dependency`.
- Not allowed: user id, email, IP, token, full URL, raw error text, request id. 禁用：使用者 ID、email、IP、token、完整 URL、原始錯誤訊息、request id。
- Use the route template, not the real path. 使用路由樣板，不用實際路徑。

### Types 類型
- Counter: only goes up (events). 只增加。
- Gauge: goes up and down (state). 可增可減。
- Histogram: durations and sizes. Use buckets that fit the SLO, for example `0.005 … 10` seconds. 時間與大小。
- Do not use Summary if you need to aggregate across instances. 需跨實例聚合時不用 Summary。

### Code 程式碼
Node (`prom-client`):
```js
const client = require('prom-client');
client.collectDefaultMetrics();
const httpDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.005, 0.025, 0.1, 0.5, 1, 2.5, 5, 10],
});
```
Python (`prometheus_client`):
```python
from prometheus_client import Histogram, start_http_server
HTTP_DURATION = Histogram(
    "http_request_duration_seconds", "HTTP request duration in seconds",
    ["method", "route"], buckets=(0.005, 0.025, 0.1, 0.5, 1, 2.5, 5, 10),
)
start_http_server(9100)
```

## B. Logs

### Format 格式
- Write one JSON object per line to stdout. 每行一個 JSON，輸出到 stdout。
- Fields: `timestamp` (UTC, ISO 8601), `level`, `service`, `version`, `message`, `event`, `trace_id`, `request_id`, `duration_ms`, `error.type`, `error.stack`.
- Write **detailed** logs: the operation, the inputs that are not personal (ids as opaque values, counts, sizes, status codes), the result, and the time taken. Log each dependency call and each state change.
  盡可能詳細：操作、非個人資料的輸入（不透明 ID、數量、大小、狀態碼）、結果、耗時；記錄每次依賴呼叫與狀態變更。
- Increment `app_log_messages_total{level}` for each log line. 每筆 log 都累加計數器。

### Severity 嚴重程度

| Level | Use when | Action |
|---|---|---|
| `DEBUG` | Internal detail for a developer: variable state, branch taken, SQL timing. | Off in production by default. |
| `INFO` | Normal event: start, stop, request done, job done, config loaded. | None. |
| `WARN` | Unexpected, but the service continues: retry, fallback, slow call, deprecated use, 4xx from a bug in a client. | Review each day. |
| `ERROR` | An operation failed. The service still runs. Include cause and stack. | Alert on rate. |
| `FATAL` | The service cannot continue and will stop. | Page now. |

- Choose the level by impact, not by feel. If unsure between two levels, choose the higher level. 依影響選層級；不確定時選較高者。
- Do not log an expected user mistake (for example wrong input) as `ERROR`. Use `INFO` or `WARN`. 預期的使用者輸入錯誤不記為 ERROR。
- Log an error one time, where you handle it. Do not log it again at each layer. 錯誤只在處理處記錄一次。

### Personal data 個人資料
**Warning:** Never write personal data to a log, a label, or a trace. 警告：log、標籤、trace 皆不可含個人資料。
- Personal data: name, email, phone, address, birth date, government ID, IP address, device id, location, free text from a user.
- Secrets: password, token, API key, session id, cookie, `Authorization` header, card number.
- Use an opaque internal id (for example `user_id` as a random uuid) when you must link events. 需關聯事件時用不透明內部 ID。
- Redact at the logger level (a redaction list), not at each call site. 在 logger 層統一遮蔽。
- Do not log full request or response bodies. Log size and status. 不記錄完整 body，只記大小與狀態。

## C. Alerts 告警
- Add alert rules for: error ratio, p95 latency, `up == 0`, job staleness, `FATAL` count > 0.
- Each alert needs a `severity` label (`page`, `ticket`, `info`) and a runbook link. 每個告警需有 severity 標籤與 runbook 連結。

## Check 檢查
- [ ] `/metrics` works and has all required metrics.
- [ ] No high-cardinality label.
- [ ] Logs are JSON, have levels, and have no personal data or secret.
- [ ] Each failed operation has one `ERROR` with cause and stack.
