# Findings — review-fr

**Agent:** review-fr (A3, Phase 1)
**Scope:** 46 keys, French (`lib/l10n/app_fr.arb`)
**Glossary consulted:** `../translation/translated-glossaries/glossary.fr_FR.md` (source of truth), `../translation/glossary.md` (concepts), `../translation/deepl-glossaries/fr.tsv` (index)
**Keys verdicted:** 46 / 46
**Severity counts:** 2 Blocker · 2 Major · 10 Minor · 32 OK · 3 Notes (no key verdict)

> **Persistence note (orchestrator):** produced by the A3 subagent and persisted by the orchestrator, because subagents are blocked from writing findings files. Content is the agent's, unaltered in substance.
>
> **IMPORTANT — invisible characters.** The French proposed strings depend on characters that are visually identical to a plain space and can be silently degraded by any copy step, including this one. **The prose codepoint specifications in the legend below and in each finding are AUTHORITATIVE.** Do not trust the literal character in this file; D3 must insert U+202F / U+00A0 explicitly per the spec, then verify with a codepoint check.

## Typographic legend — read before applying

The approved strings in `app_fr.arb` already follow standard French spacing, and every proposed string below is specified to keep it:

| Before | Character | Codepoint | Evidence in the approved file |
|---|---|---|---|
| `;` `?` `!` | narrow no-break space | **U+202F** | `notificationsDisabledStatus`, `selectPeopleGroupConfirm`, `prayerThankYouVerse`, `switchPeopleGroupConfirm`, `wizardConfirmPeopleGroupTitle` |
| `:` | no-break space | **U+00A0** | `shareMessage` |
| inside `«  »` | narrow no-break space **U+202F** | — | guillemets currently use a plain U+0020 — see F-FR-11 |
| between a number and a unit | no-break space **U+00A0** | — | currently a plain U+0020 — see F-FR-08 |

---

## Findings

### F-FR-01 · Blocker · C2 meaning / missing string
- **Key:** `enableNotificationsButton`
- **English:** "Enable notifications"
- **Current:** *absent from `app_fr.arb`* — falls back to English for every French user
- **Proposed:** `Activer les notifications`
- **Glossary ref:** glossary.fr_FR.md is silent (platform vocabulary); resolved from the approved key `enableNotifications`, which carries the identical English string
- **Why:** `app_en.arb` has two keys with the string "Enable notifications" — `enableNotifications` (settings navigation) and `enableNotificationsButton` (requests the OS permission, `lib/components/notifications/enable_notifications_prompt.dart:89`). The first is already translated "Activer les notifications"; the second must match it exactly, or the same button reads differently in two places. Infinitive, per the file's button style (`allow` → "Autoriser", `viewProfile` → "Voir le profil"). Also needs its `@key` block copied from `app_en.arb` (§6.2).

### F-FR-02 · Blocker · C2 meaning / missing string
- **Key:** `enableNotificationsPromptBody`
- **English:** "Enable notifications to also receive updates in push notifications."
- **Current:** *absent from `app_fr.arb`* — falls back to English for every French user
- **Proposed:** `Activez les notifications pour recevoir aussi les actualités par notification push.`
- **Glossary ref:** glossary.fr_FR.md silent; resolved from the approved `updatesFromDoxa` ("Recevoir les actualités de Doxa") and `signUpForUpdates` ("Inscrivez-vous pour recevoir nos actualités"), which settle *updates (news)* → **actualités**
- **Why:** The prompt sits above the F-FR-01 button after the user signs up for updates (`enable_notifications_prompt.dart:83`), so it must explain that push is an *additional* channel for the same news — "aussi" carries the English "also", and "actualités" keeps the word the rest of the signup flow uses. Second-person plural imperative matches the file's instructional voice (`notificationsHowToEnable` "Appuyez ci-dessous…", `newsSignupSuccessBody` "Ouvrez votre boîte de réception…"). "notification push" is left as the borrowed platform term. Also needs its `@key` block (§6.2).

### F-FR-03 · Major · C3 standalone sense / C5 naturalness
- **Key:** `prayerReminderTitle`
- **English:** "Ready for today's prayer?"
- **Current:** `C'est le moment de prier aujourd'hui ?`
- **Proposed:** `Prêt pour la prière d'aujourd'hui ?`  — **U+202F before the `?`**
- **Glossary ref:** glossary.fr_FR.md §3 "Prière quotidienne (pour un peuple) ★" — the banner must invoke the daily prayer commitment, not a generic nudge
- **Why:** The current French means "Is *this* the moment to pray today?", which is not a question a user can answer and is not what the English asks. The English asks about the user's readiness for the prayer they have committed to make each day; the French asks whether now happens to be a good time, which weakens the daily commitment to an optional nudge — exactly what §4.1 forbids for this key. It also collides with the approved `reminderNotificationTitle` "C'est l'heure de prier", so the banner and the notification read as near-duplicates. The replacement names the object of the commitment ("la prière d'aujourd'hui") using the *same* wording as the approved `reminderNotificationBody` ("commencer la prière d'aujourd'hui"), and keeps the question. Masculine-default adjective follows the file's established practice (`feedbackConsentLabel` "Tenez-moi informé", `wizardNewsSignupTitle` "Restez informé"). The narrow no-break space fixes the plain space the current string uses before `?`.

### F-FR-04 · Major · C2 meaning reversed
- **Key:** `feedbackSuccessBody`
- **English:** "Your feedback was sent as {email}. If that isn't the right address, send it again with the correct one."
- **Current:** `Vos commentaires ont été envoyés à l'adresse {email}. Si ce n'est pas la bonne adresse, renvoyez-les avec la bonne.`
- **Proposed:** `Vos commentaires ont été envoyés depuis l'adresse {email}. Si ce n'est pas la bonne adresse, renvoyez-les avec la bonne.`
- **Glossary ref:** n/a (no glossaried term); C2 against the `@key` description "echoing the email used"
- **Why:** English "sent **as** {email}" identifies the *sender*. `à l'adresse {email}` says the feedback was sent **to** that address — the opposite direction. The widget's own contract is explicit (`lib/components/widgets/feedback_success.dart:9-11`: "echoes the email the feedback was sent with, so they can confirm it matches the address they intended"). As it stands, a French user is told their feedback was mailed to themselves, and the second sentence then makes no sense: if the app sent it *to* the wrong address, resending "with the correct one" is incoherent advice. `depuis l'adresse` restores the sender reading and keeps the second sentence working unchanged. Borderline Blocker — it is a plainly wrong statement of fact, held to Major only because nothing ministry-facing is misstated.

### F-FR-05 · Minor · C4 cluster consistency / C6 placeholder typography
- **Key:** `prayerReminderBody`
- **English:** "Tap to pray for {peopleGroup}."
- **Current:** `Touchez pour prier pour {peopleGroup}.`
- **Proposed:** `Appuyez ici pour prier pour « {peopleGroup} ».`  — **U+202F inside both guillemets**
- **Glossary ref:** glossary.fr_FR.md §9 "Prier" (imperative, short) + §1 "Peuple ★" for the placeholder's referent; §6.6 of the plan for the guillemets
- **Why:** Three things. (1) *Tap* is rendered "Appuyez" everywhere else in this file (`notificationsHowToEnable`, `newsSignupSuccessBody`); "Touchez" is a third synonym for the same gesture and breaks the reminder cluster's voice. (2) "pour prier pour" repeats the preposition with two different functions; inserting "ici" (accurate — the whole banner is the tap target, `prayer_reminder_banner.dart:78-80`) separates them and reads naturally. (3) The people-group name is a name-like placeholder and must carry the file's guillemets (§6.6). Not a Blocker: the current string is understandable, just off-house-style.

### F-FR-06 · Minor · C6 placeholder typography
- **Key:** `prayForPeopleGroupLabel`
- **English:** "Pray for {peopleGroup}"
- **Current:** `Prier pour {peopleGroup}`
- **Proposed:** `Prier pour « {peopleGroup} »`  — **U+202F inside both guillemets**
- **Glossary ref:** plan §6.6 (French convention: guillemets on name-like placeholders); glossary.fr_FR.md §9 "Prier" — infinitive is right for a button label
- **Why:** Typography only, per §6.6 — nothing is functionally broken. The approved `switchPeopleGroupConfirm` and `wizardConfirmPeopleGroupTitle` both wrap name placeholders in guillemets; this new key is bare. As a spoken `Semantics` label on a button (`prayer_reminder_banner.dart:77`) the guillemets are silent, so this is purely about the file being internally consistent. The infinitive "Prier" is correct for a button and matches `wizardConfirmPeopleGroupTitle`.

### F-FR-07 · Minor · C5 French punctuation spacing
- **Keys:** `feedbackSuccessTitle`, `feedbackTypeLabel`, `newsSignupSuccessTitle`, `exactAlarmsDisabledStatus`
- **Change:** the only difference is the space character before the punctuation mark — **U+0020 → U+202F (narrow no-break space)**. Wording is unchanged in all four.

| Key | Current wording | Space before |
|---|---|---|
| `feedbackSuccessTitle` | `Merci !` | `!` → U+202F |
| `feedbackTypeLabel` | `Quel type de commentaire ?` | `?` → U+202F |
| `newsSignupSuccessTitle` | `Merci de votre inscription !` | `!` → U+202F |
| `exactAlarmsDisabledStatus` | `Les alarmes exactes ne sont pas autorisées pour Doxa ; vos rappels de prière peuvent donc arriver avec plusieurs minutes de retard.` | `;` → U+202F |

- **Glossary ref:** n/a — house convention, established by the approved `notificationsDisabledStatus`, `selectPeopleGroupConfirm`, `prayerThankYouVerse`, `switchPeopleGroupConfirm`, `wizardConfirmPeopleGroupTitle`, all of which use U+202F
- **Why:** All five pre-existing strings that need a space before `;` `?` `!` use U+202F. These four new strings use a plain U+0020, so the file now does both. Beyond consistency it is a rendering defect: a breaking space lets Flutter wrap the line with the `!`, `?` or `;` orphaned at the start of the next line — visible in the narrow feedback panel and the reminders banner.

### F-FR-08 · Minor · C5 French unit spacing
- **Keys:** `resendVerificationCooldown`, `resendVerificationCountdown`
- **Current:** `Veuillez patienter {seconds} s avant de demander un autre e-mail.` / `Renvoyer dans {seconds} s`
- **Proposed:** same wording; the space between `{seconds}` and `s` becomes a **no-break space, U+00A0**
- **Glossary ref:** n/a — French typographic rule (a number and its unit symbol are never separated); same class as the U+00A0 the approved `shareMessage` uses before its colon
- **Why:** Wording and placeholder are correct — French requires the space between a number and its unit symbol (`s`) and requires it to be unbreakable. `resendVerificationCountdown` is a button label whose text can wrap, which is exactly where "12" / "s" would split. Nothing else changes.

### F-FR-09 · Minor · C3 standalone sense (spoken) / C5 naturalness
- **Key:** `partial`
- **English:** "Partial"
- **Current:** `Partiel`
- **Proposed:** `En partie`
- **Glossary ref:** glossary.fr_FR.md §1 "Peuple sous-engagé ★" — a partly-met marker means the *work* is insufficient in scale, never that the people are half-hearted; neither reading is at risk here, so this is naturalness only
- **Why:** This string is never seen. It is spoken alone as its own semantics node, by design (`lib/components/cards/engagement_item.dart:50-69`, and the comment there explains why it is isolated), as the third member of the set `yes` / `no` / `partial` — spoken in French as "Oui" / "Non" / "Partiel". Heard in isolation, "Partiel" is ambiguous: as a bare noun *un partiel* is a mid-term exam, and as an adjective it needs a noun it can agree with, which a standalone announcement does not give it. "En partie" is invariable, cannot be misheard as a noun, and sits in the same register as "Oui"/"Non", which are the words the user hears from the sibling markers. In practice the only marker that goes partial is `prayerStatus` (`people_group_details_screen.dart:148-152`), so nothing depends on gender agreement. Nine characters, and spoken rather than drawn, so no slot risk.

### F-FR-10 · Minor · C4 register / platform idiom
- **Key:** `feedbackSubmit`
- **English:** "Send feedback"
- **Current:** `Envoyer les commentaires`
- **Proposed:** `Envoyer des commentaires`
- **Glossary ref:** glossary.fr_FR.md silent on *feedback*; resolved from the approved `feedback` = "Commentaires" plus Android/Google's own French string for this exact button ("Envoyer des commentaires")
- **Why:** Polish, not a defect. The definite article implies specific comments already known to both parties; the user is sending *some* feedback, which French expresses with the partitive "des". This is also the wording French-speaking users see on the equivalent Android and Google-app buttons, which is worth matching for a button doing the same job. The noun "commentaires" is correct and stays — see the decisions table. Length is unchanged, so the single end-aligned button (`feedback_form.dart:180-184`) is unaffected.

### F-FR-11 · Minor · C6 placeholder typography (approved keys, §6.6 only)
- **Keys:** `peopleGroupIntroTitle`, `scanToPray`, `shareMessage` (guillemets missing) and `switchPeopleGroupConfirm`, `wizardConfirmPeopleGroupTitle` (guillemets present, inner space is a plain U+0020)
- **Proposed** — guillemets on every name-like placeholder, **U+202F inside them**, numeric and technical placeholders left bare:

| Key | Current | Proposed |
|---|---|---|
| `peopleGroupIntroTitle` | `Priez pour l’{name}` | `Priez pour « {name} »` |
| `scanToPray` | `Scannez le code pour télécharger l'application et priez pour l'{name}` | `Scannez le code pour télécharger l'application et priez pour « {name} »` |
| `shareMessage` | `Priez avec moi pour l’{name} — téléchargez l’application Doxa Prayer :` | `Priez avec moi pour « {name} » — téléchargez l'application Doxa Prayer :` |
| `switchPeopleGroupConfirm` | `Voulez-vous cesser de prier pour « {currentName} » et commencer à prier pour « {newName} » ?` | same wording, inner spaces → U+202F |
| `wizardConfirmPeopleGroupTitle` | `Prier pour « {name} » ?` | same wording, inner spaces + pre-`?` space → U+202F |

- **Glossary ref:** plan §6.6 (these five plus the two new keys in F-FR-05/F-FR-06 are the only seven eligible keys); glossary.fr_FR.md §1 "Peuple ★" for what the placeholder holds
- **Why:** Typography and consistency, never correctness — a bare placeholder substitutes fine. Two sub-points change more than a space and need stating:
  1. The three keys without guillemets currently glue an elided article to the placeholder (`l’{name}`, `l'{name}`). That is not merely inconsistent, it is ungrammatical for any people-group name beginning with a consonant — "l'Peul", "l'Kurde" — and `l’« {name} »` is not a legal French construction, so applying the convention necessarily drops the article. `Priez pour « Peul »` is correct for every name; the guillemets do the work the article was attempting.
  2. `shareMessage`'s U+00A0 before its final `:` is **correct** French (a colon takes the full no-break space, not the narrow one) — leave it exactly as it is. Its two `’` characters are normalised to `'` to match the 37-to-3 majority in the file; same for `scanToPray`.
- Severity **Minor** — must never displace F-FR-01 … F-FR-04.

### F-FR-12 · Note · ICU defect in an approved plural (out of scope)
- **Key:** `nRemindersSet`
- **Current:** `{count, plural, =0{Aucun rappel défini} =1{1 rappel défini} other{{count}s rappels définis}}`
- **Proposed:** `{count, plural, =0{Aucun rappel défini} =1{1 rappel défini} other{{count} rappels définis}}`
- **Why:** Real defect, confirmed: the stray `s` immediately after `{count}` is not part of any French word and renders as "5s rappels définis" on the home-screen next-reminder card. It is a leftover from the English pluralisation, not an intentional unit suffix (compare the sibling `nPeopleGroups`, which is clean). Out of the 46-key scope, so recorded as a Note; B1/D3 should apply it. The `=0`/`=1`/`other` structure itself is fine for French.

### F-FR-13 · Note · metadata drift (for B1 / D3)
- **Keys:** `@feedback`, `emailLabel`
- **Why:** Two observations outside the 46-key scope, recorded so they are not lost. (1) `app_fr.arb`'s `@feedback` description reads "Button that opens the feedback page in the browser"; `app_en.arb` now says "Button that opens the in-app feedback panel". The description is stale and will mislead the next translator — it should be re-copied from the template like the 21 missing blocks in §6.2. (2) `emailLabel` is "Email" while every other string in the file writes "e-mail" ("l'e-mail de vérification", "vos e-mails"). A future pass should settle on "E-mail"; no action here, since `emailLabel` is neither in scope nor in the §4.3 verification-email cluster.

### F-FR-14 · Note · glossary carries the superseded coverage term (no action)
- **Why:** `glossary.fr_FR.md` §3 and §9 and `fr.tsv:41` carry only "couverture de prière 24h/24" for the coverage goal, which commit `2e964bc` superseded when the ministry goal changed from 24-hour coverage to daily prayer. Per plan §6.4 the glossaries are frozen and read-only; **no glossary patch is proposed.** The rendering of `dailyPrayerCoverage` was built from the two glossaried halves instead — see the decisions table. Recorded so C1 knows the French decision rests on a composed term, not a glossary lookup.

---

## Verdict table

| Key | Verdict | Finding |
|---|---|---|
| `accountSectionTitle` | OK | — |
| `allow` | OK | — |
| `allowExactAlarms` | OK | — |
| `clearSearchLabel` | OK | — |
| `dailyPrayerCoverage` | OK | — |
| `dismissReminderLabel` | OK | — |
| `emailUnverified` | OK | — |
| `emailVerified` | OK | — |
| `emailsLoadError` | OK | — |
| `enableNotificationsButton` | **Blocker** | F-FR-01 |
| `enableNotificationsPromptBody` | **Blocker** | F-FR-02 |
| `engaged` | OK | — |
| `exactAlarmsDisabledStatus` | Minor | F-FR-07 |
| `exactAlarmsPromptBody` | OK | — |
| `feedbackConsentLabel` | OK | — |
| `feedbackError` | OK | — |
| `feedbackIntro` | OK | — |
| `feedbackMessageLabel` | OK | — |
| `feedbackMessageRequired` | OK | — |
| `feedbackNameLabel` | OK | — |
| `feedbackRateLimited` | OK | — |
| `feedbackSubmit` | Minor | F-FR-10 |
| `feedbackSuccessBody` | **Major** | F-FR-04 |
| `feedbackSuccessTitle` | Minor | F-FR-07 |
| `feedbackTypeCompliment` | OK | — |
| `feedbackTypeLabel` | Minor | F-FR-07 |
| `feedbackTypeProblem` | OK | — |
| `feedbackTypeRequired` | OK | — |
| `feedbackTypeSuggestion` | OK | — |
| `forwardLabel` | OK | — |
| `newsSignupSuccessBody` | OK | — |
| `newsSignupSuccessTitle` | Minor | F-FR-07 |
| `notNow` | OK | — |
| `partial` | Minor | F-FR-09 |
| `pictureCreditLabel` | OK | — |
| `prayForPeopleGroupLabel` | Minor | F-FR-06 |
| `prayerRecordedAnnouncement` | OK | — |
| `prayerReminderBody` | Minor | F-FR-05 |
| `prayerReminderTitle` | **Major** | F-FR-03 |
| `resendVerification` | OK | — |
| `resendVerificationCooldown` | Minor | F-FR-08 |
| `resendVerificationCountdown` | Minor | F-FR-08 |
| `resendVerificationFailed` | OK | — |
| `resendVerificationSent` | OK | — |
| `signUp` | OK | — |
| `viewProfile` | OK | — |

**46 / 46 verdicted.** Out-of-scope keys touched by findings: `nRemindersSet` (F-FR-12), the five §6.6 placeholder keys (F-FR-11), `@feedback` / `emailLabel` (F-FR-13).

### Why the glossary-sensitive keys (§4.1) passed

| Key | Current French | Glossary section checked | Ruling |
|---|---|---|---|
| `engaged` | `Engagé` | fr_FR §2 "Engagement / engagé (peuple)"; `fr.tsv:15` `engaged`→`engagé` | **Correct — do not change.** The glossary's precision sense (resident, sustained, cross-cultural, MPÉ-oriented) is carried by "engagé", and the glossary explicitly rejects "implication" and "contact", which the French avoids. Agreement is right: the marker labels a *peuple* (masculine singular — `peopleGroup` = "Peuple"), inside a card headed `engagementStatus` "Statut de l'engagement", so the bare masculine singular chip reads as "[peuple] engagé". It sits among noun-phrase siblings ("Statut de prière", "Ouvriers transculturels présents") at `people_group_details_screen.dart:162-166`, where it replaces the last three markers; no article is needed or wanted. `engagement` / `engagé` share a root, so the family is coherent. |
| `dailyPrayerCoverage` | `Couverture de prière quotidienne` | fr_FR §3 "Prière quotidienne ★" + §3 "Couverture de prière 24h/24" (superseded, F-FR-14) | **Correct — do not change.** Composed from the two glossaried halves: "couverture de prière" is the glossary's own reviewed French for prayer coverage (§3 and §9 both use it), and "prière quotidienne" is the ★ seed term, present intact. The glossary's constraint is that *couverture* must not read as insurance or legal cover; here it labels a progress bar counting intercessors toward a goal (`people_group_details_screen.dart:388-414`, value `"{committed}/144"`), and the insurance reading has no purchase in that frame. I considered "Couverture par la prière quotidienne", which removes the theoretical ambiguity of whether *quotidienne* attaches to *couverture* or to *prière* — rejected: both readings state the same fact, the glossaried term survives intact only in the current form, and the alternative is longer under a centred caption. The superseded "24h/24" was correctly dropped. |
| `partial` | `Partiel` → `En partie` | fr_FR §1 "Peuple sous-engagé ★" | Naturalness only, F-FR-09. Neither form implies the *people* are half-hearted, which is the glossary's actual warning. |
| `prayForPeopleGroupLabel` | `Prier pour {peopleGroup}` | fr_FR §1 "Peuple ★" + §9 "Prier" | Wording correct (infinitive, glossaried verb); guillemets only, F-FR-06. |
| `prayerReminderBody` | `Touchez pour prier pour {peopleGroup}.` | fr_FR §9 "Prier" | Glossaried verb correct; F-FR-05 is about *tap* and typography. |
| `prayerReminderTitle` | `C'est le moment de prier aujourd'hui ?` | fr_FR §3 "Prière quotidienne ★" | **Fails** — reads as a casual nudge, not the daily commitment. F-FR-03. |
| `prayerRecordedAnnouncement` | `Prière enregistrée` | fr_FR §3 | Correct. Feminine agreement with "prière" is right, "enregistrée" is the neutral technical verb (the act logged is the user's intercession, `prayer_session_view.dart:274`), and it is short and clean as speech. |
| `signUp` | `S'inscrire` | fr_FR §9 "S'inscrire"; `fr.tsv:87` | Correct, and the explicit `.tsv` pair was used. Coherent with `newsSignupSuccessTitle` "Merci de votre inscription !" and `signUpForUpdates` "Inscrivez-vous…" — one verb family throughout. |
| `feedbackConsentLabel` | `Tenez-moi informé des actualités de Doxa` | fr_FR §7 "DOXA" | Correct. `Doxa` untranslated and unscripted. Unambiguous consent: it states what will be sent and who sends it, in the first person, so ticking it cannot be mistaken for anything else. Masculine-default "informé" matches `wizardNewsSignupTitle` "Restez informé". |
| `newsSignupSuccessTitle` | `Merci de votre inscription !` | fr_FR §9 "S'inscrire" | Correct wording, same verb family as `signUp`; only the space before `!` changes (F-FR-07). |
| `newsSignupSuccessBody` | `Nous avons envoyé un e-mail de vérification à {email}. Ouvrez votre boîte de réception et appuyez sur le lien pour confirmer votre inscription.` | fr_FR §9 "S'inscrire" | Correct. "inscription" ties back to `signUp`; "e-mail de vérification" matches the whole verification cluster; `{email}` intact and correctly a *recipient* here (unlike F-FR-04). The dropped "Please" is carried by the French imperative, as elsewhere in the file. |
| `enableNotificationsPromptBody` | *missing* | — | F-FR-02. |

### Cluster consistency (§4.3) — checked as a group

- **feedback (15 keys):** one noun throughout — **commentaire(s)**: `feedback` "Commentaires", `feedbackSubmit`, `feedbackRateLimited`, `feedbackSuccessBody` (plural, the artefact) and `feedbackTypeLabel` / `feedbackTypeRequired` ("un type de commentaire", correctly singular after *type de*). No synonym drift. `feedbackIntro`'s "votre avis" is the one other noun, and it is right: it translates "hear from you / what you think", not the word *feedback*, and "Nous aimerions connaître votre avis" is the idiomatic French for that sentence. Errors are shared correctly — `feedbackError` and `newsSignupError` are byte-identical, as their English is. Validation strings match the approved pattern ("Veuillez saisir un message." ≈ "Veuillez saisir votre nom.").
- **exact alarms (4 keys):** "alarmes exactes" in both `allowExactAlarms` and `exactAlarmsDisabledStatus`, `allow` → "Autoriser" (Android's French permission verb), `exactAlarmsPromptBody` "à l'heure pile" for "right on time" — natural, and the same "rappels de prière" noun as the rest of the reminder cluster. See the decisions table for why Android's own screen name was not borrowed wholesale.
- **verification email (8 keys):** one noun "e-mail de vérification", one verb "vérifier", used identically in `resendVerification`, `resendVerificationSent`, `resendVerificationFailed`, `newsSignupSuccessBody`, and as the adjectival statuses `emailVerified` "Vérifié" / `emailUnverified` "Non vérifié". Those two are masculine singular, agreeing with "e-mail" — the noun this file uses everywhere — and they render directly beneath the address itself (`signed_up_email_tile.dart:106-114`), so the referent is unambiguous. Consistent, no change.
- **reminder (5 keys):** one noun, "rappel", everywhere — `dismissReminderLabel` "Ignorer le rappel" (and the approved `dismissNextReminder` "Ignorer le prochain", same verb), `exactAlarms*` "rappels de prière", `prayerReminder*`. Consistent.
- **accessibility labels (6 keys):** judged as speech. `clearSearchLabel` "Effacer la recherche", `dismissReminderLabel` "Ignorer le rappel", `pictureCreditLabel` "Crédit photo", `forwardLabel` "Suivant", `prayerRecordedAnnouncement` "Prière enregistrée", `prayForPeopleGroupLabel` "Prier pour …" — all full words, no abbreviations, no punctuation artefacts, natural spoken order, consistent with the approved `previousDay` / `nextDay` ("Jour précédent" / "Jour suivant"). Only `partial` (F-FR-09) and the guillemets (F-FR-06) needed anything.

### Contract with the pre-existing translations

- `dailyPrayerCoverage` replaces `prayerCoverage24h`: the removed key's "24h/24" arithmetic claim is gone from the French too, and nothing else in the file still promises 24-hour coverage.
- `engaged` joins `engagementStatus`: same root, no competing rendering of *engagement*.
- `forwardLabel` "Suivant" pairs with the back arrow, whose label comes from Flutter's own French `MaterialLocalizations.backButtonTooltip` = "Retour" (`arrow_button.dart:25-27`) — "Retour" / "Suivant" is the standard French pair, and "Suivant" also matches the approved `nextDay` "Jour suivant". §6.8 raised this as possibly saying *next* rather than *forward*; in French that is the right call, so no finding.
- Register: `vous` throughout, matching every approved string; no `tu` anywhere in the new content. Buttons are infinitive ("Autoriser", "S'inscrire", "Voir le profil", "Renvoyer l'e-mail de vérification", "Envoyer des commentaires", "Activer les notifications"), matching the approved button set; second-person imperative is reserved for instructions and section headings, as before.

### In-language coherence

Read as a block, the 44 translated strings do sound like one app: one verb for signing up, one noun for reminders, one noun for the verification email, one noun for feedback, and the same "Impossible de …" / "Veuillez …" frames the approved file already used. The seams are narrow and specific rather than systemic: the punctuation spacing regressed to plain spaces (F-FR-07/F-FR-08), one gesture verb drifted to "Touchez" (F-FR-05), one banner lost the daily framing (F-FR-03), and one preposition reversed a sentence (F-FR-04). Two strings were never translated at all (F-FR-01/F-FR-02).

---

## Decisions made where the glossary was silent

| Term | Chosen rendering | Glossary precedent applied |
|---|---|---|
| daily prayer coverage | `Couverture de prière quotidienne` (kept) | fr_FR §3 "Couverture de prière 24h/24" supplies **couverture de prière** as the reviewed French for prayer coverage; §3 "Prière quotidienne ★" supplies **prière quotidienne**. The superseded 24-hour half is dropped per plan §6.4; the glossary's "not insurance / not legal cover" constraint is satisfied by the progress-bar context. Alternative "Couverture par la prière quotidienne" considered and rejected (longer, no gain in meaning). |
| feedback (the artefact sent) | **commentaires** | Nearest precedent is the file's own approved `feedback` = "Commentaires", itself the standard French Android/Google rendering of this exact UI concept. fr_FR §9 shows the glossary's method for interface labels: use the established local UI word, not a coinage. |
| feedback (as "what you think") | **votre avis** (in `feedbackIntro` only) | Same §9 method — the English sentence contains no *feedback* token, and "connaître votre avis" is the settled French for "hear what you think". Deliberately not extended to the other 14 keys. |
| exact alarms | **alarmes exactes**; the verb **Autoriser** | Android's French special-access screen is titled "Alarmes et rappels", but this app's own `reminders` is already "Rappels" (prayer reminders), so borrowing Android's noun would make "rappels" mean two different things on one screen. The literal "alarmes exactes" is kept for the concept and "Autoriser" — Android's French permission verb — for the action, which is the part users must recognise. Precedent: fr_FR §9's rule that interface labels follow the established platform word where it does not collide. |
| reminder | **rappel** | Approved `reminders` / `newReminder` / `setReminder` cluster; unchanged. |
| verification email | **e-mail de vérification**; verb **vérifier** | Approved `emailInvalid` / `emailLabel` family uses "e-mail"; no glossary term exists. Applied uniformly across all 8 cluster keys. |
| notifications / push notifications | **notifications** / **notification push** | Approved `notifications`, `notificationsEnabledStatus`; fr_FR §7's loanword rule (as applied to "diaspora", "pentecôtiste") licenses keeping *push* unadapted. |
| profile | **profil** | Approved `profile` = "Profil"; `viewProfile` follows it. |
| compliment | **Compliment** | Direct French cognate with the same positive-feedback sense; no glossary term. Chip length 10 chars, same as English. |
| forward (navigation arrow) | **Suivant** | Approved `nextDay` "Jour suivant"; pairs with Flutter's French "Retour" for the back arrow in the same widget. §6.8 resolved in favour of the existing string. |
| partial (spoken status) | **En partie** | fr_FR §1 "Peuple sous-engagé ★" warns only against implying the people are indifferent; the choice between adjective and adverbial phrase is unaddressed, so it was made on the glossary's stated priority of an unambiguous reading, matching the register of the sibling statuses "Oui" / "Non". |
| tap (gesture) | **Appuyez** | Approved `notificationsHowToEnable` "Appuyez ci-dessous…" and `newsSignupSuccessBody` "appuyez sur le lien". |
| today's prayer | **la prière d'aujourd'hui** | Approved `reminderNotificationBody` "commencer la prière d'aujourd'hui", which renders the same English phrase. |
| updates (news) | **actualités** | Approved `updatesFromDoxa` "Recevoir les actualités de Doxa" and `signUpForUpdates`. |
| gendered adjectives addressed to the user | masculine default, no inclusive forms | Approved `feedbackConsentLabel` "Tenez-moi informé" and `wizardNewsSignupTitle` "Restez informé" — applied to "Prêt" in F-FR-03. |
| spacing before `; ? !` / before `:` / number–unit | **U+202F** / **U+00A0** / **U+00A0** | Approved `notificationsDisabledStatus`, `selectPeopleGroupConfirm`, `prayerThankYouVerse`, `switchPeopleGroupConfirm`, `wizardConfirmPeopleGroupTitle` (U+202F) and `shareMessage` (U+00A0 before `:`) — the file already encodes the standard French rule; the new strings are brought into line (F-FR-07, F-FR-08, F-FR-11). |
| guillemets around name-like placeholders | `« {name} »` with U+202F inside | Plan §6.6 + approved `switchPeopleGroupConfirm` / `wizardConfirmPeopleGroupTitle`. Numeric and technical placeholders (`{count}`, `{time}`, `{weekday}`, `{version}`, `{seconds}`, `{email}`) stay bare. |

## What this audit could not determine

Nothing was left unresolved: all 46 keys carry a verdict and every finding carries a final French string ready to apply. Two limits worth stating plainly for C1:

1. `forwardLabel`'s only current call site is the component gallery (`gallery_screen.dart:358-359`), so "Suivant" was judged against the widget's paired back label rather than a shipping screen. If the arrow later lands in a real flow, re-check it there.
2. `dailyPrayerCoverage` and `partial` rest on composed/inferred renderings rather than a glossary lookup, by necessity (§6.4 and the glossary's silence on the adverbial form). Both decisions are recorded above with the precedent used, so a human reviewer can overturn them cheaply without re-deriving the reasoning.

**No files were modified** by the reviewing agent — no `.arb`, no generated Dart, nothing under `../translation/`.
