---
name: loki-logging
description: Use when you create or change the logger of a backend service (Node or Python). Make logs fit the Grafana Loki design and hold all data needed to debug. 建立或修改後端服務的 logger 時使用：讓 log 符合 Grafana Loki 設計，並包含除錯所需的全部資訊。
---

# LOKI-LOGGING

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。
This skill adds to section B of `skills/prometheus-guide/SKILL.md`. Levels and personal-data rules stay the same. 本技能補充 prometheus-guide 的 B 段；層級與個資規則不變。

## 1. How Loki works 設計原理

- Loki indexes **labels only**. It does not index the log text. 只索引標籤，不索引內文。
- Each unique set of labels = one **stream**. Many streams = high cost and slow queries. 每組唯一標籤 = 一個 stream;stream 過多會增加成本並拖慢查詢。
- Log text is compressed and searched at query time (`|=`, `| json`). 內文壓縮後於查詢時搜尋。

**Rule:** few, stable labels. All detail in the log line. 規則：標籤少而穩定，細節全放進 log 內文。

## 2. Labels 標籤

Allowed (low cardinality, fewer than about 20 values each) 允許：

| Label | Example |
|---|---|
| `service` | `orders-api` |
| `env` | `prod`, `staging` |
| `level` | `info`, `warn`, `error`, `fatal` |
| `namespace` / `cluster` | `shop`, `eu-1` |

**Warning:** Never use these as labels. Put them in the log line. 警告：下列欄位不可當標籤，放進內文：
`trace_id`, `request_id`, `user_id`, `ip`, `url`, `route`, `pod` (if it changes often), `error` text, `duration`, timestamp.

- Set labels in the collector (Alloy or Promtail), not in the app. 標籤由收集器（Alloy/Promtail）設定，不由應用程式設定。
- Use the same label names in every service. They must match the Prometheus labels (`service`, `env`) so a user can jump from a metric to its logs. 標籤名稱跨服務一致，並與 Prometheus 標籤相同，才能由指標跳到 log。

## 3. Log line format 內文格式

- One JSON object per line, to **stdout**. No log file, no rotation in the app. 每行一個 JSON,輸出到 stdout,應用程式不自行寫檔或輪替。
- One event = one line. Put a stack trace **inside** the JSON field `error.stack` (with `\n`). Never write multi-line text. 一事件一行；堆疊放在 `error.stack` 欄位內，不輸出多行文字。
- Keep each line under 64 KB. Cut large payloads. Log the size, not the body. 單行小於 64 KB;大 payload 只記大小。
- Use a UTC timestamp with milliseconds. Write in time order. 使用含毫秒的 UTC 時間，依序寫入。
- Use stable field names and one type per field. 欄位名稱固定、型別固定。

## 4. Fields for debug 除錯所需欄位

Add these to **every** line (the logger does it, not the call site). 下列欄位由 logger 自動加入：

| Field | Why |
|---|---|
| `timestamp`, `level`, `message` | Base |
| `service`, `env`, `version`, `commit` | Find the release that caused the bug |
| `host` / `pod`, `pid` | Find the instance |
| `trace_id`, `span_id`, `request_id` | Link logs across services and to traces |
| `event` | Stable name, for example `order.created`. Search by `event`, not by message text. 穩定事件名，用它查詢 |
| `caller` | `file:line` or function name |
| `duration_ms` | Time of the operation |

Add these when they apply 視情況加入：

| Field | Why |
|---|---|
| `error.type`, `error.message`, `error.stack`, `error.cause` | Full cause chain |
| `dependency`, `target`, `attempt`, `status_code` | Which call failed, which retry |
| `http.method`, `http.route`, `http.status`, `http.request_size`, `http.response_size` | Request detail |
| `state.from`, `state.to` | State change |
| `input.count`, `input.size`, `input.id` (opaque) | Input shape, not content |
| `config` snapshot (no secrets) | Log it **one time** at startup |
| `feature_flags` | Behavior switch in use |

**Warning:** Personal data and secrets stay out of every field. Redact in the logger. 個資與密鑰不可出現在任何欄位，在 logger 層遮蔽。

## 5. Volume and cost 量與成本

- Production default level = `INFO`. Allow `DEBUG` per service at run time (env var or flag), with a time limit. 正式環境預設 INFO;DEBUG 可於執行期按服務開啟並限時。
- Do not log inside a tight loop. Log a count or a summary. 不在緊密迴圈內逐筆記錄，改記數量或摘要。
- Do not repeat the same error many times. Log the first, then a count. 重複錯誤只記第一筆，之後記次數。
- Set a retention time per level (for example `DEBUG` 3 days, `INFO` 14 days, `ERROR` 90 days). 依層級設定保留期。

## 6. Code 程式碼

Node (`pino`):
```js
const pino = require('pino');
const base = { service: 'orders-api', env: process.env.APP_ENV,
  version: process.env.APP_VERSION, commit: process.env.GIT_COMMIT };
module.exports = pino({
  level: process.env.LOG_LEVEL || 'info',
  base,
  timestamp: pino.stdTimeFunctions.isoTime,
  formatters: { level: (label) => ({ level: label }) },
  redact: ['*.password', '*.token', 'req.headers.authorization', '*.email'],
});
// logger.child({ trace_id, request_id }).error({ event: 'payment.failed', err }, 'Payment failed');
```
Python (`structlog`):
```python
import logging, os, structlog
logging.basicConfig(format="%(message)s", level=os.getenv("LOG_LEVEL", "INFO"))
structlog.configure(processors=[
    structlog.contextvars.merge_contextvars,   # trace_id, request_id
    structlog.processors.add_log_level,
    structlog.processors.TimeStamper(fmt="iso", utc=True),
    structlog.processors.format_exc_info,      # error stack in one field
    structlog.processors.JSONRenderer(),
])
log = structlog.get_logger().bind(service="orders-api", env=os.getenv("APP_ENV"),
                                  version=os.getenv("APP_VERSION"))
```

## 7. Query by example 查詢範例 (LogQL)

```logql
{service="orders-api", env="prod", level="error"} | json | event="payment.failed"
{service="orders-api"} | json | trace_id="7f3c9e..."
sum by (event) (count_over_time({service="orders-api", level="error"} | json [5m]))
```

If a log is hard to find with these queries, add the missing field. 若這類查詢找不到，補上缺少的欄位。

## Check 檢查
- [ ] Labels: only `service`, `env`, `level`, `namespace`/`cluster`. No high-cardinality label.
- [ ] One JSON line per event, on stdout. Stack in `error.stack`.
- [ ] The logger adds the base fields to every line.
- [ ] Each error has `event`, `error.*`, `trace_id`, and `request_id`.
- [ ] No personal data or secret. Redaction is in the logger.
- [ ] `DEBUG` is off by default and can be turned on at run time.
