---
name: ste-zh
description: Use before any task. Think and write in ASD-STE100 Simplified Technical English (EN) and concise Traditional Chinese (ZH). 任何工作開始前先使用：以 ASD-STE100 簡化技術英文與精簡繁體中文思考與撰寫。
---

# STE-ZH

Apply to every plan, reply, comment, commit message, and doc. 適用於所有計畫、回覆、註解、commit 訊息與文件。

## Rules 規則

| # | EN (ASD-STE100) | ZH 中文 |
|---|---|---|
| 1 | One topic per sentence. Max 20 words (procedure: 25). | 一句一事。最多 30 字。 |
| 2 | Use active voice. Use simple present tense. | 用主動語態，避免被動與冗詞。 |
| 3 | Use approved words only. One word = one meaning. Do not use synonyms. | 同一概念只用一個詞，全文一致。 |
| 4 | Start a command with a verb: "Open the file." | 指令以動詞開頭：「開啟檔案。」 |
| 5 | Use "must" for required, "can" for allowed. Do not use "should". | 「必須」表強制，「可以」表允許。 |
| 6 | Use articles (the, a). Do not drop them. | 不省略主詞與受詞。 |
| 7 | Use a list for steps. One action per step. | 步驟用編號清單，一步一動作。 |
| 8 | Put the warning before the step. | 警告放在步驟之前。 |
| 9 | No idiom, no slang, no figure of speech. | 不用成語、俚語、比喻。 |
| 10 | Use the same noun every time. Do not use "it" if unclear. | 名詞固定；指代不明時重複名詞。 |

## Workflow 流程

1. **Restate** the task in 1–2 STE sentences. 以 1–2 句 STE 重述任務。
2. **List** steps. One action each. 列出步驟，一步一動作。
3. **Do** the steps. Write code, docs, and messages in STE. 執行；程式註解、文件、訊息皆用 STE。
4. **Check** each sentence against the rules. 逐句對照規則檢查。
5. **Report** the result: what changed, what was not done. 回報：改了什麼、未做什麼。

## Output 輸出

- Reply language = user language. If the user writes ZH, give ZH first, then EN in the same structure.
  回覆語言跟隨使用者；使用者用中文時，先中文，再附結構相同的英文。
- Code identifiers, commit messages, and code comments: EN (STE).
  程式識別字、commit 訊息、程式註解：英文（STE）。
- Keep it short. Remove words that add no fact. 保持簡短，刪除無資訊的字。

## Example 範例

- ✗ "You might want to consider possibly running the tests."
- ✓ "Run the tests." / 「執行測試。」
