---
name: rms-release
description: Use when you ship a new version of the RMS guide site or the Windows desktop app (changelog, build, check, publish, GitHub Release). 發佈 RMS 攻略庫新版本：更新紀錄、建置、檢查、publish.sh、Fly.io 部署、桌面版 Release。使用者說「DEPLOY」「發佈」「RELEASE」「上線」時使用。
---

# RMS-RELEASE

Write in STE. See `ste-zh`. 以 STE 撰寫，見 `ste-zh`。

適用範圍：MapleRoyals 攻略庫建置 repo `louis70109/rms-data-build`（私人）。檔名與指令都相對於該 repo。
Scope: the `louis70109/rms-data-build` repo (private). Paths and commands are relative to it.

網站與桌面版是兩條獨立的線：

- 網站與 PWA：推公開 repo `main`，GitHub Actions 執行 `flyctl deploy`，上線到 https://rms-data.fly.dev/。
- 桌面版：公開 repo 的 Release 必須含 `latest.json`。App 啟動時才會發現新版。

**警告：** 只有使用者明確說「發佈」或「DEPLOY」，才可執行 `publish.sh`。只有使用者說「合併」或「MERGE」，才可合併 PR。

## 網站發佈

1. 確認 private `main` 含所有已合併的內容（`git fetch && git status`）。從缺少 PR 的分支發佈會把舊內容蓋回線上。
2. 在 `changelog.json` 最前面加一筆：`id`（唯一）、`date`、`title`、`items[{tag,text}]`。`tag` 用：新功能、新文章、修正、調整。沒有新 `id`，使用者收不到更新彈窗。
3. 執行 `python -I build_spa.py "$PWD"`。
4. 執行 `node pwa/test_sw.mjs sw.js`。
5. 用 `site_query.py` 抽查。確認沒有 `wm-ipp`、`comments-area`、多餘的 `>`，且 `<img src>` 都指向存在的 `assets/…`。
6. 執行 `bash publish.sh <公開repo路徑> "訊息"`。
7. 等 Actions：`gh api 'repos/louis70109/rms-data/actions/runs?per_page=1' --jq '.workflow_runs[0]|[.status,.conclusion,.head_sha[:7]]'`。
8. 執行 `curl -s https://rms-data.fly.dev/sw.js | head -1`。`VERSION` 必須等於本地。
9. 執行 `curl -sI https://rms-data.fly.dev/ | grep -i cache-control`。結果必須是 `no-cache`。
10. commit 並推 private repo。只 `git add` 需要的檔案。

## 桌面版 Release

1. 先完成網站發佈。桌面版內嵌網站內容。
2. 查最新版本：`gh api repos/louis70109/rms-data/tags --jq '.[].name'`。
3. 觸發 Release，二選一：
   - `git tag desktop-vX.Y.Z <commit> && git push origin desktop-vX.Y.Z`
   - `gh api -X POST repos/louis70109/rms-data/actions/workflows/release-desktop.yml/dispatches -f ref=main -f 'inputs[version]=X.Y.Z'`
4. 在 Claude 雲端環境，tag 推送常因 proxy 斷線而失敗。必須改用 workflow_dispatch。
5. 等 "Release desktop app" 完成。
6. 確認 Release 有 `latest.json`、`RMS-Guide-Setup-X.Y.Z.exe`、`RMS-Guide-Portable-X.Y.Z.exe`：`gh api repos/louis70109/rms-data/releases --jq '.[0]|[.tag_name,([.assets[].name]|join(","))]'`。
7. v1.2.0 的 Release 沒有 `latest.json`。該版本無法自動更新，使用者必須手動重裝。

## 禁止

- 不可把來源檔、建置程式、CSV 推到公開 repo。
- 不可動 `nijialin.com` 綁定。
- 不可索取或寫出任何 token。
- `gh pr create` 的 GraphQL 會 403。改用 `gh api repos/<owner>/<repo>/pulls -f title=… -f head=… -f base=main -f body=…`。
