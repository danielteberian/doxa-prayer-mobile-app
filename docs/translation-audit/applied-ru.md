# Applied — `ru` (D5 `apply-ru`)

**File written:** `lib/l10n/app_ru.arb` (only file modified by this agent)
**Source of truth:** `REPORT.md` §10.5, applied character-for-character. **0 substitutions, 0 skips from the change set.**
**Totals:** 14 string values changed · 2 new string keys added · 22 `@` blocks added/corrected (21 added + `@feedback` replaced) · 0 keys removed · file re-sorted: no.

> **Persistence note:** produced by the D5 subagent and persisted by the orchestrator (subagents are blocked from writing report `.md` files).

## 1. In-scope keys (§4) — 9 rows

| # | Key | Before | After |
|---|---|---|---|
| 1 | `dailyPrayerCoverage` | `Ежедневное молитвенное покрытие` | `Ежедневный молитвенный охват` |
| 2 | `emailsLoadError` | `Не удалось загрузить ваши адреса.` | `Не удалось загрузить ваши адреса электронной почты.` |
| 3 | `enableNotificationsButton` **NEW** | *absent (English fallback)* | `Включить уведомления` |
| 4 | `enableNotificationsPromptBody` **NEW** | *absent (English fallback)* | `Включите уведомления, чтобы получать новости также в push-уведомлениях.` |
| 5 | `feedbackConsentLabel` | `Держите меня в курсе новостей от Doxa` | `Хочу получать новости от Doxa` |
| 6 | `prayForPeopleGroupLabel` | `Помолиться за «{peopleGroup}»` | `Помолиться за народ «{peopleGroup}»` |
| 7 | `prayerReminderBody` | `Нажмите, чтобы помолиться за «{peopleGroup}».` | `Нажмите, чтобы помолиться за народ «{peopleGroup}».` |
| 8 | `prayerReminderTitle` | `Готовы помолиться сегодня?` | `Готовы к сегодняшней молитве?` |
| 9 | `resendVerification` | `Отправить письмо для подтверждения ещё раз` | `Отправить письмо повторно` |

**B-02 note (row 1):** applied with the masculine adjective ending — `Ежедневное` → `Ежедневный`, because `охват` is masculine where `покрытие` was neuter. The glossary was **independently re-checked before writing** rather than trusting the report quote: `glossary.ru_RU.md` §3's entry heading is «24-часовой молитвенный охват», its *Почему это важно* block carries the explicit warning «Избегайте прочтения "охвата" как страхового или юридического термина», and the §9 label table repeats «24-часовой молитвенный охват». `охват` confirmed; `ru.tsv`'s `покрытие` correctly loses. Slot shortens 31 → 28 chars.

## 2. §6.6 placeholder typography — 1 row

| # | Key | Before | After |
|---|---|---|---|
| 10 | `scanToPray` | `…и помолитесь за {name}` | `…и помолитесь за «{name}»` |

**Not skipped.** The plan's §6.6 table was **wrong for `ru`** (§5 records the correction) — this was the file's single bare name-like placeholder. Guillemets only; «народ» deliberately **not** added, per the §10.5 caveat.

## 3. Authorised out-of-scope (§6) — 4 rows

| # | Key | Before | After |
|---|---|---|---|
| 11 | `appVersion` | `Версия{version}` | `Версия {version}` |
| 12 | `nPeopleGroups` | `{count, plural, =0{Нет народов} =1{1 народ} other{{count} народов}}` | `{count, plural, =0{Нет народов} one{{count} народ} few{{count} народа} many{{count} народов} other{{count} народов}}` |
| 13 | `nRemindersSet` | `{count, plural, =0{Напоминаний не установлено} =1{Установлено 1 напоминание} other{Установлено {count} напоминаний}}` | `{count, plural, =0{Напоминаний не установлено} one{Установлено {count} напоминание} few{Установлено {count} напоминания} many{Установлено {count} напоминаний} other{Установлено {count} напоминаний}}` |
| 14 | `prayerThankYouVerse` | `…за все благодарите;…` | `…за всё благодарите;…` (single-character `ё` fix, rest of the verse byte-identical) |

## 4. Metadata

- `@feedback` `description`: → **`"Button that opens the in-app feedback panel"`** (M-02).
- **21 `@` blocks added**, each `description` (and `placeholders`) copied from the **live** `app_en.arb`, not from any report quote (M-08 respected — `@enableNotificationsButton` carries the live *"Button that requests OS notification permission so the user can receive push notifications"*): `@dismissReminderLabel`, `@enableNotificationsButton`, `@enableNotificationsPromptBody`, `@engaged`, `@feedbackConsentLabel`, `@feedbackError`, `@feedbackIntro`, `@feedbackMessageLabel`, `@feedbackMessageRequired`, `@feedbackNameLabel`, `@feedbackRateLimited`, `@feedbackSubmit`, `@feedbackSuccessBody` (+`placeholders.email`), `@feedbackSuccessTitle`, `@feedbackTypeCompliment`, `@feedbackTypeLabel`, `@feedbackTypeProblem`, `@feedbackTypeRequired`, `@feedbackTypeSuggestion`, `@prayerReminderBody` (+`placeholders.peopleGroup`), `@prayerReminderTitle`.

**Placement.** `app_ru.arb` keeps all `@` blocks in one leading region and all strings in a second, each an originally-sorted run with a previously-appended out-of-order tail. **Nothing was re-sorted.** New keys went to their true alphabetical position inside the sorted run: the two new strings immediately after `enableNotifications`; the 15 `@feedback*` blocks between `@feedback` and `@finish`; `@dismissReminderLabel` between `@dismissNextReminder` and `@donate`; the two `@prayerReminder*` between `@prayedToday` and `@prayerStatus`. The diff contains **zero** unrelated reordering or whitespace churn — the file's pre-existing inline `"peopleGroup": { "type": "String" }` formatting in `@prayForPeopleGroupLabel` was preserved byte-for-byte.

## 5. Skipped / deliberately not touched

| Key | Reason |
|---|---|
| `updateRequiredBody` | §6 **REFUSED** as cosmetic. Untouched. |
| `engaged` = `Вовлечён` | §10.5 explicit retention (short predicative form, agrees with «народ»). Not re-litigated. |
| `partial` = `Частично` | §10.5 explicit retention; §6.7 refuted on code evidence. |
| `forwardLabel` = `Вперёд` | §6.8 refuted — pairs with Flutter's own `backButtonTooltip` («Назад»). |
| `точные будильники` cluster (4 keys) | A-11: descriptive term kept in `ru`. |
| `signUp` = `Зарегистрироваться` | Glossaried, despite 2.57× length (M-11: no hard overflow possible). |
| `{seconds} с` unit space, `почта` for *inbox* | Deliberate `ru` conventions, ratified. |

**Nothing from §10.5 was skipped and no string was substituted.** All 14 rows were usable as written.

## 6. Verification results (all actual)

**1. Valid JSON — PASS.** 340 top-level keys. No duplicate top-level keys, no BOM, no CRLF, no tabs, trailing newline present.

**2. Placeholder parity — PASS.** All 170 string keys compared with an ICU-aware extractor: **0 mismatches** — none dropped, added, renamed or translated. `@`-block `placeholders` sub-objects also compared: **0 mismatches**. Name-like placeholders now guillemeted 7/7 (`prayForPeopleGroupLabel`, `peopleGroupIntroTitle`, `prayerReminderBody`, `scanToPray`, `shareMessage`, `switchPeopleGroupConfirm` ×2, `wizardConfirmPeopleGroupTitle`); numeric/technical placeholders bare 18/18. No inner-space guillemets anywhere.

**3. Key-set equality — PASS.** `set(ru) == set(en)`, 340 = 340. Missing none, extra none, zero deletions.

**4. `@key` coverage — PASS.** 170 strings / 170 blocks; 0 without a block, 0 orphans, 0 blocks lacking a `description`. Was 168/149.

**5. Plural fix — PASS.** Both keys contain `=0{`, `one{`, `few{`, `many{`, `other{`; braces balanced. **Simulation** re-implementing `Intl.pluralLogic` (intl 0.20.2: exact shortcuts at 0/1/2, then the CLDR rule; `two` absent → `TWO` falls to `few`) plus Russian CLDR (`ONE: i%10==1 && i%100!=11`; `FEW: i%10∈2–4 && i%100∉12–14`; `MANY: i%10==0 ∨ i%10∈5–9 ∨ i%100∈11–14`). Verified against the generated `app_localizations_ru.dart:24-33` that `=0`→`zero:` and `=1`→`one:`, confirming F-MECH-02's root cause:

| count | CLDR cat | branch | `nPeopleGroups` OLD | `nPeopleGroups` NEW |
|---|---|---|---|---|
| 0 | MANY | `zero` (exact) | Нет народов | Нет народов ✅ |
| 1 | ONE | `one` | 1 народ | 1 народ ✅ |
| 2 | FEW | `few` | 2 народ**ов** ❌ | 2 народ**а** ✅ |
| 5 | MANY | `many` | 5 народов | 5 народов ✅ |
| **21** | ONE | `one` | **1 народ** ❌ | **21 народ** ✅ |
| 22 | FEW | `few` | 22 народ**ов** ❌ | 22 народ**а** ✅ |
| **31** | ONE | `one` | **1 народ** ❌ | **31 народ** ✅ |
| **101** | ONE | `one` | **1 народ** ❌ | **101 народ** ✅ |

| count | CLDR cat | branch | `nRemindersSet` OLD | `nRemindersSet` NEW |
|---|---|---|---|---|
| 0 | MANY | `zero` (exact) | Напоминаний не установлено | Напоминаний не установлено ✅ |
| 1 | ONE | `one` | Установлено 1 напоминание | Установлено 1 напоминание ✅ |
| 2 | FEW | `few` | Установлено 2 напоминани**й** ❌ | Установлено 2 напоминани**я** ✅ |
| 5 | MANY | `many` | Установлено 5 напоминаний | Установлено 5 напоминаний ✅ |
| **21** | ONE | `one` | **Установлено 1 напоминание** ❌ | **Установлено 21 напоминание** ✅ |
| 22 | FEW | `few` | Установлено 22 напоминани**й** ❌ | Установлено 22 напоминани**я** ✅ |
| **31** | ONE | `one` | **Установлено 1 напоминание** ❌ | **Установлено 31 напоминание** ✅ |
| **101** | ONE | `one` | **Установлено 1 напоминание** ❌ | **Установлено 101 напоминание** ✅ |

All eight counts now grammatical for both keys; every previously-wrong cell is fixed and no previously-correct cell regressed. `=0` confirmed safe — reached only by the exact-0 shortcut, never by a CLDR category (0 classifies as `MANY` in Russian, so the branch cannot capture 10, 20, 100 …).

**6. No mojibake — PASS.** U+FFFD count **0**. 4,024 Cyrillic codepoints intact. `ё` count **12** (net unchanged: `prayerThankYouVerse` gained one via «всё», `resendVerification` lost one by dropping «ещё раз»); `Вперёд`, `Подтверждён`, `ещё`, `всё`, `своё`, `моём` all present. The only non-ASCII non-Cyrillic characters in the whole file are U+00AB `«` ×13, U+00BB `»` ×13, U+2013 en dash and U+2014 em dash — no stray U+2019/U+202F/U+00A0, no accidental smart quotes. `Doxa` appears 16× in Latin script, never transliterated.

> `flutter gen-l10n` was **not** run by this agent (four siblings were concurrently writing). Assigned to Phase 4.
