# SECURITY-CHECKLIST

Write in STE. See `skills/ste-zh/SKILL.md`. Mark each item Done, N/A, or Open. 每項標記 Done / N/A / Open。

## 1. Reduce attack surface 縮小攻擊面
- [ ] Remove unused dependencies. 移除未使用的依賴。
- [ ] Use a lockfile. Pin versions. 使用 lockfile 並鎖版本。
- [ ] Read the changelog and diff before an upgrade. 升級前閱讀 changelog 與 diff。
- [ ] Wait a few days before you use a new release. 新版本發布後先等數日。
- [ ] Block install scripts: `npm install --ignore-scripts`. 禁用安裝腳本。
- [ ] Run services with least privilege. Limit network output and file access. 服務以最小權限執行，限制對外網路與檔案存取。

## 2. Scan 掃描
- [ ] Run `skills/cve-check/SKILL.md`. 執行 cve-check。
- [ ] Run SAST: Semgrep or CodeQL (Python: Bandit). 執行靜態分析。
- [ ] Run a secret scan: gitleaks. 執行密鑰掃描。

## 3. Secrets 密鑰
- [ ] Do not put secrets in code or in the repo. 密鑰不進程式碼與 repo。
- [ ] Rotate any secret that was exposed. 外洩的密鑰必須輪替。

## 4. Detect 偵測
- [ ] Log unusual outbound connections, child processes, and file writes. 記錄異常連線、子行程、檔案寫入。
- [ ] A person must read the alerts. 告警必須有人處理。

## 5. Respond 回應
- [ ] Keep an SBOM (for example `syft`). 維護 SBOM。
- [ ] Run `osv-scanner` each day in CI. CI 每日執行 osv-scanner。
- [ ] Keep a rollback procedure and a secret rotation procedure. 備妥回滾與密鑰輪替流程。

## Limit 限制
This list reduces risk. It does not stop a zero-day. State this in the report. 此清單降低風險，無法阻擋零日漏洞，報告中必須說明。
