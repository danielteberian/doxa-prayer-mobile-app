# Applied — `ar` (D1 `apply-ar`)

**File written:** `lib/l10n/app_ar.arb` (only file modified by this agent)
**Source of truth:** `REPORT.md` §10.1 (all 25 rows), §6, F-MECH-05 + F-MECH-01
**Applied:** 25 / 25 rows · 21 `@key` blocks · `@feedback` description. **Skipped: none for unusability.**
**Diff:** 99 insertions, 24 deletions.

> **Persistence note:** produced by the D1 subagent and persisted by the orchestrator (subagents are blocked from writing report `.md` files).
>
> **Method:** the 25 final strings were **extracted programmatically** from the REPORT.md §10.1 tables and written via `json.dumps(ensure_ascii=False)` — no Arabic text was retyped or passed through a bidi-rendering editor. All 25 were then re-compared codepoint-by-codepoint against the report after writing.

## In-scope keys (§4)

| # | Key | Before | After |
|---|---|---|---|
| 1 | `allowExactAlarms` | `السماح بالتنبيهات الدقيقة` | `السماح بالمنبّهات الدقيقة` |
| 2 | `enableNotificationsButton` **NEW** | *(absent)* | `تمكين الإشعارات` |
| 3 | `enableNotificationsPromptBody` **NEW** | *(absent)* | `قم بتمكين الإشعارات لتصلك آخر المستجدات عبر الإشعارات الفورية أيضًا.` |
| 4 | `engaged` | `مُنخرَط` | `مُنخرَطة` |
| 5 | `exactAlarmsDisabledStatus` | `التنبيهات الدقيقة غير مسموح بها لتطبيق Doxa، …` | `المنبّهات الدقيقة غير مسموح بها لتطبيق Doxa، لذا قد تصل تذكيرات الصلاة متأخرة بعدة دقائق.` |
| 6 | `exactAlarmsPromptBody` | `… باستخدام التنبيهات الدقيقة.` | `لكي تصل تذكيرات الصلاة في وقتها تمامًا، اسمح لتطبيق Doxa باستخدام المنبّهات الدقيقة.` |
| 7 | `feedbackIntro` | `يسعدنا أن نسمع رأيك. أخبرنا برأيك في التطبيق.` | `يسعدنا أن نسمع منك. أخبرنا برأيك في التطبيق.` |
| 8 | `feedbackSuccessBody` | `تم إرسال تعليقاتك باسم {email}. …` | `تم إرسال تعليقاتك من العنوان {email}. إذا لم يكن هذا هو العنوان الصحيح، فأعد إرسالها بالعنوان الصحيح.` |
| 9 | `feedbackTypeCompliment` | `إطراء` | `إشادة` |
| 10 | `prayerReminderTitle` | `حان وقت الصلاة اليوم؟` | `هل أنت مستعد لصلاة اليوم؟` |
| 11 | `resendVerificationCooldown` | flat: `يُرجى الانتظار {seconds} ثانية قبل طلب رسالة أخرى.` | ICU plural, 6 categories `zero/one/two/few/many/other` (337 chars, verbatim from §10.1) |
| 12 | `resendVerificationCountdown` | flat: `إعادة الإرسال خلال {seconds} ثانية` | ICU plural, 5 categories `one/two/few/many/other` (203 chars, verbatim from §10.1) |
| 13 | `resendVerificationFailed` | `تعذّر إرسال الرسالة. حاول مرة أخرى.` | `تعذّر إرسال الرسالة. يرجى المحاولة مرة أخرى.` |
| 14 | `resendVerificationSent` | `تم إرسال رسالة التحقق. تحقق من صندوق الوارد.` | `تم إرسال رسالة التحقق. تفقَّد صندوق الوارد.` |

## §6.6 placeholder typography — guillemets only

| # | Key | Before | After |
|---|---|---|---|
| 15 | `switchPeopleGroupConfirm` | `… من أجل {currentName} … من أجل {newName}؟` | `هل تريد التوقف عن الدعاء من أجل «{currentName}» والبدء في الدعاء من أجل «{newName}»؟` |

`الدعاء` deliberately **left unchanged** on this key (§6 refusal). Guillemets are U+00AB / U+00BB, no inner space — confirmed programmatically (`«{` and `}»` adjacency).

## Authorised out-of-scope (§6)

| # | Key | Before | After |
|---|---|---|---|
| 16 | `appName` | `صلاة دوكسا` | `Doxa Prayer` |
| 17 | `appVersion` | `الإصدار{version}` | `الإصدار {version}` |
| 18 | `nameLabel` | `الإسم` | `الاسم` |
| 19 | `nextReminderToday` | `اليوم على موقع {time}` | `اليوم في الساعة {time}` |
| 20 | `nextReminderTomorrow` | `غدًا على موقع {time}` | `غدًا في الساعة {time}` |
| 21 | `nextReminderOn` | `{weekday} على الرابط {time}` | `{weekday} في الساعة {time}` |
| 22 | `reminderNotificationBody` | `افتح كتاب «دوكسا» لبدء صلاة اليوم.` | `افتح تطبيق Doxa لبدء صلاة اليوم.` |
| 23 | `reminders` | `تذكير` | `التذكيرات` |
| 24 | `search` | `إبحث` | `ابحث` |
| 25 | `wizardWelcomeBody` | `تساعدك «دوكسا» على الصلاة …` | `تساعدك Doxa على الصلاة من أجل إحدى المجموعات الشعبية غير المُبشَّر بها. سنساعدك في اختيار مجموعة معينة، وضبط تذكير، ومتابعة آخر المستجدات.` |

`wizardWelcomeBody`: **script swap only** — the verb stayed `تساعدك`, per §6's explicit decline of B1's `يساعدك` proposal (verb gender is an Arabic grammar call no Arabic reviewer ruled on).

## Metadata

`@feedback` → `"Button that opens the in-app feedback panel"` (M-02).

**21 `@key` blocks added**, `description` and `placeholders` copied from the **live** `app_en.arb`, not from a findings quote:
`@engaged`, `@feedbackConsentLabel`, `@feedbackError`, `@feedbackIntro`, `@feedbackMessageLabel`, `@feedbackMessageRequired`, `@feedbackNameLabel`, `@feedbackRateLimited`, `@feedbackSubmit`, `@feedbackSuccessBody` (+`placeholders.email`), `@feedbackSuccessTitle`, `@feedbackTypeCompliment`, `@feedbackTypeLabel`, `@feedbackTypeProblem`, `@feedbackTypeRequired`, `@feedbackTypeSuggestion`, `@prayerReminderTitle`, `@prayerReminderBody` (+`placeholders.peopleGroup`), `@dismissReminderLabel`, `@enableNotificationsButton`, `@enableNotificationsPromptBody`.

**M-08 confirmed:** `@enableNotificationsButton` carries the **live** text *"Button that requests OS notification permission so the user can receive push notifications"* — not B1's stale quote.

**Placement.** `app_ar.arb` stores all `@` blocks first, then all strings, the `@` section mirroring the string section's order (verified before editing: mirror = True). New `@` blocks were placed at the mirroring position; the two new strings went into the alphabetical slot after `enableNotifications`. Note the file is *not* fully sorted (`emailsLoadError` at string index 80, `engaged` at 30), so "between `emailsLoadError` and `engaged`" was applied as the **alphabetical slot**, not literal adjacency. **Nothing was re-sorted** — zero whitespace-only or reordering churn; the pre-existing compact `"peopleGroup": { "type": "String" }` formatting in `@prayForPeopleGroupLabel` was preserved byte-identically.

## Keys skipped, with reason

| Key | Reason |
|---|---|
| `nPeopleGroups` | §6 **REFUSED** — Arabic dual / 3–10 plural forms never determined; a `<GAP: …>` must not ship. Byte-identical to `HEAD`. |
| `nRemindersSet` | Same. Byte-identical to `HEAD`. |
| `switchPeopleGroupConfirm`'s `الدعاء` → `الصلاة` | §6 **REFUSED** (A1 declined to propose a replacement). Guillemets only. |
| `dismissNextReminder` | §6 **REFUSED**. Byte-identical to `HEAD`. |
| `updateRequiredBody` | §6 **REFUSED**. Byte-identical to `HEAD`. |
| Diacritic variance (`تعذر`/`تعذّر`, `يرجى`/`يُرجى`) | §6 **REFUSED** — not normalised. |

## Verification results (all actual)

1. **Valid JSON — PASS.** 340 top-level entries. No BOM, no CRLF, no tabs, trailing newline present.
2. **Placeholder parity — PASS.** Every string's placeholder name-set identical to `app_en.arb`'s (0 mismatches / 170 keys). `@`-block `placeholders` sub-objects also match (0 mismatches). Nothing dropped, added, or translated.
3. **Key-set equality — PASS.** 170 = 170; missing `[]`, extra `[]`, removed `[]`. 2 strings added.
4. **`@key` coverage — PASS.** 170 blocks for 170 keys; missing `[]`, orphan `[]`.
5. **Brand — PASS.** `دوكسا` occurs **0 times**. `Doxa` in Latin script in 13 strings.
6. **ICU — PASS.** All 170 strings brace-balanced. `resendVerificationCooldown` → `[zero, one, two, few, many, other]`; `resendVerificationCountdown` → `[one, two, few, many, other]`; `nPeopleGroups`/`nRemindersSet` → `[=0, =1, other]` (untouched). All have an `other` branch.

**Extra RTL-integrity check (not eyeballed):** all 25 final strings compared as integer codepoint sequences against REPORT.md — **25/25 exact match**. No permutation; zero bidi control characters (checked U+200E/200F/202A–202E/2066–2069/200B/FEFF and any `Cf`-category codepoint).
