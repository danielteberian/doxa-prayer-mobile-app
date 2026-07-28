# Applied — `es` (D2 `apply-es`)

**File written:** `lib/l10n/app_es.arb` (only file modified by this agent)
**Source of truth:** `REPORT.md` §10.2 + §6 + F-MECH-05/F-MECH-01, with all `description`/`placeholders` copied from the live `app_en.arb`.
**Applied:** 11 / 11 rows · 21 `@key` blocks · `@feedback` description. **Skipped: none.**
**Diff:** 85 insertions, 10 deletions — 9 replaced string lines + 1 replaced `@feedback` description, everything else additive. No key removed, no key re-sorted.

> **Persistence note:** produced by the D2 subagent and persisted by the orchestrator (subagents are blocked from writing report `.md` files).

## 1. In-scope string changes (§10.2) — 7 changed + 2 new

| # | Key | Before | After |
|---|---|---|---|
| 1 | `emailsLoadError` | `No se pudieron cargar tus correos.` | `No se han podido cargar tus direcciones de correo.` |
| 2 | `enableNotificationsButton` **NEW** | *(absent — fell back to English)* | `Activar notificaciones` |
| 3 | `enableNotificationsPromptBody` **NEW** | *(absent — fell back to English)* | `Activa las notificaciones para recibir también las novedades como notificaciones push.` |
| 4 | `exactAlarmsDisabledStatus` | `Las alarmas exactas no están permitidas para Doxa, por lo que …` | `Doxa no tiene permiso para usar alarmas exactas, por lo que tus recordatorios de oración pueden llegar con varios minutos de retraso.` |
| 5 | `feedbackSuccessBody` | `Tus comentarios se enviaron como {email}. Si no es la dirección correcta, …` | `Tus comentarios se han enviado desde {email}. Si esa no es la dirección correcta, vuelve a enviarlos con la correcta.` |
| 6 | `prayForPeopleGroupLabel` | `Orar por {peopleGroup}` | `Orar por «{peopleGroup}»` |
| 7 | `prayerReminderBody` | `Toca para orar por {peopleGroup}.` | `Toca para orar por «{peopleGroup}».` |
| 8 | `prayerReminderTitle` | `¿Todo listo para orar hoy?` | `¿Todo listo para la oración de hoy?` |
| 9 | `resendVerificationFailed` | `No se pudo enviar el correo. Inténtalo de nuevo.` | `No se ha podido enviar el correo. Inténtalo de nuevo.` |

## 2. §6.6 placeholder typography on approved keys — 2 changed

| # | Key | Before | After |
|---|---|---|---|
| 10 | `scanToPray` | `… y ora por los {name}` | `Escanea el código para descargar la aplicación y ora por los «{name}»` |
| 11 | `switchPeopleGroupConfirm` | `¿Quieres dejar de orar por {currentName} y empezar a orar por {newName}?` | `¿Quieres dejar de orar por «{currentName}» y empezar a orar por «{newName}»?` |

Guillemets only — nothing else on these two keys was altered.

## 3. Metadata

**`@feedback`:** `"Button that opens the feedback page in the browser"` → `"Button that opens the in-app feedback panel"` (M-02).

**21 `@key` blocks added**, every `description` and `placeholders` read from the live `app_en.arb` (M-08 honoured — `@enableNotificationsButton` carries the live *"Button that requests OS notification permission so the user can receive push notifications"*, not B1's stale quote):

| Placement | Blocks added |
|---|---|
| after `@enableNotifications` | `@enableNotificationsButton`, `@enableNotificationsPromptBody` |
| after `@engagementStatus` | `@engaged` |
| after `@feedback` | `@feedbackConsentLabel`, `@feedbackError`, `@feedbackIntro`, `@feedbackMessageLabel`, `@feedbackMessageRequired`, `@feedbackNameLabel`, `@feedbackRateLimited`, `@feedbackSubmit`, `@feedbackSuccessBody` (+`placeholders.email`), `@feedbackSuccessTitle`, `@feedbackTypeCompliment`, `@feedbackTypeLabel`, `@feedbackTypeProblem`, `@feedbackTypeRequired`, `@feedbackTypeSuggestion` |
| after `@prayedToday` | `@prayerReminderTitle`, `@prayerReminderBody` (+`placeholders.peopleGroup`), `@dismissReminderLabel` |

All 21 verified byte-identical to `app_en.arb`'s blocks, plus `@feedback`. Each block was placed to mirror the position its string key already occupies, so the `@`-section and string section stay parallel.

## 4. Skipped / deviations

| Item | Reason |
|---|---|
| `engaged` = `Comprometido` | Left untouched. §6.5's suspicion **refuted** by C1 against `glossary.es_ES.md` §2 ("Compromiso / comprometido (grupo de personas)"), which warns only against «participación»/«contacto». No harmonisation toward another language. |
| `notificationsHowToEnable` (`Pulsa`) | §6 **REFUSED**. Untouched. |
| `dailyPrayerCoverage`, the `alarmas exactas` cluster term, the `comentarios` feedback scheme, `feedbackConsentLabel`, the deliberate `{seconds} s` unit space | All confirmed present and unchanged. |
| `peopleGroupIntroTitle`, `shareMessage`, `wizardConfirmPeopleGroupTitle` | Already correctly guillemeted; left alone per §10.2's note. |
| Insertion-point wording | §10.2/F-MECH-01 say "between `emailsLoadError` and `engaged`". In `app_es.arb`, `emailsLoadError` is **not** in the sorted run — it sits in the file's appended unsorted tail. The two new keys were inserted at their true **alphabetical** position in the sorted run, immediately after `enableNotifications` and before `engagementStatus`/`engaged`. Same slot the report intends; no re-sorting performed. |

**Nothing was skipped for unusability.** All eleven change-set strings applied verbatim.

## 5. Verification results (all actual)

1. **Valid JSON — PASS.** No duplicate top-level keys, no BOM, no CRLF, no tabs, no empty values.
2. **Placeholder parity — PASS, zero mismatches across all 170 keys.** Checked declared-aware (`@key.placeholders` ∪ ICU arg names) *and* as a raw brace-token set difference: both empty in both directions. Guillemets sit strictly **outside** the braces, so ICU substitution is unaffected.
3. **Key-set equality — PASS.** en 170 / es 170; missing none, extra none. (Was 168 before; +2 from B-01, zero deletions per M-05.)
4. **`@key` coverage — PASS.** 170 strings / 170 blocks; none missing, no orphans.
5. **Guillemets — PASS.** Exactly 7 keys carry `«…»`: the 4 fixed here plus the 3 pre-existing correct ones (`peopleGroupIntroTitle`, `shareMessage`, `wizardConfirmPeopleGroupTitle`) — matching P-01's count of 4 to fix. Codepoints confirmed **U+00AB / U+00BB** by dump, never ASCII `<<`/`>>`. **Zero inner spaces** (regex `«\s|\s»` → no hits) — Spanish convention, not French. **Zero guillemets on any numeric/technical placeholder.** Bonus: `¿`/`?` and `¡`/`!` counts balance in every one of the 170 strings.
6. **ICU — PASS.** The 2 ICU-bearing keys (`nPeopleGroups`, `nRemindersSet`, both untouched) parse under a strict MessageFormat parser and end at brace depth 0. All 170 strings parse without error.

> `flutter gen-l10n` was deliberately **not** run by this agent: it regenerates all six locales' Dart, and four sibling agents were mid-write. The strict ICU parse above substitutes; a single `gen-l10n` after all five agents finish is the correct Phase 4 gate.
