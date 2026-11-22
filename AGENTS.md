# AGENTS.md

<!-- louis70109/skills:start -->
## Skills
Before any action, read and apply the skill `skill-router`.
Find it at `<folder>/skill-router/SKILL.md`. Look in `.claude/skills/`, `.agents/skills/`, `skills/`, `~/.claude/skills/`, and `~/.agents/skills/`.
If you cannot find it, tell the user.
<!-- louis70109/skills:end -->

## This repo 本 repo

This repo is the base layer. Each project adds its own layer in `.agents/` (see `repo-memory`). The routing table is in `skills/skill-router/SKILL.md`.
本 repo 是基礎層。各專案在 `.agents/` 加上自己的專案層（見 `repo-memory`）。路由表在 `skills/skill-router/SKILL.md`。

- The block above must stay the same as section 5 of `skills/repo-memory/SKILL.md`. 上方區塊必須與 `repo-memory` 第 5 節相同。

## Add a new skill 新增 skill

Follow these rules for each new skill. 新增 skill 時必須遵守：

1. **Read** the routing table in `skills/skill-router/SKILL.md` first. Do not repeat a rule that another skill has. Link to that skill. 先讀路由表；不重複其他 skill 已有的規則，改為連結。
2. **Add a row** to that table in the same change. A skill without a row is not valid. Write a clear "When" that an agent can match. Add "Signals" if files or code show the need. 同一次變更中新增一列；未登記的 skill 無效；「情境」必須清楚到 agent 能比對；檔案或程式碼能看出需求時，填寫「訊號」。
3. **Put** the skill at `skills/<name>/SKILL.md`. The front matter needs `name` and `description`. The `description` says when to use it, in EN and ZH. 放在 `skills/<name>/SKILL.md`；front matter 需有 `name` 與中英文 `description`（說明何時使用）。
4. **Start** the skill body with: "Write in STE. See `ste-zh`." 內文開頭加：「Write in STE. See `ste-zh`.」
5. **Keep** it short. Apply `skills/minimal-dev/SKILL.md` to the skill itself. 保持精簡，skill 本身也套用 minimal-dev。
6. **Check** if an existing row, `review-code`, or `security-checklist` must link to the new skill. Update them. 檢查是否需讓既有列、`review-code`、`security-checklist` 連結新 skill，並一併更新。
7. **Commit** the skill and the table change together. 新 skill 與表格變更同一個 commit。

## Upstream skills 上游 skill

Some skills come from another repo. `upstream.json` lists each one, its source, the pinned commit, and the mode.
部分 skill 來自其他 repo。`upstream.json` 列出每個 skill、來源、鎖定的 commit 與模式。

| Skill | Source 來源 | Mode 模式 | License 授權 |
|---|---|---|---|
| `taste-skill` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | external | MIT, `LICENSE` in the installed folder |
| `skills/asd-ste100` | [danyuchn/asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) | sync | MIT, `skills/asd-ste100/LICENSE` |
| `skills/ste-zh` | [danyuchn/asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) | notify | MIT, `skills/ste-zh/LICENSE` |

- **sync**: an exact copy of the source. Do not edit its files. The next sync replaces them. Rules 3 and 4 above do not apply. sync：來源的完整複本。不可修改，下次同步會覆蓋。上方第 3、4 條不適用。
- **external**: not stored in this repo (it is large and has scripts). Install the pinned commit with APM (see README, "外部 skill"). Its folder is `taste-skill` and its front matter name is `design-taste-frontend`. Rules 3 and 4 above do not apply. external：不放在此 repo（體積大且含腳本）。用 APM 安裝鎖定的 commit（見 README「外部 skill」）。上方第 3、4 條不適用。
- **notify**: an adaptation of the source. A person updates it by hand. notify：來源的改編版，由人工更新。
- `skills/asd-ste100` is the original of `ste-zh`. It has no routing row. Agents apply `ste-zh` (row 0). `skills/asd-ste100` 是 `ste-zh` 的原文，不列入路由表。代理套用 `ste-zh`（第 0 列）。

The workflow `.github/workflows/upstream-sync.yml` runs each Sunday. When a source changes:
工作流程 `.github/workflows/upstream-sync.yml` 每週日執行。來源有變更時：

1. For a **sync** skill, it opens one PR that copies the new files. Read the upstream diff before you merge (`skills/security-checklist/SKILL.md` section 1). sync：開一個 PR 複製新檔案。合併前必須先讀上游 diff。
2. For a **notify** skill, it opens one issue with the upstream diff. Update the skill. Then set its `commit` in `upstream.json` to the new commit. The issue stays open until you do this. notify：開一個 issue，附上游 diff。更新 skill 後，將 `upstream.json` 中的 `commit` 改為新 commit。改之前 issue 會持續存在。
3. For an **external** skill, it opens one issue. Read the upstream diff, set `commit` in `upstream.json` to the new commit, then reinstall it with APM. external：開一個 issue。讀上游 diff，將 `commit` 改為新 commit，再用 APM 重新安裝。

To add an upstream skill: copy the source and its `LICENSE`, add an entry to `upstream.json`, and add a row to the routing table in `skills/skill-router/SKILL.md`. 新增上游 skill：複製來源與 `LICENSE`，在 `upstream.json` 新增一筆，並在路由表新增一列。
