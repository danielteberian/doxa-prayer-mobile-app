# Applied — `pt` (D4 `apply-pt`)

**File written:** `lib/l10n/app_pt.arb` (only file modified by this agent)
**Work list:** `REPORT.md` §10.4 (14 string rows) + §6.6 typography + M-01 (21 `@key` blocks) + M-02 (`@feedback`)
**Applied:** 14 / 14 string rows · 21 / 21 `@key` blocks · 1 / 1 `@feedback` description. **Skipped: none.**
**Variant:** left **Brazilian** throughout — nothing corrected toward European Portuguese; `engaged` = `Engajado` and the `o Doxa` / `a Doxa` split untouched.

> **Persistence note:** produced by the D4 subagent and persisted by the orchestrator (subagents are blocked from writing report `.md` files).
>
> **Method:** all quote characters were built in `python3` from `“`/`”` literals and the file written with `ensure_ascii=False`; the substitution was never typed inline into the `.arb`.

## A. New keys added (B-01)

Both inserted at their alphabetical position, immediately after `enableNotifications` and before `engagementStatus`/`engaged` — i.e. between `emailsLoadError` and `engaged` in sort order. Each carries its `@key` block.

| Key | Value written |
|---|---|
| `enableNotificationsButton` | `Ativar notificações` |
| `enableNotificationsPromptBody` | `Ative as notificações para receber as novidades também por notificações push.` |

## B. String rows changed

§10.4 in-scope keys:

| Key | Before | After |
|---|---|---|
| `feedbackConsentLabel` | `Mantenha-me atualizado com as novidades da Doxa` | `Quero receber novidades da Doxa` |
| `feedbackIntro` | `Adoraríamos ouvir você. Conte-nos o que acha do aplicativo.` | `Adoraríamos ouvir você. Conte-nos o que você acha do aplicativo.` |
| `feedbackSuccessBody` | `Seus comentários foram enviados como {email}. Se não for o endereço correto, envie-os novamente com o endereço certo.` | `Seus comentários foram enviados como {email}. Se esse não for o endereço certo, envie-os novamente com o correto.` |
| `prayForPeopleGroupLabel` | `Orar por {peopleGroup}` | `Orar por “{peopleGroup}”` |
| `prayerReminderBody` | `Toque para orar por {peopleGroup}.` | `Toque para orar por “{peopleGroup}”.` |
| `prayerReminderTitle` | `Tudo pronto para orar hoje?` | `Tudo pronto para a oração de hoje?` |
| `resendVerificationSent` | `E-mail de verificação enviado. Verifique sua caixa de entrada.` | `E-mail de verificação enviado. Confira sua caixa de entrada.` |

§6.6 placeholder typography on approved keys — delimiters only, wording untouched:

| Key | Before | After |
|---|---|---|
| `peopleGroupIntroTitle` | `Ore por {name}` | `Ore por “{name}”` |
| `scanToPray` | `Escaneie o código para baixar o aplicativo e orar por {name}` | `… e orar por “{name}”` |
| `shareMessage` | `Ore comigo por {name} — baixe o aplicativo Doxa Prayer:` | `Ore comigo por “{name}” — baixe o aplicativo Doxa Prayer:` (em dash U+2014 preserved) |
| `switchPeopleGroupConfirm` | `Você quer parar de orar por {currentName} e começar a orar por {newName}?` | `Você quer parar de orar por “{currentName}” e começar a orar por “{newName}”?` |
| `wizardConfirmPeopleGroupTitle` | `Orar por {name}?` | `Orar por “{name}”?` |

**Delimiter decision applied:** curly double quotes **U+201C / U+201D**, no inner space. Not guillemets (European tradition, would contradict the pt-BR variant) and not ASCII `"`. Question marks and sentence periods stay **outside** the closing quote.

## C. Metadata

- **`@feedback`** — `"Button that opens the feedback page in the browser"` → `"Button that opens the in-app feedback panel"`. Confirmed identical to the live `app_en.arb` value, read at apply time (M-08).
- **21 `@key` blocks added**, each with `description` (and `placeholders` where present) copied verbatim from the **live** `app_en.arb`: `@dismissReminderLabel`, `@enableNotificationsButton`, `@enableNotificationsPromptBody`, `@engaged`, `@feedbackConsentLabel`, `@feedbackError`, `@feedbackIntro`, `@feedbackMessageLabel`, `@feedbackMessageRequired`, `@feedbackNameLabel`, `@feedbackRateLimited`, `@feedbackSubmit`, `@feedbackSuccessBody` (+`placeholders.email`), `@feedbackSuccessTitle`, `@feedbackTypeCompliment`, `@feedbackTypeLabel`, `@feedbackTypeProblem`, `@feedbackTypeRequired`, `@feedbackTypeSuggestion`, `@prayerReminderBody` (+`placeholders.peopleGroup`), `@prayerReminderTitle`.
  - The live `@enableNotificationsButton` description is *"Button that requests OS notification permission so the user can receive push notifications"* — confirming M-08's warning that the F-MECH-01 quote was stale.
  - Blocks inserted at their alphabetical position relative to the existing `@` sequence (`@engaged` before `@engagementStatus`, the `feedback*` cluster before `@finish`, `@prayerReminder*` after `@prayForPeopleGroupLabel`). No existing key or block was moved, reordered, or removed.

## D. Skipped / not applied

**Nothing skipped.** Every §10.4 row was usable verbatim; no report string had to be rejected.

Explicitly left alone per §10.4's "not to be changed" list: `engaged` = `Engajado`, `dailyPrayerCoverage` = `Cobertura de oração diária`, `forwardLabel` = `Avançar`, the `alarmes exatos` cluster (`allow`, `allowExactAlarms`, `exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`), `partial` = `Parcial`, `signUp` = `Inscrever-se`, the `{seconds} s` unit space, and the `o Doxa` (app) / `a Doxa` (ministry) article split — **not harmonised**.

`nPeopleGroups` / `nRemindersSet` untouched: F-MECH-02's same-class sweep found `pt` correct for all integer inputs, and no `pt` plural change is authorised in §6.

## E. Verification results (all actual, run post-write)

1. **Valid JSON — PASS.** 30,999 bytes; no BOM, no CRLF, no tabs, trailing newline present; no duplicate top-level keys (checked with an `object_pairs_hook` counter).
2. **Placeholder parity — PASS.** All 170 keys compared name-set to name-set against English: **zero mismatches**; none dropped, added, or translated. `{email}`, `{seconds}`, `{time}`, `{weekday}`, `{version}`, `{count}` all intact and bare.
3. **Key-set parity — PASS.** pt 170 / en 170; set difference empty in both directions.
4. **`@key` coverage — PASS.** 170 strings / 170 blocks; zero missing, zero orphans.
5. **Codepoint audit — PASS.** U+201C/U+201D appear in exactly the **7** keys named in the report and nowhere else: `prayForPeopleGroupLabel`, `prayerReminderBody`, `peopleGroupIntroTitle`, `scanToPray`, `shareMessage`, `switchPeopleGroupConfirm` (2 pairs), `wizardConfirmPeopleGroupTitle`. Every name-like placeholder wrapped as `“{x}”` with **no inner space**; no numeric/technical placeholder wrapped. **Zero guillemets** (`«`/`»`), **zero ASCII `"`** in any value, zero U+2018/2019/201A/201E/2039/203A. Codepoints > U+2000 present in the whole file: exactly `0x2014`, `0x201c`, `0x201d`. Question marks and the sentence period sit outside the closing quote where applicable.
6. **ICU — PASS.** The only ICU strings are `nPeopleGroups` and `nRemindersSet` (both unchanged); brace depth returns to 0 with no negative excursion. No new string introduces a brace other than a placeholder. Invisible-character scan (Cf / non-ASCII Zs) across every value: **none**.

> `flutter gen-l10n` was deliberately **not** run by this agent — it would rewrite all five locales' Dart while four siblings were still writing. Generation belongs to Phase 4, once.
