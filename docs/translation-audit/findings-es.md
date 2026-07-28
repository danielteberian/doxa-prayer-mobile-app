# Findings — review-es

**Agent:** review-es (A2, Phase 1)
**Scope:** 46 keys, Spanish (`lib/l10n/app_es.arb`)
**Glossary consulted:** `../translation/translated-glossaries/glossary.es_ES.md` (full read), `../translation/glossary.md`, `../translation/deepl-glossaries/es.tsv`
**Keys verdicted:** 46 / 46
**Counts:** 2 Blocker · 1 Major · 5 Minor · 4 Note · 34 OK

> **Persistence note (orchestrator):** this document was produced by the A2 subagent and persisted by the orchestrator, because subagents are blocked from writing findings files. Content is the agent's, unaltered in substance.

**House style established from the approved strings before judging** (C4): informal **tú** throughout (`Introduce`, `Comprueba tu conexión`, `Elige`, `Revisa tu bandeja`); **infinitive** button labels (`Guardar`, `Continuar`, `Omitir`, `Finalizar`, `Actualizar`, `Abrir ajustes`, `Activar notificaciones`), with imperatives reserved for prompts and section CTAs (`Involúcrate`, `Suscríbete…`, `Selecciona un grupo de personas`); European Spanish register (`ajustes`, `aplicación`, `Pulsa`/`Toca`, compound perfect for just-happened events: `No se han podido cargar…`, `Hemos enviado…`); `¿ ?` and `¡ !` correctly paired everywhere; guillemets `« »` on name-like placeholders (`peopleGroupIntroTitle`, `shareMessage`, `wizardConfirmPeopleGroupTitle`), bare on numeric/technical ones; `Doxa` never translated, never inflected, never taking an article.

## Findings

### F-ES-01 · Blocker · C2 missing string (§6.1)
- **Key:** `enableNotificationsButton`
- **English:** "Enable notifications"
- **Current:** *absent from `app_es.arb`* — falls back to English at runtime
- **Proposed:** `"Activar notificaciones"`
- **Glossary ref:** glossary silent (platform vocabulary); precedent = existing approved `enableNotifications` in the same file, same English string.
- **Why:** The key is missing entirely, so every Spanish user sees an English button (`lib/components/notifications/enable_notifications_prompt.dart:89`). `app_en.arb` carries both `enableNotifications` and `enableNotificationsButton` with identical English text; the Spanish must be identical too, or the same button reads differently in two places. Infinitive form matches the file's button style. Length 22 vs 20 chars — safe in a full-width `ActionButton`.

### F-ES-02 · Blocker · C2 missing string (§6.1)
- **Key:** `enableNotificationsPromptBody`
- **English:** "Enable notifications to also receive updates in push notifications."
- **Current:** *absent from `app_es.arb`* — falls back to English at runtime
- **Proposed:** `"Activa las notificaciones para recibir también las novedades como notificaciones push."`
- **Glossary ref:** glossary silent; precedents applied — `updatesFromDoxa` / `signUpForUpdates` / `wizardNewsSignupBody` render "updates" as **novedades**; `notificationsHowToEnable` establishes `las notificaciones`; loanword retention follows glossary §7 (`Pentecostal`) and §2 (`diáspora`) for **push**.
- **Why:** Missing string. It is body prose in an opt-in prompt shown right after news signup (`enable_notifications_prompt.dart:83`), so it must (a) address the user as **tú** with an imperative, matching the neighbouring prompt bodies, and (b) keep "also" — the point is that the updates the user just subscribed to by email will *additionally* arrive as push. The repetition "notificaciones … notificaciones push" mirrors the English exactly and is unavoidable without weakening the permission being requested.

### F-ES-03 · Major · C2/C3 meaning — "emails" means *addresses* here, not messages
- **Key:** `emailsLoadError`
- **English:** "Couldn't load your emails."
- **Current:** `"No se pudieron cargar tus correos."`
- **Proposed:** `"No se han podido cargar tus direcciones de correo."`
- **Glossary ref:** glossary silent on the noun; precision precedent = glossary §1 ("una traducción imprecisa invalida todas las estadísticas" — where the app has a precise referent, the Spanish must name it). Tense precedent = approved `couldNotLoadPeopleGroupsMessage` / `couldNotLoadPrayerContent`.
- **Why:** Two defects in one string. (1) `tus correos` in Spanish means *your email messages*; the list that failed to load is the user's registered email **addresses** (`account_settings_section.dart:78-99`, `List<SignedUpEmail>`). A Spanish user reads this as "we couldn't load your inbox", which the app never touches — wrong meaning, and alarming in a settings screen sitting under "Tu cuenta". English is loose here ("emails" for "email addresses"); Spanish can and should be precise. (2) Simple preterite `no se pudieron` clashes with the file's established compound perfect for load failures.

### F-ES-04 · Minor · C4 register/tense consistency
- **Key:** `resendVerificationFailed`
- **English:** "Couldn't send the email. Please try again."
- **Current:** `"No se pudo enviar el correo. Inténtalo de nuevo."`
- **Proposed:** `"No se ha podido enviar el correo. Inténtalo de nuevo."`
- **Glossary ref:** glossary silent; precedent = approved `couldNotLoadPrayerContent`, `couldNotLoadPeopleGroupsMessage`, `newsSignupError`.
- **Why:** Correct as written, but the file consistently uses the compound perfect for an action that has just failed; the bare preterite reads as a report about the past rather than about the tap the user just made. Same class of drift as F-ES-03.

### F-ES-05 · Minor · C5 naturalness + C4 tense
- **Key:** `feedbackSuccessBody`
- **English:** "Your feedback was sent as {email}. If that isn't the right address, send it again with the correct one."
- **Current:** `"Tus comentarios se enviaron como {email}. Si no es la dirección correcta, vuelve a enviarlos con la correcta."`
- **Proposed:** `"Tus comentarios se han enviado desde {email}. Si esa no es la dirección correcta, vuelve a enviarlos con la correcta."`
- **Glossary ref:** glossary silent; cluster rendering **comentarios** kept (see F-ES-12); tense precedent as F-ES-04.
- **Why:** `se enviaron como {email}` is the literal calque of "sent as" and in Spanish reads as though the feedback *took the form of* an address. The relation is authorship/sender, which Spanish marks with **desde**. Adding `esa` restores the English demonstrative and makes the second sentence point unambiguously at the address just shown. Placeholder `{email}` intact and unbracketed (numeric/technical class per §6.6).

### F-ES-06 · Minor · C5 naturalness / attribution
- **Key:** `exactAlarmsDisabledStatus`
- **English:** "Exact alarms aren't allowed for Doxa, so your prayer reminders may arrive several minutes late."
- **Current:** `"Las alarmas exactas no están permitidas para Doxa, por lo que tus recordatorios de oración pueden llegar con varios minutos de retraso."`
- **Proposed:** `"Doxa no tiene permiso para usar alarmas exactas, por lo que tus recordatorios de oración pueden llegar con varios minutos de retraso."`
- **Glossary ref:** `Doxa` untranslated per glossary §7 (confirmed present, unarticled). Cluster term `alarmas exactas` retained (see F-ES-11).
- **Why:** `no están permitidas para Doxa` is grammatical but impersonal-passive in a way that hides *who* withheld the permission — a Spanish reader can take it to mean the alarms are forbidden *by* Doxa. The proposal names Doxa as the subject lacking the permission, which is what the OS state actually is, and matches the active framing of the companion string `exactAlarmsPromptBody` ("permite que Doxa use alarmas exactas"). Body prose, no slot risk.

### F-ES-07 · Minor · C1 §3 "Oración diaria" ★ + C4 coherence
- **Key:** `prayerReminderTitle`
- **English:** "Ready for today's prayer?"
- **Current:** `"¿Todo listo para orar hoy?"`
- **Proposed:** `"¿Todo listo para la oración de hoy?"`
- **Glossary ref:** glossary.es_ES.md §3 "Oración diaria (por un grupo específico) ★ Término clave" — "«Diaria» es intencional … Evitar traducir como «oración regular» u «oración ocasional»"; in-file precedent `reminderNotificationBody` = "Abre Doxa para comenzar **la oración de hoy**."
- **Why:** The current wording turns a *named daily commitment* into a generic "feel like praying today?" nudge — exactly the softening §3 warns against. `la oración de hoy` refers to today's instalment of the daily prayer the user signed up for, and it is already the phrase the app uses in the reminder notification, so banner and notification stop sounding like two different products. `¿Todo listo…?` is retained deliberately: it keeps the string gender-neutral for an unknown user (`¿Listo?`/`¿Lista?` would not). `¿ ?` pair correct; 34 chars, banner title, no overflow risk.

### F-ES-08 · Minor · C6 placeholder guillemets (§6.6)
- **Keys:** `prayForPeopleGroupLabel`, `prayerReminderBody` (in scope) + `scanToPray`, `switchPeopleGroupConfirm` (approved keys, eligible under §6.6 only)

| Key | Current | Proposed |
|---|---|---|
| `prayForPeopleGroupLabel` | `Orar por {peopleGroup}` | `Orar por «{peopleGroup}»` |
| `prayerReminderBody` | `Toca para orar por {peopleGroup}.` | `Toca para orar por «{peopleGroup}».` |
| `scanToPray` | `Escanea el código para descargar la aplicación y ora por los {name}` | `Escanea el código para descargar la aplicación y ora por los «{name}»` |
| `switchPeopleGroupConfirm` | `¿Quieres dejar de orar por {currentName} y empezar a orar por {newName}?` | `¿Quieres dejar de orar por «{currentName}» y empezar a orar por «{newName}»?` |

- **Glossary ref:** typography only; no glossary term involved. Convention set by the approved `peopleGroupIntroTitle` ("Ora por los «{name}»"), `shareMessage`, `wizardConfirmPeopleGroupTitle`.
- **Why:** Spanish already uses guillemets on name-like placeholders in three approved strings; these four break it, so a people-group name is quoted or not depending on which screen shows it. Spanish guillemets take **no** inner spaces (unlike French). Numeric/technical placeholders (`{seconds}`, `{email}`, `{time}`, `{weekday}`, `{version}`) stay bare. Purely cosmetic: the ICU tokens are unchanged, so substitution is unaffected. Screen readers ignore guillemets, so the `a11y`/`notif` strings are unharmed as speech.

### F-ES-09 · Note · C1 §2 — `engaged` is already the glossaried rendering (refutes §6.5)
- **Key:** `engaged`
- **English:** "Engaged" (marker label collapsing the three engagement criteria when a people group is marked engaged — `people_group_details_screen.dart:162-166`)
- **Current:** `"Comprometido"` · **Proposed:** `"Comprometido"` — **no change**
- **Glossary ref:** glossary.es_ES.md §1 "Grupo de personas no comprometido ★ Término clave" and §2 "**Compromiso / comprometido (grupo de personas)**" (the section heading itself); `es.tsv` line 14 `engaged → comprometido`, line 15 `engagement → compromiso`.
- **Why:** §6.5 flags `es` "Comprometido" as the likeliest defect on the reasoning that the English glossary warns against a generic *commitment* reading. Checked against the Spanish glossary, that presumption is wrong: Spanish builds the entire engagement family on **compromiso / comprometido** — "grupos de personas no comprometidos" is the site's own rendering of *unengaged people groups*, and §2 names the precision term "Compromiso", warning only against the *vaguer* alternatives "participación" and "contacto". Changing `engaged` would decouple the chip from `engagementStatus` ("Estado del compromiso"), from `adoptionStatus`, and from the public site's terminology. Grammar checked for the bare-chip use: the implied subject is `grupo (de personas)`, masculine singular, so masculine singular `Comprometido` agrees; no article needed, and 12 chars fits the 200 px marker tile. **Recommendation to C1: leave `es` as is; do not harmonise it away from the glossary for cross-language symmetry** (§8.3 — glossary outranks consistency preference).

### F-ES-10 · Note · C1 §3 — `dailyPrayerCoverage` verified against the superseded coverage entry (§6.4)
- **Key:** `dailyPrayerCoverage`
- **English:** "Daily prayer coverage" (caption under the prayer-status progress bar and the bar's own a11y label — `people_group_details_screen.dart:390, 410`)
- **Current:** `"Cobertura de oración diaria"` · **Proposed:** `"Cobertura de oración diaria"` — **no change**
- **Glossary ref:** glossary.es_ES.md §3 "Oración diaria ★ Término clave" + §3 "Cobertura en oración las 24 horas" ("Evitar que «cobertura» se interprete como seguro o cobertura legal; significa *oración ininterrumpida a lo largo del día*"); `es.tsv` 39–40.
- **Why:** The glossary's coverage entry is the superseded 24-hour form, but it settles two things that decide this string. First, Spanish's sanctioned head for the concept **is** "cobertura": the glossary uses both "Cobertura en oración" (§3 heading, §9 UI-label table) and "cobertura de oración" (§3 example text and the `.tsv`). The insurance risk is a warning about *reading*, not a ban on the word — neutralised by the collocation with "oración" and by the surrounding card ("Estado del compromiso", "Personas comprometidas con la oración", a progress bar). Second, the ★ term "**oración diaria**" must survive intact, and here it does, contiguously. I considered "Cobertura en oración diaria" (to match the §9 label collocation) and "Cobertura diaria de oración"; both are defensible, neither is clearer, and the second splits the ★ term. No glossary patch proposed (§6.4). 27 chars vs 21 English, centred and wrappable — no slot risk.

### F-ES-11 · Note · C4 "exact alarms" vs Android's own es-ES wording (§4.3)
- **Keys:** `allow`, `allowExactAlarms`, `exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`
- **Current:** `"Permitir"` / `"Permitir alarmas exactas"` / `"…alarmas exactas…"` / `"…use alarmas exactas."`
- **Proposed:** unchanged (`"Permitir alarmas exactas"`), except F-ES-06's rewording of the status string
- **Glossary ref:** glossary silent (Android platform vocabulary); nearest precedent = §9's instruction that UI labels stay short and consistent.
- **Why:** The cluster is internally consistent — one term, `alarmas exactas`, in all three strings that mention it, and `Permitir` matches the affirmative Android permission dialogs use in Spanish. Recorded for C1/B2: the destination screen this button opens is titled **"Alarmas y recordatorios"** in Android es-ES, so the label does not literally echo what the user then sees. I recommend keeping `alarmas exactas` anyway — it is the precise technical cause of the late reminders that the two body strings explain, the destination screen carries a single relevant toggle, and adopting "alarmas y recordatorios" would collide with the app's own `recordatorios`. No action unless B2 rules otherwise.

### F-ES-12 · Note · C4 the 15 `feedback*` keys use one settled scheme (§4.3)
- **Keys:** all 15 `feedback*` keys · **Proposed:** scheme unchanged
- **Glossary ref:** glossary silent on "feedback"; precedent = the approved `feedback` button ("Comentarios") plus §9's consistency requirement for UI labels.
- **Why:** Verified as one deliberate scheme, not 15 independent guesses. The thing sent and the feature share the lemma **comentario**: `feedback` "Comentarios", `feedbackSubmit` "Enviar comentarios", `feedbackRateLimited` "muchos comentarios", `feedbackSuccessBody` "Tus comentarios", `feedbackTypeLabel` "¿Qué tipo de comentario?", `feedbackTypeRequired` "un tipo de comentario". The singular in the two type-picker strings is grammatically required (one submission has one type; "¿Qué tipo de comentarios?" would be wrong), so the number variance is not a synonym clash. `feedbackIntro`'s "conocer tu **opinión**" is the fixed Spanish collocation for "we'd love to hear from you" and does not name the artefact, so it does not break the scheme. `Doxa` verified untranslated and unarticled in `feedbackConsentLabel` ("las novedades **de Doxa**") — the article belongs to `novedades`, matching every other Doxa mention in the file (`de Doxa`, `para Doxa`, `que Doxa use`, `Abre Doxa`). Consent wording "Mantenme al día de las novedades de Doxa" is unambiguous first-person opt-in and echoes the approved `wizardNewsSignupTitle` "Mantente al día". No action.

### F-ES-13 · Note · "tap" is rendered two ways in the file — no action in scope
- **Keys:** new: `prayerReminderBody` ("**Toca** para orar…"), `newsSignupSuccessBody` ("**toca** el enlace"); approved: `notificationsHowToEnable` ("**Pulsa** aquí abajo"), `pressBackAgainToExit` ("Vuelve a **pulsar**")
- **Proposed:** no change (the new keys are already internally consistent on `Toca`)
- **Why:** Recorded so C1 sees it rather than rediscovering it. Both verbs are correct es-ES; Android es-ES uses "Toca" for touchscreen taps and "Pulsa" for hardware keys, which is close to how this file already splits them (`pressBackAgainToExit` is the hardware back button). The only genuine outlier is `notificationsHowToEnable`, an approved key outside the §6.6 exception, so it stays untouched.

## In-language coherence (C3 read-through, English out of view)

Read as a group and against the surrounding approved strings, the 44 present translations do sound like one European-Spanish app rather than 44 machine outputs: `tú` never slips into `usted`, buttons stay infinitive, `recordatorio` is the single noun for reminder across `dismissReminderLabel` / `prayerReminder*` / `exactAlarms*` / `nextReminder*`, and `correo de verificación` / `verificar` are the single noun and verb across the whole verification cluster. The two seams a Spanish reader would notice are the ones filed above: the load/send-failure strings drifting into the simple preterite (F-ES-03, F-ES-04), and the home banner (F-ES-07) sounding like a casual nudge next to a notification that speaks of "la oración de hoy". Everything glossary-bearing checks out: `oración`, `orar`, `grupo de personas`, `compromiso/comprometido`, `obreros transculturales`, `Doxa`.

Contract with pre-existing translations (§5.1): `dailyPrayerCoverage` succeeds `prayerCoverage24h` without contradicting §3 (F-ES-10); `engaged` joins `engagementStatus` on the same `compromiso` root (F-ES-09); `forwardLabel` "Adelante" pairs correctly with Flutter's own `MaterialLocalizations.backButtonTooltip` ("Atrás"), which is what the same widget uses for the back arrow (`arrow_button.dart:25-27`) — so it must **not** be aligned to `back` "Volver" or to `nextDay` "Día siguiente".

## Verdict table

| Key | Verdict | Finding |
|---|---|---|
| `accountSectionTitle` | OK | — |
| `allow` | OK | — |
| `allowExactAlarms` | Note | F-ES-11 |
| `clearSearchLabel` | OK | — |
| `dailyPrayerCoverage` | Note | F-ES-10 |
| `dismissReminderLabel` | OK | — |
| `emailUnverified` | OK | — |
| `emailVerified` | OK | — |
| `emailsLoadError` | Major | F-ES-03 |
| `enableNotificationsButton` | Blocker | F-ES-01 |
| `enableNotificationsPromptBody` | Blocker | F-ES-02 |
| `engaged` | Note | F-ES-09 |
| `exactAlarmsDisabledStatus` | Minor | F-ES-06 |
| `exactAlarmsPromptBody` | OK | — |
| `feedbackConsentLabel` | OK | F-ES-12 (note) |
| `feedbackError` | OK | — |
| `feedbackIntro` | OK | F-ES-12 (note) |
| `feedbackMessageLabel` | OK | — |
| `feedbackMessageRequired` | OK | — |
| `feedbackNameLabel` | OK | — |
| `feedbackRateLimited` | OK | — |
| `feedbackSubmit` | OK | — |
| `feedbackSuccessBody` | Minor | F-ES-05 |
| `feedbackSuccessTitle` | OK | — |
| `feedbackTypeCompliment` | OK | — |
| `feedbackTypeLabel` | OK | F-ES-12 (note) |
| `feedbackTypeProblem` | OK | — |
| `feedbackTypeRequired` | OK | — |
| `feedbackTypeSuggestion` | OK | — |
| `forwardLabel` | OK | — |
| `newsSignupSuccessBody` | OK | — |
| `newsSignupSuccessTitle` | OK | — |
| `notNow` | OK | — |
| `partial` | OK | — |
| `pictureCreditLabel` | OK | — |
| `prayForPeopleGroupLabel` | Minor | F-ES-08 |
| `prayerRecordedAnnouncement` | OK | — |
| `prayerReminderBody` | Minor | F-ES-08 |
| `prayerReminderTitle` | Minor | F-ES-07 |
| `resendVerification` | OK | — |
| `resendVerificationCooldown` | OK | — |
| `resendVerificationCountdown` | OK | — |
| `resendVerificationFailed` | Minor | F-ES-04 |
| `resendVerificationSent` | OK | — |
| `signUp` | OK | — |
| `viewProfile` | OK | — |

46 / 46 keys verdicted.

### Approved keys touched (§6.6 exception only)

| Key | Verdict | Finding |
|---|---|---|
| `scanToPray` | Minor | F-ES-08 |
| `switchPeopleGroupConfirm` | Minor | F-ES-08 |

### Notes on the `OK` verdicts that needed a judgement call

- `partial` "Parcial" — judged as **speech**. Announced in isolation, deliberately separated from the marker label so TTS cannot read it as an abbreviation (`engagement_item.dart:61-69`), spoken immediately before e.g. "Estado de la oración". `parcial` is gender-invariable, so the agreement risk §4.1 raises does not exist in Spanish, and it describes the *marker*, not the people — no "half-hearted" reading. Adjective (not `Parcialmente`) is right because the sibling statuses it alternates with are `Sí` / `No`.
- `prayerRecordedAnnouncement` "Oración registrada" — spoken after the Amen tap (`prayer_session_view.dart:274`); short, no abbreviations, no punctuation artefacts, and the *intercession* sense of `oración` established throughout (glossary §3).
- `clearSearchLabel`, `dismissReminderLabel`, `pictureCreditLabel`, `forwardLabel` — all read naturally aloud, use the file's `*Label` noun-phrase/infinitive pattern, no punctuation a screen reader would voice. `dismissReminderLabel` "Descartar recordatorio" matches approved `dismissNextReminder` "Descartar siguiente".
- `emailVerified` "Verificado" / `emailUnverified` "Sin verificar" — status sits directly under the address (`signed_up_email_tile.dart:104-116`); the file's noun is `Correo electrónico` (masculine), so masculine `Verificado` agrees. The adjective/prepositional asymmetry is idiomatic — `Sin verificar` is the natural status chip and clearer than `No verificado`.
- `signUp` "Registrarse" — glossary §9 "**Regístrate**" and `es.tsv` 87 `sign up → registrarse` settle the lemma; the infinitive is the form the file's button style requires, and `newsSignupSuccessTitle` "¡Gracias por registrarte!" keeps the same verb.
- `resendVerificationCooldown` / `resendVerificationCountdown` — the space in `{seconds} s` is correct Spanish unit typography (RAE/SI) and a deliberate improvement on the English `{seconds}s`; `{seconds}` stays bare per §6.6.
- `feedbackTypeCompliment` "Elogio" — chosen over "Felicitación" (which reads as congratulating the user, not praising the app); 6 chars, safest of the three chips.

## Decisions made where the glossary was silent

| Term | Chosen rendering | Glossary precedent applied |
|---|---|---|
| daily prayer coverage (§6.4 gap) | **Cobertura de oración diaria** | §3 "Cobertura en oración las 24 horas" sanctions *cobertura* as the head and forbids only the insurance *reading*; ★ §3 "Oración diaria" preserved contiguously; `es.tsv` 39–40 |
| feedback (feature + artefact) | **comentarios** (pl.); *tipo de comentario* (sg. where one submission is meant) | §9 UI-label consistency; in-file approved `feedback` = "Comentarios" |
| feedback (as sentiment, intro prose) | **opinión** ("conocer tu opinión") | §9 "usar equivalente local natural" — fixed collocation, does not name the artefact, so no clash with *comentarios* |
| exact alarms | **alarmas exactas** | §9 "mantener corto"/consistency; kept over Android es-ES's screen title "Alarmas y recordatorios" to avoid colliding with the app's own *recordatorios* (F-ES-11) |
| verification email | **correo de verificación** | in-file `emailLabel` "Correo electrónico"; one noun reused across the cluster |
| reminder | **recordatorio** | already settled by approved `reminders` / `newReminder` / `nextReminder*` |
| notifications | **notificaciones** | approved `notifications`, `enableNotifications` |
| push (notifications) | **notificaciones push** | §7 loanword allowance (`Pentecostal`); §2 `diáspora` |
| emails (a list of addresses) | **direcciones de correo** | §1 "una traducción imprecisa invalida…" — name the real referent when the English is loose (F-ES-03) |
| profile | **perfil** | approved `profile` "Perfil" |
| compliment (feedback type) | **Elogio** | §9 short, natural UI label |
| "sent as {email}" | **enviado desde {email}** | §9 natural-local-equivalent principle; avoids the "as = in the form of" calque |
| tap | **Toca** (touchscreen) / *Pulsa* left on the hardware-key string | §9 usability consistency; matches Android es-ES's own split (F-ES-13) |
| engaged, as a bare chip | **Comprometido** (m. sg., no article) | §2 "Compromiso / comprometido (grupo de personas)" — agrees with *grupo de personas* (m. sg.); `es.tsv` 14 (F-ES-09) |

No `.arb` file, generated Dart file, or glossary was modified.
