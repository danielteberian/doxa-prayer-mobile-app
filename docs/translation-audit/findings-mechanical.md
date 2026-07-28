# Findings — mechanical

**Agent:** B1 `mechanical`
**Scope:** structural / ICU / file-hygiene, all six `lib/l10n/app_*.arb` + `lib/` reachability
**Checks run:** 8 / 8, all six files
**Method:** all results below are computed, not eyeballed. Throwaway scripts parsed the six `.arb` files with `json` + `object_pairs_hook`, diffed key sets against `git show 3f58613:lib/l10n/app_en.arb`, extracted `{ident}` tokens by regex, hand-parsed the ICU `plural` bodies, and re-implemented `Intl.pluralLogic` from `~/.pub-cache/hosted/pub.dev/intl-0.20.2/lib/intl.dart` plus the CLDR rules in `src/plural_rules.dart` to render every plural at 15 representative counts.
**Files written by the agent:** none. No `.arb`, no `app_localizations*.dart`, nothing under `../translation/`.

> **Persistence note (orchestrator):** produced by the B1 subagent and persisted by the orchestrator, because subagents are blocked from writing findings files. Content is the agent's, unaltered in substance.
>
> **Byte-fragile content — three warnings from the agent for D1–D5:**
> 1. The French U+202F narrow no-break spaces in F-MECH-09 are visually identical to a normal space. This document **describes** them ("U+202F before `;`") rather than embedding them, precisely so they cannot be silently degraded. Insert the codepoint explicitly.
> 2. The Arabic RTL strings in F-MECH-04/06/11 can reorder if passed through a bidi-naive editor. Verify after applying.
> 3. `<A1: dual>` / `<A1: 3–10 plural>` are **intentional gaps for the Arabic reviewer**, not text to apply literally.

**Baseline confirmed:** `app_en.arb` gained exactly **46** keys since `3f58613` and lost exactly **2** (`newsSignupThanks`, `prayerCoverage24h`). Each locale file holds 168 strings vs English's 170.

## Check × result matrix

| # | Check | en | ar | es | fr | pt | ru |
|---|---|---|---|---|---|---|---|
| 1 | Missing keys (vs `app_en.arb`) | n/a | **2** | **2** | **2** | **2** | **2** |
| 2 | ICU placeholder integrity (name sets) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2b | Placeholder adjacency / spacing | ✅ | ❌ `appVersion` | ✅ | ⚠ NBSP variance | ✅ | ❌ `appVersion` |
| 3 | Plural/select parses, braces balanced | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3b | Plural **category adequacy** | ✅ | ❌ 2 keys (no `two`/`few`) | ✅ | ❌ 1 key (stray `s`) | ✅ | ❌ 2 keys (`one` fires at 21/31/101) |
| 4 | `@key` block present for every key | ✅ 170/170 | ❌ **19 missing** | ❌ **19 missing** | ❌ **19 missing** | ❌ **19 missing** | ❌ **19 missing** |
| 4b | `@key` description matches English | n/a | ⚠ 1 drifted | ⚠ 1 drifted | ⚠ 1 drifted | ⚠ 1 drifted | ⚠ 1 drifted |
| 5 | Dead keys (not in `app_en.arb`) | n/a | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 |
| 6 | 46 new keys reachable from `lib/` | ✅ 46/46 | — | — | — | — | — |
| 6b | Dart refs missing from `app_en.arb` | ✅ 0 | — | — | — | — | — |
| 6c | Un-localised English literal in `lib/` | ❌ 1 (`'Retry'`) | — | — | — | — | — |
| 7 | Constrained-slot length ≤ 1.6× en | ✅ | ⚠ 1 over | ⚠ 1 over | ⚠ 4 over | ⚠ 1 over | ⚠ 3 over |
| 8 | `Doxa` untranslated, Latin script | ✅ 13/13 | ❌ 3 of 13 transliterated | ✅ 13/13 | ✅ 13/13 | ✅ 13/13 | ✅ 13/13 |
| — | Valid JSON / no BOM / no CRLF / no tabs | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| — | Duplicate top-level keys | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 |
| — | Empty string values | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 | ✅ 0 |

Legend: ✅ clean · ⚠ finding at Minor/Note · ❌ finding at Major/Blocker.

**Severity totals:** 3 Blockers · 5 Major · 3 Minor · 6 Note = **17 findings**.

## Findings

### F-MECH-01 · Blocker · check 1 — two keys absent from all five locales

- **Keys:** `enableNotificationsButton`, `enableNotificationsPromptBody`
- **Status:** §6.1 **CONFIRMED**, and the list is **exhaustive** — these are the *only* two keys in `app_en.arb` absent from any locale file. Verified by set difference against all five.
- **English:** `enableNotificationsButton` = `"Enable notifications"`; `enableNotificationsPromptBody` = `"Enable notifications to also receive updates in push notifications."`
- **Effect:** falls back to the template, so every non-English user sees English in `lib/components/notifications/enable_notifications_prompt.dart` (lines 83 and 89) — a body paragraph and a full-width button on the post-signup and updates-settings screens.
- **Proposed:** translations come from A1–A5. D1–D5 add each key **plus its `@key` block**, copied verbatim from `app_en.arb`:

```json
    "@enableNotificationsButton": {
      "description": "Button that asks the OS for notification permission"
    },
    "@enableNotificationsPromptBody": {
      "description": "Explains why to enable OS notifications after signing up for updates"
    },
```

Phase 3 must re-read these from `app_en.arb` rather than trust the quote, since a description edit could land in between.

### F-MECH-02 · Blocker · check 3b — Russian plurals print the literal `1` at counts 21, 31, 41, 101…

- **Keys:** `nPeopleGroups`, `nRemindersSet` (`ru` only)
- **Current:**
  - `nPeopleGroups` = `{count, plural, =0{Нет народов} =1{1 народ} other{{count} народов}}`
  - `nRemindersSet` = `{count, plural, =0{Напоминаний не установлено} =1{Установлено 1 напоминание} other{Установлено {count} напоминаний}}`
- **Root cause (verified in the generated Dart and in the `intl` source):** `gen-l10n` does **not** compile `=1` to an exact-value match. It emits the branch as the `one:` argument of `Intl.pluralLogic` — see `lib/l10n/app_localizations_ru.dart:24-33` and `:326-338`. `pluralLogic` only shortcuts `howMany == 1`; for any other count it consults the locale's CLDR rule, and Russian's `ONE` category is `n % 10 == 1 && n % 100 != 11`. Since `one` is non-null, **21, 31, 41, 51, 101 … all return the hardcoded `=1` string.**
- **Failure scenario (computed):**

  | count | ru `nPeopleGroups` renders | should read |
  |---|---|---|
  | 1 | `1 народ` | ✅ |
  | 2 | `2 народов` | `2 народа` |
  | 3 | `3 народов` | `3 народа` |
  | 5 | `5 народов` | ✅ |
  | **21** | **`1 народ`** | `21 народ` |
  | 22 | `22 народов` | `22 народа` |
  | **31** | **`1 народ`** | `31 народ` |
  | **101** | **`1 народ`** | `101 народ` |

  Same shape for `nRemindersSet`: count 21 → `Установлено 1 напоминание`.
- **Reachability:** `nPeopleGroups(filtered.length)` at `lib/components/widgets/people_groups_list.dart:137` is the results-count caption above the people-group list. The unfiltered IMB list is far larger than 21, so a Russian user hits this on the search screen routinely. `nRemindersSet(total)` at `lib/components/cards/reminders_summary.dart:23` has the same defect at a less reachable count.
- **Proposed:** replace the `=0/=1/other` skeleton with real CLDR categories. The category structure is unambiguous; the noun forms are the standard Russian paradigm and should be confirmed by A5.

```json
    "nPeopleGroups": "{count, plural, =0{Нет народов} one{{count} народ} few{{count} народа} many{{count} народов} other{{count} народов}}",
    "nRemindersSet": "{count, plural, =0{Напоминаний не установлено} one{Установлено {count} напоминание} few{Установлено {count} напоминания} many{Установлено {count} напоминаний} other{Установлено {count} напоминаний}}",
```

  Note the deliberate change from `=1{1 народ}` to `one{{count} народ}`: keeping a literal `1` inside a category that also matches 21/31/101 is exactly the bug. `=0` is safe to keep — Russian has no CLDR `zero` category, so that branch fires only at an exact 0.
- **Same-class sweep:** `es`, `pt`, `fr`, `en` were simulated over the same counts and are correct for all integer inputs (their `ONE` categories are `n == 1` / `i ∈ {0,1}`, and the `=0` shortcut pre-empts the `i == 0` case). No further instances.

### F-MECH-03 · Blocker · check 3b — French `nRemindersSet` has a stray `s` after the placeholder

- **Key:** `nRemindersSet` (`fr`), `lib/l10n/app_fr.arb:589`
- **Status:** pre-seed **CONFIRMED — a real defect, not a typo in the plan.**
- **Current:** `{count, plural, =0{Aucun rappel défini} =1{1 rappel défini} other{{count}s rappels définis}}`
- **Failure scenario:** the `s` sits outside the `{count}` token, so it is literal text. Simulated: count 2 → `2s rappels définis`; count 5 → `5s rappels définis`; count 20 → `20s rappels définis`. Every count ≥ 2 renders a stray `s` glued to the digits, reading as a seconds unit. Shown on the home-screen next-reminder card (`lib/components/cards/reminders_summary.dart:23`) — high visibility.
- **Proposed (exact, apply verbatim):**

```json
    "nRemindersSet": "{count, plural, =0{Aucun rappel défini} =1{1 rappel défini} other{{count} rappels définis}}",
```

- **Same-class sweep:** all 18 placeholder-bearing keys scanned in all six files for a stray alphanumeric abutting a `}`. Only instance.

### F-MECH-04 · Major · check 3b — Arabic plurals lack `two` and `few`, so counts 2 and 3–10 disagree

- **Keys:** `nPeopleGroups`, `nRemindersSet` (`ar` only)
- **Current:**
  - `nPeopleGroups` = `{count, plural, =0{لا توجد مجموعات شعبية} =1{مجموعة شعبية واحدة} other{{count} مجموعة شعبية}}`
  - `nRemindersSet` = `{count, plural, =0{لم يتم تعيين أي تذكير} =1{تم تعيين تذكير واحد} other{تم تعيين {count} تذكير}}`
- **Failure scenario (computed):** `pluralLogic` maps Arabic's `TWO` → `two ?? few ?? other` and `FEW` → `few ?? other`. With both absent, counts **2** and **3–10** (and 102–110, 203–210 …) fall through to `other`, which carries the accusative-singular noun. Rendered: `2 مجموعة شعبية`, `3 مجموعة شعبية`, `10 مجموعة شعبية`. Arabic needs the dual at 2 and the broken plural at 3–10. Counts 11–99 and 100/101 are correct, so the string is right most of the time and wrong in the low range users most often see.
- **Proposed:** add `two` and `few`. Structural change is mechanical; **A1 must supply the two Arabic noun forms** — B1 is not making that call.

```json
    "nPeopleGroups": "{count, plural, =0{لا توجد مجموعات شعبية} one{مجموعة شعبية واحدة} two{<A1: dual>} few{{count} <A1: 3–10 plural>} many{{count} مجموعة شعبية} other{{count} مجموعة شعبية}}",
```

- **Note on `=1` in Arabic:** unlike Russian, Arabic's CLDR `ONE` is exactly `n == 1`, so the existing `=1` branch is safe and may stay (renaming to `one` is equivalent here).

### F-MECH-05 · Major · check 4 — 19 `@key` blocks missing from every locale file

- **Status:** §6.2 **CONFIRMED, exactly 19 per locale — identical set in all five files** (symmetric difference empty between every pair). No *older* key is missing its block; `app_en.arb` is complete at 170/170.
- **Effect:** no runtime impact. The cost is that Weblate shows the new strings with no context, and five language reviewers judged 19 strings without the `description` that §5.1/C2 treats as binding.
- **Total blocks Phase 3 must add per locale: 21** — the 19 below plus the 2 from F-MECH-01.

**Missing `@key` blocks — identical for `ar`, `es`, `fr`, `pt`, `ru` (19 each, 95 total)**

| # | Key | English `description` to copy |
|---|---|---|
| 1 | `engaged` | Marker label shown when a people group is engaged |
| 2 | `feedbackConsentLabel` | *(copy from `app_en.arb`)* |
| 3 | `feedbackError` | *(copy from `app_en.arb`)* |
| 4 | `feedbackIntro` | *(copy from `app_en.arb`)* |
| 5 | `feedbackMessageLabel` | *(copy from `app_en.arb`)* |
| 6 | `feedbackMessageRequired` | *(copy from `app_en.arb`)* |
| 7 | `feedbackNameLabel` | *(copy from `app_en.arb`)* |
| 8 | `feedbackRateLimited` | *(copy from `app_en.arb`)* |
| 9 | `feedbackSubmit` | *(copy from `app_en.arb`)* |
| 10 | `feedbackSuccessBody` | *(copy; also carries `placeholders.email`)* |
| 11 | `feedbackSuccessTitle` | *(copy from `app_en.arb`)* |
| 12 | `feedbackTypeCompliment` | *(copy from `app_en.arb`)* |
| 13 | `feedbackTypeLabel` | *(copy from `app_en.arb`)* |
| 14 | `feedbackTypeProblem` | *(copy from `app_en.arb`)* |
| 15 | `feedbackTypeRequired` | *(copy from `app_en.arb`)* |
| 16 | `feedbackTypeSuggestion` | *(copy from `app_en.arb`)* |
| 17 | `prayerReminderTitle` | *(copy from `app_en.arb`)* |
| 18 | `prayerReminderBody` | *(copy; also carries `placeholders.peopleGroup`)* |
| 19 | `dismissReminderLabel` | *(copy from `app_en.arb`)* |

Plus from F-MECH-01: 20 `enableNotificationsButton`, 21 `enableNotificationsPromptBody`.

The `description` column is deliberately a pointer rather than a transcription for 20 of the 21: **Phase 3 must read the live `app_en.arb`** so a description edit landing between phases cannot be overwritten with a stale quote. Where a key carries `placeholders`, copy that sub-object too (`feedbackSuccessBody` → `email`, `prayerReminderBody` → `peopleGroup`) — the other locale files' `@` blocks all duplicate `placeholders`.

### F-MECH-06 · Major · check 8 — `Doxa` transliterated to «دوكسا» in three Arabic strings

- **Keys:** `appName`, `reminderNotificationBody`, `wizardWelcomeBody` (`ar`)
- **Current:**
  - `appName` = `صلاة دوكسا` *(transliterated **and** translated — "Doxa Prayer" → "prayer of Doxa")*
  - `reminderNotificationBody` = `افتح كتاب «دوكسا» لبدء صلاة اليوم.`
  - `wizardWelcomeBody` = `تساعدك «دوكسا» على الصلاة من أجل إحدى المجموعات الشعبية غير المُبشَّر بها. …`
- **Failure scenario:** the same Arabic user sees the brand two ways in one session — Latin `Doxa` in 10 strings (`exactAlarmsPromptBody`, `feedbackConsentLabel`, `notificationsHowToEnable`, `shareMessage`, `updateAvailableBody`, `updateRequiredBody`, `updatesFromDoxa`, `wizardNewsSignupBody`, `wizardWelcomeTitle`, `exactAlarmsDisabledStatus`) and Arabic `دوكسا` in these three. `appName` is worst: it is the app's own name, and `shareMessage` in the *same file* already writes `«Doxa Prayer»`.
- **Proposed:**

```json
    "appName": "Doxa Prayer",
    "wizardWelcomeBody": "يساعدك «Doxa» على الصلاة من أجل إحدى المجموعات الشعبية غير المُبشَّر بها. سنساعدك في اختيار مجموعة معينة، وضبط تذكير، ومتابعة آخر المستجدات.",
```

  `reminderNotificationBody` needs A1 rather than a mechanical swap — its problem is larger than the script (it also says "open the **book** Doxa").
- **Same-class sweep:** all 13 English strings containing `Doxa`/`DOXA` located and checked in all five locales. `es`, `fr`, `pt`, `ru` are Latin-script and untranslated in **13/13** each, including `ru` `«Doxa Prayer»` and `appName` = `Doxa Prayer`. No `DOXA` all-caps form appears in any `.arb`; the all-caps rendering on buttons comes from `ActionButton`'s `label.toUpperCase()` at runtime.

### F-MECH-07 · Major · check 6c — hardcoded English `'Retry'` in the people-group details error view

- **File:** `lib/screens/people_group_details_screen.dart:526`
- **Current:** `FilledButton(onPressed: onRetry, child: const Text('Retry')),`
- **Failure scenario:** whenever `fetchPeopleGroupDetail` fails (offline, 5xx, or a deep link with no slug), `_ErrorView` renders a localised message — `l.couldNotLoadPeopleGroupDetailsMessage`, correctly wired at line 89 — directly above a button that says `Retry` in English to all five non-English audiences. The key **already exists**: `app_en.arb` has `retry` with its `@retry` block, translated in all five locale files.
- **Proposed (one-line Dart fix, no `.arb` change):**

```dart
FilledButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry)),
```

  `AppLocalizations` is already imported in this file (used at line 106).
- **What was sampled** (spot-check per §5.2/6, not exhaustive): 14 newest-feature files — `feedback_form.dart`, `feedback_success.dart`, `account_settings_section.dart`, `signed_up_email_tile.dart`, `prayer_reminder_banner.dart`, `enable_notifications_prompt.dart`, `exact_alarm_permission_prompt.dart`, `exact_alarm_warning_banner.dart`, `news_signup_success.dart`, `engagement_item.dart`, `people_group_details_screen.dart`, `arrow_button.dart`, `credit_popover_button.dart`, `search_field.dart` — plus a repo-wide grep for `Text('[A-Z][a-z]` and for literals in `label:` / `labelText:` / `hintText:` / `semanticsLabel:` / `tooltip:` / `title:` / `message:` positions. The feedback form, profile/account section, prayer reminder banner and exact-alarms prompt are **clean** — every visible string goes through `l10n`. The only other literals in the sampled set are non-user-facing: `reportError(…, reason: 'feedback submit failed')` (`feedback_form.dart:104`, Crashlytics) and `Future.error('Missing people group slug')` (`people_group_details_screen.dart:57`, internal sentinel — `_ErrorView` ignores `snapshot.error` and shows the localised message).
- **Out of scope, recorded:** `lib/screens/debug_screen.dart` and `lib/screens/gallery_screen.dart` contain many English literals and are routed unconditionally in `lib/router.dart:205,211`. Treated as developer tools reachable only by typing the route.

### F-MECH-08 · Minor · check 2b — `appVersion` renders with no space before the version number

- **Keys:** `appVersion` (`ar`, `ru`) — `ar` `"الإصدار{version}"`, `ru` `"Версия{version}"`
- **Failure scenario:** substituted with no separator, so settings reads `Версия1.15.0` and `الإصدار1.15.0`. English is `Version {version}`; `es`, `fr`, `pt` keep the space.
- **Proposed (exact):** `"appVersion": "الإصدار {version}"` and `"appVersion": "Версия {version}"`
- **Same-class sweep:** every `{placeholder}` occurrence in all six files checked for a letter abutting the brace. Only two instances. (`{seconds}s` in English is a deliberate abbreviation; all five locales correctly insert a space before their own unit — not this defect.)

### F-MECH-09 · Minor · check 2b — French: the five new keys use an ASCII space before `! ? ; :`, the approved keys use U+202F

- **Keys:** `exactAlarmsDisabledStatus`, `feedbackSuccessTitle`, `feedbackTypeLabel`, `newsSignupSuccessTitle`, `prayerReminderTitle` (all new) — plus `shareMessage` (approved, different variance)
- **Established convention:** U+202F NARROW NO-BREAK SPACE. Computed tally across `app_fr.arb`: `?`+U+202F ×3, `;`+U+202F ×2 (`selectPeopleGroupConfirm`, `switchPeopleGroupConfirm`, `wizardConfirmPeopleGroupTitle`, `notificationsDisabledStatus`, `prayerThankYouVerse`) versus `?`+ASCII ×2, `!`+ASCII ×2, `;`+ASCII ×1 — **and all five ASCII cases are new keys.** A regression against the file's own settled typography, not a pre-existing inconsistency.
- **Failure scenario:** an ASCII space before `?` can break across a line, orphaning the punctuation — the exact reason the approved strings use U+202F.
- **Proposed:** the space before `! ? ;` in these five keys becomes **U+202F**; `shareMessage`'s space before its final `:` becomes **U+202F** (currently U+00A0). Wording unchanged in all of them. Keys and their punctuation:

| Key | Wording | Space to fix |
|---|---|---|
| `exactAlarmsDisabledStatus` | `… pour Doxa ; vos rappels …` | before `;` |
| `feedbackSuccessTitle` | `Merci !` | before `!` |
| `feedbackTypeLabel` | `Quel type de commentaire ?` | before `?` |
| `newsSignupSuccessTitle` | `Merci de votre inscription !` | before `!` |
| `prayerReminderTitle` | *(A3 is rewording this — apply the spacing to whatever A3 settles on)* | before `?` |
| `shareMessage` | `… Doxa Prayer :` | before `:` — U+00A0 → U+202F |

- **Other languages:** `es` `¿`/`¡` pairing, `ru` `ё`, Arabic diacritics are language-reviewer territory (§5.1/C5). No invisible-character anomalies in `ar`, `es`, `pt`, `ru` — the scan covered NBSP, NNBSP, ZWSP, LRM/RLM/ALM, isolate/embedding controls, soft hyphen, line/paragraph separators and tabs across every string value in all six files; `fr` was the only file with any hit.

> **Note for C1:** A3's own finding F-FR-11 says `shareMessage`'s U+00A0 before `:` is *correct* French (a colon takes the full no-break space, not the narrow one) and should be preserved. B1 recommends normalising it to U+202F for file consistency. **These two recommendations conflict; C1 must rule.** A3's is the language-specific argument and per §8.3 should probably win.

### F-MECH-10 · Minor · check 2b — French mixes ASCII `'` and typographic `’`

- **Keys:** `peopleGroupIntroTitle` (`Priez pour l’{name}`), `shareMessage` (`… l’{name} … l’application …`)
- **Current state:** 27 ASCII `'` vs 3 typographic `’`; all three `’` are in these two keys. Every other French elision (`d'aujourd'hui`, `l'application`, `n'apparaîtront`, `l'heure`, `C'est`) uses ASCII `'`.
- **Proposed (dominant convention):**

```json
    "peopleGroupIntroTitle": "Priez pour l'{name}",
    "shareMessage": "Priez avec moi pour l'{name} — téléchargez l'application Doxa Prayer :",
```

  If A3 prefers the opposite direction — `’` is the typographically correct French apostrophe — the change is 27 replacements rather than 3, a deliberate house-style decision for A3/C1. Either direction is acceptable; **mixing is not.** Recorded here so C1 rules once instead of five times.
  *(Note: A3's F-FR-11 independently proposes replacing both placeholders with guillemets, which removes the elided article entirely and makes this finding moot for those two keys.)*
- **Same-class sweep:** `es`, `pt`, `ru`, `ar` contain zero apostrophes of either kind; `en` uses ASCII `'` exclusively (14 occurrences). French is the only mixed file.

### F-MECH-11 · Major · check 3b — Arabic `resendVerification{Cooldown,Countdown}` are flat but need plural agreement

- **Keys (`ar`):** `يُرجى الانتظار {seconds} ثانية قبل طلب رسالة أخرى.` and `إعادة الإرسال خلال {seconds} ثانية`
- **Failure scenario:** `{seconds}` is `int` and — per `lib/components/settings/signed_up_email_tile.dart:28,41-53,73` — ranges over the whole countdown, `_defaultCooldownSeconds = 60` down to 1, ticking once a second. So the string renders at **every** value 1–60, including 2 (Arabic dual) and 3–10 (broken plural). With a bare `ثانية` the button reads `5 ثانية` and `2 ثانية`, ungrammatical for those counts. English sidesteps this by abbreviating (`{seconds}s`), and `es`/`fr`/`pt`/`ru` followed with `s` / `с`, which take no agreement — Arabic is the only locale that spelled the unit out.
- **Proposed — two mechanically valid routes; A1 picks:**
  1. **Abbreviate**, matching English and the other four, e.g. `إعادة الإرسال خلال {seconds} ث` — no plural machinery. Also helps: `resendVerificationCountdown` is a *button label* where Arabic is already longest at 1.70× (F-MECH-12).
  2. **Make it a plural:**

```json
    "resendVerificationCountdown": "{seconds, plural, one{إعادة الإرسال خلال ثانية واحدة} two{<A1: dual>} few{إعادة الإرسال خلال {seconds} <A1: 3–10 plural>} many{إعادة الإرسال خلال {seconds} ثانية} other{إعادة الإرسال خلال {seconds} ثانية}}",
```

     Route 2 keeps `"seconds": {"type": "int"}` valid, and `gen-l10n` permits English being the only flat locale.
- **Same-class sweep for "should have been a plural, written flat":** all 46 new keys checked for a numeric placeholder plus a countable noun. These two are the only candidates, and only in `ar`. No other new key interpolates a count; no new key is a plural that should have been flat.

> **Cross-reference:** A1 independently reached the same conclusion and proposed ICU Arabic plurals for these two keys, with a stated flat fallback. The two agents agree.

### F-MECH-12 · Note · check 7 — constrained-slot length ratios; ten over 1.6×, none can hard-overflow

- **Method:** character count of each translation ÷ English, for every new key in a `btn` / `lbl` / chip / progress-caption slot per §4.1–§4.2, then each slot's actual widget inspected.
- **The ten over ~1.6×, ranked:**

  | ratio | loc | key | slot | English | translation |
  |---|---|---|---|---|---|
  | **2.57×** | ru | `signUp` | btn | `Sign up` (7) | `Зарегистрироваться` (18) |
  | **2.00×** | fr | `notNow` | btn | `Not now` (7) | `Pas maintenant` (14) |
  | **1.85×** | fr | `feedbackSubmit` | btn | `Send feedback` (13) | `Envoyer les commentaires` (24) |
  | **1.80×** | fr | `allow` | btn | `Allow` (5) | `Autoriser` (9) |
  | **1.80×** | ru | `allow` | btn | `Allow` (5) | `Разрешить` (9) |
  | **1.71×** | pt | `signUp` | btn | `Sign up` (7) | `Inscrever-se` (12) |
  | **1.71×** | es | `engaged` | lbl/chip | `Engaged` (7) | `Comprometido` (12) |
  | **1.70×** | ar | `resendVerificationCountdown` | btn | `Resend in {seconds}s` (20) | `إعادة الإرسال خلال {seconds} ثانية` (34) |
  | **1.68×** | ru | `resendVerification` | btn | `Resend verification email` (25) | `Отправить письмо для подтверждения ещё раз` (42) |
  | **1.61×** | fr | `allowExactAlarms` | btn | `Allow exact alarms` (18) | `Autoriser les alarmes exactes` (29) |

  Every other constrained-slot key is ≤ 1.57×. Notable near-misses: `es` `signUp` 1.57×, `fr` `dailyPrayerCoverage` 1.52×, `ru` `dailyPrayerCoverage` 1.48×.
- **Why this is a Note, not a Major, despite `344ff12` / `1d10434`:**
  - `lib/` contains **zero** occurrences of `maxLines: 1`, `softWrap: false`, `TextOverflow.ellipsis` or `TextOverflow.clip` (repo-wide grep). No string can be truncated or clipped — worst case is an extra line.
  - `allow` + `notNow` sit in `ActionModal` → `ButtonBarWrap` (`lib/components/buttons/button_bar_wrap.dart`), which measures both labels with a `TextPainter` at the live `textScaler` and **stacks them full width** when the pair would not fit. That is precisely the `344ff12` fix, and it holds at these lengths.
  - `allowExactAlarms` and `enableNotificationsButton` use `ActionButton.fullWidth` — whole banner width, wrapping centred `Text`.
  - `feedbackType{Compliment,Suggestion,Problem}` are `ChoiceChip`s inside a `Wrap` (`feedback_form.dart:219`), which reflows; all three ≤ 1.14× anyway.
  - `engaged` renders in `EngagementItem`, a `SizedBox(width: 200)` with a centred wrapping `Text` (`engagement_item.dart:56-74`); `Comprometido` at 12 chars fits on one line.
  - `dailyPrayerCoverage` is a centred caption under a `LinearProgressIndicator` with no line limit — wraps.
  - `resendVerification` / `resendVerificationCountdown` are a `TextButton` inside `Align(centerEnd)` (`signed_up_email_tile.dart:120-137`) with loose width constraints; the Russian 42-char label wraps inside the button rather than overflowing.
  - `signUp` — highest ratio — is used in `wizard_step_news_signup.dart` and `wizard_controller.dart`, both routing through the wizard's `ButtonBarWrap`.
- **One real risk for C1:** `ActionButton` renders `label.toUpperCase()` (`action_button.dart:101`), and `ButtonBarWrap._labelWidth` measures the uppercased form with a generous `_buttonChrome = 56.0`. Uppercase Cyrillic and accented Latin are ~10–15% wider than mixed case, so `РАЗРЕШИТЬ` / `AUTORISER` will force the exact-alarms modal to the stacked layout on narrow devices at large text scale. Degradation, not breakage; the code is honest about it (*"Once stacked a label may still wrap — at full width there is nothing further to give it."*). **No action proposed;** shortening `ru` `signUp` is A5's call.

### F-MECH-13 · Note · check 4b — `@feedback` description has drifted in all five locale files

- **English (current):** `"Button that opens the in-app feedback panel"`
- **All five locales still carry:** `"Button that opens the feedback page in the browser"`
- **Why it matters:** no runtime effect, but the behaviour genuinely changed in `f48ad3a` (*feat: add feedback form in the app*), and Weblate surfaces the *locale* file's description to the translator — so a translator working on `feedback` is told the button opens a browser page it no longer opens.
- **Proposed:** replace in all five locale files with `"description": "Button that opens the in-app feedback panel"`.
- **Same-class sweep:** all 168 shared `@key` blocks compared field-by-field between `app_en.arb` and each locale. `@feedback` is the **only** substantive drift in any file. Two other diffs surfaced and are **not** findings — key ordering inside the `placeholders` object only, identical content: `@nextReminderOn` (`weekday`/`time` vs `time`/`weekday`) and `@nRemindersSet` (`type`/`format` vs `format`/`type`). Per §6.3 ordering is out of scope; recorded so C1 does not mistake them for drift.

### F-MECH-14 · Note · check 5 — no dead keys anywhere; both removed keys were cleaned up properly

- **Status:** the §6-implied worry is **REFUTED.** `newsSignupThanks` and `prayerCoverage24h` were removed from `app_en.arb` *and* from all five locale files, strings and `@` blocks alike. Neither identifier appears anywhere in any `.arb`.
- **Computed:** locale-minus-English set difference is **empty for all five files**, for both string keys and `@` blocks. Every locale key set is a strict subset of English's, short by exactly the two keys in F-MECH-01.
- **Consequence for §9.2:** once F-MECH-01 lands, key-set parity is achieved with no deletions. D1–D5 should add and never remove.

### F-MECH-15 · Note · check 6 — two older keys are unreferenced dead weight

- **Keys:** `dismissNextReminder` (`"Dismiss next"`), `saveAndContinue` (`"Save & continue"`)
- **Computed:** all 170 English keys grepped as whole-word identifiers across every `.dart` file in the repo excluding generated `app_localizations*` — these two are the only ones with zero hits. Both present, translated and `@`-documented in all six files (`app_en.arb:410,465`; `app_*.arb:553,661`).
- **Not in scope to fix:** both predate the baseline, and `app_en.arb` must not change during Phase 3. Recorded for C1's "raised for a human" section — deleting six keys across six files is a separate cleanup, and Weblate would need telling.
- **The positive result for the 46 in-scope keys: all 46 are referenced from `lib/`. Zero dead weight.** Access pattern in this codebase is `AppLocalizations.of(context)!` bound to a local named `l10n` or `l`, then `.key` / `.key(arg)` — grepped by bare identifier rather than by `l10n.` prefix so `l.` and `)!.` call sites were not missed.

  | key | referenced from |
  |---|---|
  | `accountSectionTitle`, `emailsLoadError`, `viewProfile` | `components/settings/account_settings_section.dart` |
  | `emailVerified`, `emailUnverified`, `resendVerification*` (5) | `components/settings/signed_up_email_tile.dart` |
  | all 13 `feedback*` form keys | `components/widgets/feedback_form.dart` |
  | `feedbackSuccessTitle`, `feedbackSuccessBody` | `components/widgets/feedback_success.dart` |
  | `prayerReminderTitle`, `prayerReminderBody`, `prayForPeopleGroupLabel`, `dismissReminderLabel` | `components/misc/prayer_reminder_banner.dart` |
  | `allow`, `notNow`, `exactAlarmsPromptBody` | `components/reminders/exact_alarm_permission_prompt.dart` |
  | `allowExactAlarms`, `exactAlarmsDisabledStatus` | `components/reminders/exact_alarm_warning_banner.dart` |
  | `enableNotificationsButton`, `enableNotificationsPromptBody` | `components/notifications/enable_notifications_prompt.dart` |
  | `dailyPrayerCoverage`, `engaged`, `partial` | `screens/people_group_details_screen.dart`, `components/cards/engagement_item.dart` |
  | `newsSignupSuccessTitle`, `newsSignupSuccessBody` | `components/widgets/news_signup_success.dart` |
  | `signUp` | `components/wizard/wizard_step_news_signup.dart`, `services/wizard_controller.dart` |
  | `clearSearchLabel` | `components/inputs/search_field.dart` |
  | `forwardLabel` | `components/buttons/arrow_button.dart` |
  | `pictureCreditLabel` | `components/misc/credit_popover_button.dart` |
  | `prayerRecordedAnnouncement` | `components/prayer_content/prayer_session_view.dart` |

- **Reverse direction, check 6b:** every `l10n.<key>` and `AppLocalizations.of(context)!.<key>` reference in `lib/` resolves to a key present in `app_en.arb`. **Zero build breaks.**

### F-MECH-16 · Note · no `@@locale` declaration in any file

- None of the six `.arb` files carries `@@locale`. `l10n.yaml` sets only `arb-dir`, `template-arb-file` and `output-localization-file`, so `gen-l10n` derives the locale from the filename suffix — which is why the build works.
- Weblate identifies an ARB component's language from `@@locale` when present and falls back to the filename otherwise. Adding it would be a six-file change outside audit scope and would touch `app_en.arb`, so **no action proposed.** Flagged so nobody "fixes" it mid-audit and perturbs five files D1–D5 are concurrently writing.

### F-MECH-17 · Note · `app_en.arb` has no trailing newline

- All five locale files end with `\n`; `app_en.arb` does not. No BOM, no CRLF, no tabs, no trailing whitespace on any line in any of the six files. Zero empty string values. **No action** — `app_en.arb` is not to be edited during this audit.

## Confirm / refute against plan §6

| §6 item | Verdict | Detail |
|---|---|---|
| §6.1 two keys untranslated in all five | **CONFIRMED** | F-MECH-01. Exhaustive — no third key. 46 English keys vs 44 per locale, as stated. |
| §6.2 19 missing `@key` blocks | **CONFIRMED, exactly 19** | F-MECH-05. Identical set in all five files; the plan's list is precisely right. 21 blocks per locale including §6.1. No older key affected. |
| §6.3 ordering | **not assessed** | Out of scope by instruction. |
| §6.4 `dailyPrayerCoverage` replaced `prayerCoverage24h` | **CONFIRMED mechanically** | Old key gone from all six files; new key present in all six and reachable. Terminology is B2/A1–A5's. |
| §6.5 `engaged` renderings | **noted only** | Strings confirmed as quoted. `es` `Comprometido` is also the only chip over 1.6× (F-MECH-12). Terminology is A2's. |
| §6.6 guillemet convention | **CONFIRMED as described, with one correction** | Per-locale state matches the plan's table, including `fr`'s two bare new keys and `pt`'s complete absence. Functionally harmless — placeholder integrity is clean in all six files (check 2, zero mismatches). One addition: `fr` `shareMessage` uses U+00A0 where the rest of the file uses U+202F — F-MECH-09. **A5 separately reports that the plan's table is wrong for `ru`: `scanToPray` is a bare name-like placeholder.** |
| §6.7 `partial` adverb vs adjective | **context supplied** | Spoken as an isolated `Semantics(label:)` on a text-less `CustomPaint` icon inside `EngagementItem` (`engagement_item.dart:53,66-69`), deliberately kept *separate* from the marker label — the code comment explains a bare `No` was read by TTS as `№`. So `partial` is uttered alone, not appended to a phrase. A5's call, but the context is "standalone utterance", not "modifier". |
| §6.8 `forwardLabel` reads as "next" | **not assessed** | Translation-quality; A1/A4's. Reachability confirmed: `components/buttons/arrow_button.dart`, instantiated only in `gallery_screen.dart`. |
| `newsSignupThanks` / `prayerCoverage24h` linger anywhere | **REFUTED** | F-MECH-14. Zero occurrences in any of the six files. |
| `fr nRemindersSet` stray `s` | **CONFIRMED as a defect** | F-MECH-03. Renders `2s rappels définis` at every count ≥ 2. |
| ru/ar plurals adequate for their agreement rules | **REFUTED — both are wrong** | F-MECH-02 (Blocker: ru prints literal `1` at 21/31/101, and `2 народов` where `2 народа` is needed), F-MECH-04 (ar wrong at 2 and 3–10). |

## Per-locale tables for Phase 3

### Missing keys to add (F-MECH-01)

| Locale | Count | Keys | Also needs `@key` block |
|---|---|---|---|
| `ar` | 2 | `enableNotificationsButton`, `enableNotificationsPromptBody` | yes, both |
| `es` | 2 | `enableNotificationsButton`, `enableNotificationsPromptBody` | yes, both |
| `fr` | 2 | `enableNotificationsButton`, `enableNotificationsPromptBody` | yes, both |
| `pt` | 2 | `enableNotificationsButton`, `enableNotificationsPromptBody` | yes, both |
| `ru` | 2 | `enableNotificationsButton`, `enableNotificationsPromptBody` | yes, both |

Alphabetical insertion point in each locale file: between `emailsLoadError` and `engaged`, which is where the sorted run already sits.

### Missing `@key` blocks to add (F-MECH-05 + F-MECH-01)

| Locale | Existing keys missing a block | New keys needing a block | **Total blocks to add** |
|---|---|---|---|
| `ar` | 19 | 2 | **21** |
| `es` | 19 | 2 | **21** |
| `fr` | 19 | 2 | **21** |
| `pt` | 19 | 2 | **21** |
| `ru` | 19 | 2 | **21** |
| | | | **105 across the five files** |

The 19 are identical in every file — see F-MECH-05.

### Mechanical string fixes, ready to apply verbatim

| Locale | Key | Finding | Severity | Exact replacement |
|---|---|---|---|---|
| `fr` | `nRemindersSet` | F-MECH-03 | Blocker | `{count, plural, =0{Aucun rappel défini} =1{1 rappel défini} other{{count} rappels définis}}` |
| `ru` | `nPeopleGroups` | F-MECH-02 | Blocker | `{count, plural, =0{Нет народов} one{{count} народ} few{{count} народа} many{{count} народов} other{{count} народов}}` — A5 to confirm noun forms |
| `ru` | `nRemindersSet` | F-MECH-02 | Blocker | `{count, plural, =0{Напоминаний не установлено} one{Установлено {count} напоминание} few{Установлено {count} напоминания} many{Установлено {count} напоминаний} other{Установлено {count} напоминаний}}` — A5 to confirm |
| `ar` | `nPeopleGroups` | F-MECH-04 | Major | needs `two` + `few`; A1 supplies the dual and 3–10 forms |
| `ar` | `nRemindersSet` | F-MECH-04 | Major | needs `two` + `few`; A1 supplies |
| `ar` | `appName` | F-MECH-06 | Major | `Doxa Prayer` |
| `ar` | `wizardWelcomeBody` | F-MECH-06 | Major | `يساعدك «Doxa» على الصلاة من أجل إحدى المجموعات الشعبية غير المُبشَّر بها. سنساعدك في اختيار مجموعة معينة، وضبط تذكير، ومتابعة آخر المستجدات.` |
| `ar` | `reminderNotificationBody` | F-MECH-06 | Major | Latin `Doxa` required; wording needs A1 |
| `ar` | `resendVerificationCooldown` | F-MECH-11 | Major | A1 picks abbreviation or plural |
| `ar` | `resendVerificationCountdown` | F-MECH-11 | Major | A1 picks abbreviation or plural |
| `ar` | `appVersion` | F-MECH-08 | Minor | `الإصدار {version}` |
| `ru` | `appVersion` | F-MECH-08 | Minor | `Версия {version}` |
| `fr` | `exactAlarmsDisabledStatus` | F-MECH-09 | Minor | U+202F before `;` |
| `fr` | `feedbackSuccessTitle` | F-MECH-09 | Minor | `Merci` + U+202F + `!` |
| `fr` | `feedbackTypeLabel` | F-MECH-09 | Minor | `Quel type de commentaire` + U+202F + `?` |
| `fr` | `newsSignupSuccessTitle` | F-MECH-09 | Minor | `Merci de votre inscription` + U+202F + `!` |
| `fr` | `prayerReminderTitle` | F-MECH-09 | Minor | U+202F before `?` on whatever string A3 settles |
| `fr` | `shareMessage` | F-MECH-09 + F-MECH-10 | Minor | U+00A0 → U+202F before `:` **(A3 disputes — C1 must rule)**; `’` → `'` (×2) |
| `fr` | `peopleGroupIntroTitle` | F-MECH-10 | Minor | `Priez pour l'{name}` **(superseded if A3's F-FR-11 guillemets are applied)** |
| all 5 | `@feedback` | F-MECH-13 | Note | `"description": "Button that opens the in-app feedback panel"` |

`shareMessage` and `peopleGroupIntroTitle` are on §6.6's list of the seven keys implementation may touch, so the `fr` edits above are already sanctioned. **`appVersion`, `appName`, `wizardWelcomeBody`, `reminderNotificationBody`, `nPeopleGroups` and `nRemindersSet` are NOT on that list** — C1 must explicitly authorise them in the change sets, since they are approved keys outside §4's 46. B1 recommends that authorisation: three of them are Blockers or brand defects.

### Non-`.arb` fix (Dart, for the orchestrator not D1–D5)

| File | Line | Finding | Fix |
|---|---|---|---|
| `lib/screens/people_group_details_screen.dart` | 526 | F-MECH-07 | `child: Text(AppLocalizations.of(context)!.retry)` |

## Referred to language reviewers

Structure-only agent; terminology/meaning observations found incidentally, one line each, no verdict from B1.

- `ar` `reminderNotificationBody` = `افتح كتاب «دوكسا» لبدء صلاة اليوم.` inserts `كتاب` ("book") — English is `Open Doxa to start today's prayer.` → **A1**.
- `ar` `appName` = `صلاة دوكسا` both transliterates and *translates* the product name ("prayer of Doxa"), where every other locale keeps `Doxa Prayer` verbatim → **A1** (mechanical fix in F-MECH-06).
- `ar` `nextReminderToday` / `nextReminderTomorrow` render `at {time}` as `على موقع {time}` ("on the website"), and `nextReminderOn` as `على الرابط {time}` ("on the link") → **A1**. Pre-existing keys outside §4, but the placeholder is a *time* and the preposition describes a URL.
- `fr` `prayerReminderTitle` = `C'est le moment de prier aujourd'hui ?` for English `Ready for today's prayer?` → **A3** (§4.1 requires this to read as the daily commitment).
- `fr` `feedbackMessageLabel` / `feedbackTypeCompliment` / `feedbackTypeSuggestion` are byte-identical to English (`Message`, `Compliment`, `Suggestion`) — almost certainly legitimate cognates rather than untranslated leakage, but flagging since it is the only verbatim overlap among the 46 new keys in any locale → **A3**. (`appName` matching English is by design; `es` `no`/`status`, `pt` `status`, `fr` `amen`/`emailLabel`/`notifications`/`population` are equivalent pre-existing cognates.)
- `es` `engaged` = `Comprometido` is both the §6.5 terminology risk and the only chip over 1.6× → **A2**.
- `ru` `signUp` = `Зарегистрироваться` at 2.57× English is the longest button label in the app → **A5**, if a shorter register-appropriate form exists.

## What B1 could not determine

1. **Correct Arabic dual and 3–10 plural noun forms** for `nPeopleGroups`, `nRemindersSet` and (if route 2 is chosen) `resendVerification{Cooldown,Countdown}`. The *structural* defect is proven by simulation; Arabic morphology is A1's job, and F-MECH-04/F-MECH-11 give the skeleton with gaps marked.
2. **Whether the proposed Russian noun forms are the ones A5 wants.** `народ`/`народа`/`народов` and `напоминание`/`напоминания`/`напоминаний` are given as the standard paradigm, but the plan forbids B1 making translation calls. The `one`/`few`/`many` *category structure* is not negotiable — without it the count renders wrong.
3. **Whether the French apostrophe should normalise to ASCII `'` or typographic `’`.** Either is internally consistent; F-MECH-10 proposes the dominant ASCII direction and states the cost of the other. Needs one ruling from A3/C1.
4. **Real-world reachability of count 21+ for `nRemindersSet`.** `nPeopleGroups` is definitely affected (the unfiltered IMB list far exceeds 21). Whether a user ever creates 21 reminders is unknown — but the defect class is identical and the fix is the same edit.
5. **Rendered pixel width at large text scale on a real device.** F-MECH-12's ratios are character counts, and overflow was reasoned about by reading the widgets (no `maxLines: 1` anywhere, `ButtonBarWrap` measures and stacks). The app was not run, so "no hard overflow" is a code-reading conclusion, not an observed one. Phase 4 could confirm cheaply by launching with `--flavor production` at maximum font scale in `ru` and `fr`.
6. **Whether `debug_screen.dart` / `gallery_screen.dart` count as user-facing.** They hold many English literals and are routed unconditionally in `lib/router.dart`. Treated as developer tools and excluded from F-MECH-07; if they ship as reachable UI, there is more un-localised text than this report claims.

## Verification run on the proposed strings

Checked against the literal proposed strings (agent-run, after the document was produced):

| Check | Result |
|---|---|
| `ru` `nPeopleGroups` contains `one{`, `few{`, `many{` | ✅ all three · braces balanced ✅ |
| `ru` `nRemindersSet` contains `one{`, `few{`, `many{` | ✅ all three · braces balanced ✅ |
| `fr` `nRemindersSet` contains `{count} rappels définis` | ✅ · no stray `}s` ✅ · braces balanced ✅ |
| `ar` `appVersion` space before `{version}` | ✅ `الإصدار {version}` |
| `ru` `appVersion` space before `{version}` | ✅ `Версия {version}` |
