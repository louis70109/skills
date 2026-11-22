---
name: rea-docker-analysis
description: "Use when the user wants to reverse engineer or decompile a native binary (PE .exe/.dll, ELF, Mach-O), or set up REA in Docker. Runs REA and Ghidra in an isolated container for static analysis. 使用者要逆向分析或反編譯原生執行檔（.exe、.dll、ELF、Mach-O），或要在 Docker 裡架設 REA 時使用：在隔離容器內以 REA + Ghidra 做靜態分析。"
---

# REA-DOCKER-ANALYSIS

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

REA 是開源（MIT）的逆向工程工具。CLI 指令是 `rea`，npm 套件是 `rea-agents`。深入分析使用 Ghidra。
這個 skill 把 REA、Ghidra、JDK、Node 裝在同一個 Linux 容器裡，因為 REA 要求 headless provider 與它在同一台主機。
樣本以唯讀方式掛載。分析時容器不連網。

## 這個 skill 做不到的事

- 不執行目標程式。只做靜態分析。
- 不解開安裝檔（NSIS、Inno Setup、自解壓檔）。先用 `7zz x` 或 `innoextract` 取出檔案，再分析取出的 exe 或 dll。
- 反編譯結果可能不完整。遇到未解析的呼叫或數值，把該位址當成下一個問題繼續追。
- 只分析使用者有權分析的程式。來源不清楚時，開始前先問。

## 版本

下列版本是一組。`rea-agents` 6.9.0 以 Ghidra 12.1.4 與 JDK 21 驗證（`SUPPORTED_GHIDRA_VERSION`、`SUPPORTED_GHIDRA_JAVA_MAJOR`）。

| 元件 | 版本 | 鎖定位置 |
|---|---|---|
| `rea-agents` | 6.9.0 | `package.json`、`package-lock.json` |
| Ghidra | 12.1.4 | `Dockerfile` 的 `GHIDRA_URL`、`GHIDRA_SHA256` |
| JDK | 21（`eclipse-temurin`） | `Dockerfile` 的 `FROM`，含 digest |
| Node.js | 24.22.3 | `Dockerfile` 的 `NODE_VERSION`、`NODE_SHA256` |

升級時必須一起改：

1. 讀新版 `rea-agents` 的 diff 與 changelog。新版發布至少 3 天後才使用（`security-checklist` 第 1 節）。
2. 查新版的 `dist/ghidra/GhidraReleasePolicy.js`，找出它要求的 Ghidra 與 JDK 版本。例如 6.10.1 要求 Ghidra 12.2 與 JDK 25，且不接受 12.1。
3. 更新 `package.json`，再執行 `npm install --package-lock-only --ignore-scripts` 產生新的 lockfile。
4. 執行 `cve-check`。
5. 更新 Ghidra 的網址與 SHA-256。SHA-256 取自 Ghidra 的 release 頁面。
6. 更新 `FROM` 的 tag 與 digest。

## 1. 先決條件檢查

```
docker version
```

失敗時，請使用者安裝或啟動 Docker Desktop。不要自己改系統設定。

## 2. 建置映像

`Dockerfile` 在這個 skill 的資料夾裡。建置時要下載數百 MB，其中 Ghidra 約 543 MB。

```
docker build --platform linux/amd64 -t rea-ghidra <skill 資料夾>
```

- 建置時會核對 Node 與 Ghidra 的 SHA-256。不符合時建置失敗。不要跳過核對。
- 固定使用 `linux/amd64`。Linux arm64 需要自行編譯 Ghidra 的原生反編譯器，這個 `Dockerfile` 沒有做。Apple Silicon 會用模擬執行，速度較慢但可用。

## 3. 啟動容器

把要分析的檔案放在主機的一個資料夾（下稱 `<樣本資料夾>`）。然後執行：

```
docker run -d --name rea --platform linux/amd64 --network none --memory 6g -v "<樣本資料夾>:/samples:ro" -v "<輸出資料夾>:/out" rea-ghidra
```

- `--network none`：分析不需要網路。切斷網路可以降低風險。
- `/samples` 是唯讀，樣本不會被修改。

就緒檢查：

```
docker exec rea rea doctor --provider ghidra --json
```

檢查沒通過時，讀 JSON 裡的錯誤訊息並修正。常見原因是 Ghidra 路徑、JDK 版本、缺少 `ps`。不要強行執行分析。

## 4. 分析流程（CLI）

路徑一律使用容器內的絕對路徑。每次 CLI 呼叫都會重新匯入與分析。大檔案第一次會比較久。

```
docker exec rea rea analyze   /samples/target.exe --provider ghidra --json
docker exec rea rea search    /samples/target.exe "關鍵字" --provider ghidra --json
docker exec rea rea function  /samples/target.exe main --provider ghidra --json
docker exec rea rea decompile /samples/target.exe 0x401000 --provider ghidra --json
docker exec rea rea xrefs     /samples/target.exe 0x401000 --provider ghidra --json
docker exec rea rea trace     /samples/target.exe "關鍵字" --provider ghidra --json
```

建議順序：

1. 用 `analyze` 取得概觀：入口、匯入、區段、重要函式。
2. 依使用者的問題，用 `search` 或 `trace` 找相關字串或功能。
3. 對找到的函式，用 `function` 看完整資料，用 `decompile` 看虛擬碼。
4. 用 `xrefs` 追蹤呼叫者與被引用的項目。
5. 輸出很大時，加上 `--detail summary --evidence_output /out/<名稱>.json`，再讀該檔案。

文件沒有列出「列出所有字串」或「列出所有函式」的子指令。需要時，先執行 `docker exec rea rea --help` 與 `docker exec rea rea <子指令> --help`，確認可用的選項。不要猜旗標。

回報給使用者時：
- 說明找到什麼。
- 附上位址與相關的虛擬碼片段。
- 標出推論不確定或未解析的地方。

## 5. （選用）用 MCP 連到 Claude Code

MCP 模式會在同一個 session 重用已匯入的檔案。連續追問時比較快。

```
claude mcp add --scope local rea -- docker exec -i rea rea mcp
```

**警告：** 官方文件只示範用 node 直接執行 `rea.mjs mcp`。透過 `docker exec -i` 轉接 stdio 是推論的做法，尚未驗證。

- 新增後，必須重新開啟 Claude Code session，才會出現 REA 的工具。
- 檢查設定：`docker exec rea rea mcp doctor --json`。

## 6. 收尾

```
docker stop rea
docker rm rea
```

不再使用時，可以再執行 `docker rmi rea-ghidra`。刪除前先向使用者確認。

## 可調整的環境變數

用 `docker run -e 名稱=值 ...` 帶入。

- `GHIDRA_HEADLESS_MAXMEM`：Ghidra 的記憶體上限。映像預設 4G，官方預設 2G。
- `REA_GHIDRA_STARTUP_TIMEOUT_MS`：Ghidra 的啟動逾時。預設 330000。
- `REA_GHIDRA_DECOMPILE_TIMEOUT_SECONDS`：單次反編譯的逾時。

## 驗證狀態

- 已確認：`rea-agents` 6.9.0 的程式碼中有上列子指令名稱、`--detail summary`、`--evidence_output` 與環境變數。這只是文字比對，沒有執行。
- 已確認：lockfile 加上 `--omit=optional` 後，`npm audit` 結果為 0 筆。
- 尚未驗證：映像建置、`rea doctor`、實際分析、MCP 轉接。
