# Applied — `fr` (D3 `apply-fr`)

**File written:** `lib/l10n/app_fr.arb` (only file modified by this agent)
**Source of truth:** `REPORT.md` §10.3, plus §3 (P-03), §6, and the fragile-character legend.
**Applied:** 20 string changes (18 modified + 2 new) · 1 metadata description · 21 `@key` blocks · 0 deletions · 0 keys skipped.

> **Persistence note:** produced by the D3 subagent and persisted by the orchestrator (subagents are blocked from writing report `.md` files).
>
> **Method:** all edits made programmatically by a `python3` script (`json.dumps(..., ensure_ascii=False, indent=4)`), with U+202F / U+00A0 built from ` ` / ` ` escapes and guarded by `assert ord(...) == 8239 / 160`. **No fragile character was hand-typed or pasted.**
>
> **Notation in this document** (same convention as REPORT.md, for the same reason): `[NNBSP]` = U+202F, `[NBSP]` = U+00A0. The literal characters in the `.arb` were verified by `ord()` — see §5.

## A. In-scope keys (§4) — 14

| # | Key | Before | After |
|---|---|---|---|
| 1 | `enableNotificationsButton` **NEW** | *(absent — fell back to English)* | `Activer les notifications` |
| 2 | `enableNotificationsPromptBody` **NEW** | *(absent — fell back to English)* | `Activez les notifications pour recevoir aussi les actualités par notification push.` |
| 3 | `exactAlarmsDisabledStatus` | `…pour Doxa` + **U+0020** + `; vos rappels…` | `…pour Doxa[NNBSP]; vos rappels…` — wording unchanged, space only |
| 4 | `feedbackSubmit` | `Envoyer les commentaires` | `Envoyer des commentaires` |
| 5 | `feedbackSuccessBody` | `Vos commentaires ont été envoyés **à** l'adresse {email}. …` | `Vos commentaires ont été envoyés **depuis** l'adresse {email}. Si ce n'est pas la bonne adresse, renvoyez-les avec la bonne.` |
| 6 | `feedbackSuccessTitle` | `Merci` + U+0020 + `!` | `Merci[NNBSP]!` |
| 7 | `feedbackTypeLabel` | `Quel type de commentaire` + U+0020 + `?` | `Quel type de commentaire[NNBSP]?` |
| 8 | `newsSignupSuccessTitle` | `Merci de votre inscription` + U+0020 + `!` | `Merci de votre inscription[NNBSP]!` |
| 9 | `partial` | `Partiel` | `En partie` |
| 10 | `prayForPeopleGroupLabel` | `Prier pour {peopleGroup}` | `Prier pour «[NNBSP]{peopleGroup}[NNBSP]»` |
| 11 | `prayerReminderBody` | `Touchez pour prier pour {peopleGroup}.` | `Appuyez ici pour prier pour «[NNBSP]{peopleGroup}[NNBSP]».` |
| 12 | `prayerReminderTitle` | `C'est le moment de prier aujourd'hui` + U+0020 + `?` | `Prêt pour la prière d'aujourd'hui[NNBSP]?` (ASCII apostrophes) |
| 13 | `resendVerificationCooldown` | `…{seconds}` + **U+0020** + `s avant…` | `…{seconds}[NBSP]s avant…` — wording unchanged, space only |
| 14 | `resendVerificationCountdown` | `Renvoyer dans {seconds}` + U+0020 + `s` | `Renvoyer dans {seconds}[NBSP]s` |

## B. §6.6 placeholder typography (approved keys) — 5

| # | Key | Before | After |
|---|---|---|---|
| 15 | `peopleGroupIntroTitle` | `Priez pour l’{name}` (U+2019) | `Priez pour «[NNBSP]{name}[NNBSP]»` — elided `l'` deliberately dropped |
| 16 | `scanToPray` | `… et priez pour l'{name}` | `Scannez le code pour télécharger l'application et priez pour «[NNBSP]{name}[NNBSP]»` — elided `l'` dropped; `l'application` keeps ASCII `'` |
| 17 | `shareMessage` | `Priez avec moi pour l’{name} — téléchargez l’application Doxa Prayer[NBSP]:` (2× U+2019) | `Priez avec moi pour «[NNBSP]{name}[NNBSP]» — téléchargez l'application Doxa Prayer[NBSP]:` — em dash U+2014 preserved; `’`→ASCII `'`; **colon space left at U+00A0 per ruling A-03** |
| 18 | `switchPeopleGroupConfirm` | `… « {currentName} » et … « {newName} »[NNBSP]?` (4 inner spaces = U+0020) | four inner spaces → U+202F; wording unchanged; existing U+202F before `?` preserved |
| 19 | `wizardConfirmPeopleGroupTitle` | `Prier pour « {name} »[NNBSP]?` (2 inner U+0020) | two inner spaces → U+202F; wording unchanged |

**Why the article is dropped:** `l'{name}` is ungrammatical for any people-group name beginning with a consonant ("l'Peul", "l'Kurde"), and `l'« {name} »` is not legal French. The guillemets do the work the article was attempting.

## C. Authorised out-of-scope (§6 / B-03) — 1

| # | Key | Before | After |
|---|---|---|---|
| 20 | `nRemindersSet` | `… other{{count}s rappels définis}}` | `… other{{count} rappels définis}}` |

The stray literal `s` is gone; count 2 now renders `2 rappels définis`, not `2s rappels définis`.

## D. Metadata

**`@feedback`** — `"Button that opens the feedback page in the browser"` → `"Button that opens the in-app feedback panel"`.

**21 `@key` blocks added** (F-MECH-05's 19 + F-MECH-01's 2), each copied from the **live** `app_en.arb` and verified byte-identical (`json.dumps(..., sort_keys=True)` comparison, 21/21 identical):
`@engaged`, `@feedbackConsentLabel`, `@feedbackError`, `@feedbackIntro`, `@feedbackMessageLabel`, `@feedbackMessageRequired`, `@feedbackNameLabel`, `@feedbackRateLimited`, `@feedbackSubmit`, `@feedbackSuccessBody` (+`placeholders.email`), `@feedbackSuccessTitle`, `@feedbackTypeCompliment`, `@feedbackTypeLabel`, `@feedbackTypeProblem`, `@feedbackTypeRequired`, `@feedbackTypeSuggestion`, `@prayerReminderTitle`, `@prayerReminderBody` (+`placeholders.peopleGroup`), `@dismissReminderLabel`, `@enableNotificationsButton`, `@enableNotificationsPromptBody`.

**M-08 observed:** `@enableNotificationsButton` carries the live text, not B1's stale quote.

New keys were inserted at their alphabetical position — `… emailLabel, enableNotifications, **enableNotificationsButton**, **enableNotificationsPromptBody**, engagementStatus, engaged …` — and the `@` group identically. The file's convention (all `@` blocks first, in the same order as the plain keys) is preserved: `@`-group order still equals plain-key order filtered — verified `True`.

## E. Keys skipped — none from §10.3

Deliberate non-actions, for the record:

| Item | Reason |
|---|---|
| `emailLabel` (`Email`) | §6 **REFUSED** — verified still `Email`, untouched. |
| `engaged` = `Engagé` · `dailyPrayerCoverage` · `forwardLabel` = `Suivant` · `alarmes exactes` cluster | §10.3 "Explicitly NOT to be changed" — verified byte-identical to HEAD. |
| `shareMessage` colon → U+202F | B1's F-MECH-09 row **overruled** by A-03/R3. U+00A0 preserved, confirmed `ord()==160`. |
| `nPeopleGroups` | Not in the `fr` change set; verified untouched. |
| Re-sorting / `@@locale` / trailing-newline | Out of scope. Existing key order preserved exactly; the file's one inline `placeholders` formatting (`@prayForPeopleGroupLabel`) preserved verbatim so the diff shows only substantive lines. |

## Verification results (all actual)

**1. Valid JSON — PASS.** Duplicate top-level keys: **0**. No BOM, no CRLF, no tabs, trailing newline present. 317 → 340 top-level entries.

**2. Placeholder parity — PASS, 0 mismatches.** All 170 string keys have an identical `{placeholder}` name-set to English. Both ICU plural argument names checked: `nPeopleGroups` `count`↔`count`, `nRemindersSet` `count`↔`count`.

**3. Key-set equality — PASS.** en 170 / fr 170 · missing NONE · extra NONE. (Was 168; the two B-01 keys closed the gap. Zero deletions.)

**4. `@key` coverage — PASS.** Keys without a block: NONE. Total blocks: 170. Orphans: NONE.

**5. Codepoint audit — PASS, 0 failures.** Every `; ? ! :` and every guillemet in every changed string, by `ord()`:

| Key | Position | `ord()` | Expected |
|---|---|---|---|
| `exactAlarmsDisabledStatus` | before `;` | **8239** | 8239 ✓ |
| `feedbackSuccessTitle` | before `!` | **8239** | 8239 ✓ |
| `feedbackTypeLabel` | before `?` | **8239** | 8239 ✓ |
| `newsSignupSuccessTitle` | before `!` | **8239** | 8239 ✓ |
| `prayerReminderTitle` | before `?` | **8239** | 8239 ✓ |
| `prayForPeopleGroupLabel` | after `«` / before `»` | **8239 / 8239** | ✓ |
| `prayerReminderBody` | after `«` / before `»` | **8239 / 8239** | ✓ |
| `peopleGroupIntroTitle` | after `«` / before `»` | **8239 / 8239** | ✓ |
| `scanToPray` | after `«` / before `»` | **8239 / 8239** | ✓ |
| `shareMessage` | after `«` / before `»` | **8239 / 8239** | ✓ |
| `shareMessage` | **before `:`** | **160** | 160 ✓ (A-03: U+00A0 preserved, *not* normalised) |
| `switchPeopleGroupConfirm` | 4× guillemet-inner | **8239 ×4** | ✓ |
| `switchPeopleGroupConfirm` | before `?` | **8239** | ✓ |
| `wizardConfirmPeopleGroupTitle` | 2× guillemet-inner | **8239 ×2** | ✓ |
| `wizardConfirmPeopleGroupTitle` | before `?` | **8239** | ✓ |
| `resendVerificationCooldown` | between `{seconds}` and `s` | **160** | 160 ✓ |
| `resendVerificationCountdown` | between `{seconds}` and `s` | **160** | 160 ✓ |

**Not one `ord()==32` anywhere.** Two whole-file sweeps confirm it:
- **U+2019 count in `app_fr.arb` (strings *and* `@` blocks): 0** — ruling A-04 satisfied. Every apostrophe is ASCII U+0027.
- **ASCII U+0020 immediately before any `; ? ! :`, anywhere in the file: 0 occurrences.** The P-03 regression is fully closed; the file's typography is now uniform, not mixed.
- All 7 guillemet-bearing keys use U+202F on both inner sides; no other key contains a guillemet.

**6. `nRemindersSet` and brace balance — PASS.** Value is `{count, plural, =0{Aucun rappel défini} =1{1 rappel défini} other{{count} rappels définis}}`. `{count} rappels définis` present: **True**. `{count}s` present: **False**. All 170 strings brace-balanced, no negative depth at any position.

**Change containment (extra check).** Diffed the parsed dict against `HEAD`: 19 modified entries (18 strings + `@feedback`), 23 added (2 strings + 21 blocks), **0 removed**. Unexpected modifications: **NONE**. Unexpected additions: **NONE**.

> `flutter gen-l10n` was **not** run by this agent — four siblings were concurrently writing. Placeholder parity, ICU argument names and brace balance were verified statically instead.
