---
name: security-checklist
description: "Use before you ship code. Check the attack surface, scans, secrets, detection, and response. 發布程式碼前使用：檢查攻擊面、掃描、密鑰、偵測與回應。"
---

# SECURITY-CHECKLIST

Write in STE. See `ste-zh`. Mark each item Done, N/A, or Open. 每項標記 Done / N/A / Open。

## 1. Reduce attack surface 縮小攻擊面
- [ ] Remove unused dependencies. 移除未使用的依賴。
- [ ] Use a lockfile. Pin versions. 使用 lockfile 並鎖版本。
- [ ] Read the changelog and diff before an upgrade. 升級前閱讀 changelog 與 diff。
- [ ] Wait a few days before you use a new release. 新版本發布後先等數日。
- [ ] Block install scripts: `npm install --ignore-scripts`. 禁用安裝腳本。
- [ ] Run services with least privilege. Limit network output and file access. 服務以最小權限執行，限制對外網路與檔案存取。

## 2. Scan 掃描
- [ ] Run `skills/cve-check/SKILL.md`. 執行 cve-check。
- [ ] Run a secret scan of the tracked files with bash first. 先用 bash 掃描追蹤中的檔案是否有密鑰：
  `git grep -nIE -e '-----BEGIN [A-Z ]*PRIVATE KEY-----' -e 'AKIA[0-9A-Z]{16}' -e 'gh[pousr]_[A-Za-z0-9]{36}' -e 'xox[abprs]-[A-Za-z0-9-]{10,}'`
  This finds common formats only. Run gitleaks in CI to scan the history. 只找常見格式；在 CI 用 gitleaks 掃描歷史。
- [ ] Run SAST (Semgrep or CodeQL; Python: Bandit) in CI. Do not install it locally for one task (`minimal-dev` section 2.1). 在 CI 執行靜態分析，不為單一任務裝在本機。

## 3. Secrets 密鑰
- [ ] Do not put secrets in code or in the repo. 密鑰不進程式碼與 repo。
- [ ] Rotate any secret that was exposed. 外洩的密鑰必須輪替。
- [ ] Do not put secrets or personal data in `.agents/` (memory, project rules, project skills). `.agents/` 內不可有密鑰與個資。

## 4. Detect 偵測
- [ ] Log unusual outbound connections, child processes, and file writes. 記錄異常連線、子行程、檔案寫入。
- [ ] A person must read the alerts. 告警必須有人處理。

## 5. Respond 回應
- [ ] Keep an SBOM. The lockfile is the first record. Make a full SBOM (for example with `syft`) in CI. 維護 SBOM；lockfile 是第一份紀錄，完整 SBOM 在 CI 產生。
- [ ] Run an OSV check each day in CI: `osv-scanner`, or `skills/cve-check/scripts/osv-check.sh` for Python. CI 每日執行 OSV 檢查。
- [ ] Keep a rollback procedure and a secret rotation procedure. 備妥回滾與密鑰輪替流程。

## Limit 限制
This list reduces risk. It does not stop a zero-day. State this in the report. 此清單降低風險，無法阻擋零日漏洞，報告中必須說明。
