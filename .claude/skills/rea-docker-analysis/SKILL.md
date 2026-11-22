---
name: rea-docker-analysis
description: 在隔離的 Docker 容器裡用 REA（rea.tools）+ Ghidra 靜態分析 Windows .exe/.dll 等原生執行檔：列出概觀、搜尋、看函式、反編譯成虛擬碼、查交叉引用。當使用者想逆向分析、反編譯、看某個 exe 在做什麼，或要在 Docker 裡架 REA 時使用。Use when the user wants to reverse engineer or decompile a native binary (PE .exe/.dll, ELF, Mach-O) with REA inside Docker.
---

# 用 Docker 跑 REA + Ghidra 分析執行檔

REA 是開源（MIT）的逆向工程工具，CLI 指令為 `rea`，npm 套件為 `rea-agents`。深入分析靠 Ghidra。這個 skill 把 REA、Ghidra、JDK、Node 全裝在同一個 Linux 容器裡（REA 要求 headless provider 和它跑在同一台主機），樣本以唯讀方式掛載，分析時不連網。

## 這個 skill 做不到的事

- **不會執行**目標程式，只做靜態分析。
- **不解開安裝檔**（NSIS、Inno Setup、自解壓檔）。要先用 `7zz x` 或 `innoextract` 取出裡面的檔案，再分析取出的 exe/dll。
- 反編譯結果可能不完整。遇到未解析的呼叫或數值，就把那個位址當作下一個問題繼續追。
- 只分析使用者有權分析的程式。開始前若不清楚來源，先問。

## 1. 先決條件檢查

```
docker version
```

失敗就請使用者安裝或啟動 Docker Desktop，不要自己改系統設定。

## 2. 建置映像

Dockerfile 放在這個 skill 的資料夾裡（`Dockerfile`）。

1. 到 https://github.com/NationalSecurityAgency/ghidra/releases 找 **Ghidra 12.2** 的 `ghidra_12.2*_PUBLIC_*.zip` 下載網址（版本必須是 12.2 系列，12.1 不被接受；若 12.2.1 已發布則優先用它）。
2. 建置（約需下載數百 MB）：

```
docker build --platform linux/amd64 --build-arg GHIDRA_URL="<上一步的網址>" -t rea-ghidra <skill 資料夾>
```

固定使用 `linux/amd64`：Linux arm64 需要自行編譯 Ghidra 原生反編譯器，這個 Dockerfile 沒做。Apple Silicon 上會走模擬，較慢但可用。

## 3. 啟動容器

把要分析的檔案放在主機上的一個資料夾（下面稱 `<樣本資料夾>`），然後：

```
docker run -d --name rea --platform linux/amd64 --network none --memory 6g -v "<樣本資料夾>:/samples:ro" -v "<輸出資料夾>:/out" rea-ghidra
```

- `--network none`：分析不需要網路，切斷可降低風險。
- `/samples` 唯讀，避免樣本被改動。

就緒檢查：

```
docker exec rea rea doctor --provider ghidra --json
```

沒通過就讀 JSON 裡的錯誤訊息修正（常見：Ghidra 路徑、JDK 版本、缺 `ps`），不要硬跑分析。

## 4. 分析流程（CLI）

路徑一律用容器內的絕對路徑。每次 CLI 呼叫都會重新匯入並分析一次，大檔案第一次會比較久。

```
docker exec rea rea analyze  /samples/target.exe --provider ghidra --json
docker exec rea rea search   /samples/target.exe "關鍵字" --provider ghidra --json
docker exec rea rea function /samples/target.exe main --provider ghidra --json
docker exec rea rea decompile /samples/target.exe 0x401000 --provider ghidra --json
docker exec rea rea xrefs    /samples/target.exe 0x401000 --provider ghidra --json
docker exec rea rea trace    /samples/target.exe "關鍵字" --provider ghidra --json
```

建議順序：

1. `analyze` 取得概觀（入口、匯入、區段、重要函式）。
2. 依使用者的問題用 `search` / `trace` 找相關字串或功能。
3. 對找到的函式用 `function` 看完整資料，用 `decompile` 看虛擬碼。
4. 用 `xrefs` 追誰呼叫它、它引用了什麼。
5. 輸出很大時加 `--detail summary --evidence_output /out/<名稱>.json`，再讀檔案。

文件沒列出「列所有字串」或「列所有函式」的獨立子指令；需要時先跑 `docker exec rea rea --help` 和 `docker exec rea rea <子指令> --help` 確認實際可用的選項，不要猜旗標。

回報給使用者時：說明找到什麼、附上位址與相關虛擬碼片段、標出哪些地方推論不確定或未解析。

## 5.（選用）改用 MCP 連到 Claude Code

MCP 模式下同一個 session 會重用已匯入的二進位檔，連續追問比較快。

```
claude mcp add --scope local rea -- docker exec -i rea rea mcp
```

注意：官方文件只示範用 node 直接執行 `rea.mjs mcp`，**透過 `docker exec -i` 轉接 stdio 是推論做法，尚未驗證**。新增後要重開 Claude Code session 才會出現 REA 的工具。檢查設定：`docker exec rea rea mcp doctor --json`。

## 6. 收尾

```
docker stop rea
docker rm rea
```

評估完不再使用時可再 `docker rmi rea-ghidra`。刪除前先跟使用者確認。

## 可調整的環境變數

- `GHIDRA_HEADLESS_MAXMEM`：Ghidra 記憶體上限（映像預設 4G，官方預設 2G）。
- `REA_GHIDRA_STARTUP_TIMEOUT_MS`：Ghidra 啟動逾時（預設 330000）。
- `REA_GHIDRA_DECOMPILE_TIMEOUT_SECONDS`：單次反編譯逾時。

用 `docker run -e 名稱=值 ...` 帶入。
