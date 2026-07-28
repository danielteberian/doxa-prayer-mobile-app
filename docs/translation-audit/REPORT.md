# Translation Audit Report

**Agent:** C1 `synthesis` (Phase 2)
**Inputs:** all seven Phase 1 findings files (`findings-{ar,es,fr,pt,ru,mechanical,vocabulary}.md`)
**Authority applied:** plan §2 — each language's translated glossary decides; the `.tsv` is subordinate; the `.arb` strings carry no authority; cross-language symmetry never outranks a language's own glossary.
**Glossaries re-read by C1 for arbitration:** `glossary.es_ES.md` §2 (lines 143–160), `glossary.ru_RU.md` §3 (lines 373–396), `glossary.ar.md` §2 (line 132). `../translation/` was not modified.
**Code re-verified by C1:** `lib/components/cards/engagement_item.dart:45-72`, `lib/components/buttons/arrow_button.dart:20-27`, `lib/screens/people_group_details_screen.dart:518-530`, and a codepoint dump of every affected string in all six `.arb` files.

**Totals after dedupe:** 6 Blocker findings (17 instances) · 8 Major (13 instances) · 21 Minor (58 instances) · 9 Note. 46 / 46 keys verdicted in all five languages — no gaps in the audit.

---

## Fragile-character notation — read before applying anything

Some final strings depend on characters that are visually identical to ASCII and were **already degraded once** by the Phase 1 persistence step (`findings-fr.md` now contains zero U+202F). This report therefore writes them as **explicit tokens**. D-agents must substitute the codepoint, never a literal space or a straight quote.

| Token | Codepoint | Name | Used by |
|---|---|---|---|
| `[NNBSP]` | **U+202F** | NARROW NO-BREAK SPACE | `fr` — before `; ? !`, and inside guillemets |
| `[NBSP]` | **U+00A0** | NO-BREAK SPACE | `fr` — before `:`, and between a number and its unit symbol |
| `[LDQ]` | **U+201C** | LEFT DOUBLE QUOTATION MARK | `pt` — opening name delimiter |
| `[RDQ]` | **U+201D** | RIGHT DOUBLE QUOTATION MARK | `pt` — closing name delimiter |

Guillemets are written literally as `«` **U+00AB** and `»` **U+00BB** — they are not confusable with ASCII. `ar`, `es` and `ru` use them with **no inner space**; `fr` uses them with `[NNBSP]` inside both. `pt` uses `[LDQ]`/`[RDQ]` with **no inner space** and **never** guillemets — the guillemet-vs-curly distinction is the substance of A4's decision (F-PT-08), because guillemets are the *European* Portuguese tradition and `app_pt.arb` targets pt-BR.

The `fr` apostrophe is **ASCII `'` U+0027** everywhere (see ruling R4). After this pass `app_fr.arb` must contain **zero U+2019**.

---

## 1. Blockers

### B-01 · `enableNotificationsButton` and `enableNotificationsPromptBody` absent from all five locales
**Instances:** 10 (2 keys × 5 languages). Reported by all seven agents (F-AR-01/02, F-ES-01/02, F-FR-01/02, F-PT-01/02, F-RU-01/02, F-MECH-01).
B1 proved the list **exhaustive** by set difference: these are the only two keys in `app_en.arb` missing from any locale file. Both fall back to English at `lib/components/notifications/enable_notifications_prompt.dart:83` (body paragraph) and `:89` (full-width button).

Cross-language check on the ten new strings — **all consistent**:
- Every `enableNotificationsButton` reuses its file's approved `enableNotifications` string **verbatim** (C1 verified all five). The two keys carry identical English, so they must carry identical translations.
- Every `enableNotificationsPromptBody` uses B2's canonical *push notifications* form (table 1A row 14), its file's settled word for *updates/news*, and carries the English "also". No language collapsed or dropped it.

### B-02 · `ru` `dailyPrayerCoverage` uses the wrong head noun
**Instances:** 1. F-RU-03 (Blocker) + F-VOCAB-01 (Blocker) — independently concurring.
`Ежедневное молитвенное покрытие` → **`Ежедневный молитвенный охват`**.
C1 verified `glossary.ru_RU.md:378` («24-часовой молитвенный охват»), `:388` (the explicit warning against reading *охват* as insurance or legal), and `:838` (§9 label table, same term). `ru.tsv:40`'s «покрытие» is the derived index and loses under §2.2. It loses on merits too: *страховое покрытие* is standard Russian for insurance cover, *покрытие сети* for network coverage, and *молитвенное покрытие* is an established Russian evangelical idiom for **spiritual covering over an individual** — a different doctrine from "144 intercessors so the day is prayed through without a gap". Under a progress bar counting intercessors that reading makes the metric incoherent, which is exactly §5.5's Blocker test ("a glossaried ministry term rendered so as to change what Doxa is claiming").
**The adjective ending changes with the head noun:** `охват` is masculine, so `Ежедневное` → `Ежедневный`. Word order mirrors the glossary's own modifier + `молитвенный` + head.

### B-03 · `fr` `nRemindersSet` renders a stray `s` at every count ≥ 2 *(out-of-scope key — authorised, see §6)*
**Instances:** 1. F-MECH-03 (Blocker, simulated) + F-FR-12 (concurring).
`other{{count}s rappels définis}` puts the `s` outside the ICU token, so it is literal text: count 2 → `2s rappels définis`, count 20 → `20s rappels définis`. Home-screen next-reminder card (`lib/components/cards/reminders_summary.dart:23`) — high visibility. Sibling `nPeopleGroups` is clean, confirming this is a leftover, not a unit suffix.

### B-04 · `ru` `nPeopleGroups` and `nRemindersSet` print a literal `1` at 21/31/41/101 *(out-of-scope keys — authorised, see §6)*
**Instances:** 2. F-MECH-02 (Blocker), proven by re-implementing `Intl.pluralLogic` from `intl-0.20.2` plus the CLDR rules.
Root cause: `gen-l10n` does not compile `=1` to an exact-value match — it emits the branch as the `one:` argument of `Intl.pluralLogic` (`lib/l10n/app_localizations_ru.dart:24-33`, `:326-338`). `pluralLogic` shortcuts only `howMany == 1`; every other count consults Russian's CLDR `ONE` rule `n % 10 == 1 && n % 100 != 11`. So **21, 31, 41, 51, 101 … all return the hardcoded `=1` string.** Separately, count 2 and 3 render `2 народов` where Russian needs `2 народа` (the `few` paradigm).
The people-group search screen shows an unfiltered IMB list far larger than 21, so a Russian user hits this routinely (`lib/components/widgets/people_groups_list.dart:137`).
**Noun forms accepted.** `народ` / `народа` / `народов` and `напоминание` / `напоминания` / `напоминаний` are the standard Russian paradigm; C1 finds no reason to reject them, and the genitive plural `народов` is already attested in the file's own `=0{Нет народов}`. `=0` stays — Russian has no CLDR `zero` category, so that branch fires only at an exact 0.
Same-class sweep by B1: `es`, `pt`, `fr`, `en` are correct at all integer inputs. No further instances.

### B-05 · `ar` `nextReminderToday` / `nextReminderTomorrow` / `nextReminderOn` render "at {time}" as "on the website" / "on the link" *(out-of-scope keys — authorised, see §6)*
**Instances:** 3. F-AR-13 item 1 ("the most serious defect I saw in the file, and it is user-facing on the home card") + B1's referral.
Current: `اليوم على موقع {time}` = "today **on the site** {time}"; `غدًا على موقع {time}`; `{weekday} على الرابط {time}` = "**on the link** {time}". `على موقع` / `على الرابط` are machine-translation artefacts for a *time* preposition. Wrong meaning on the home card in the app's highest-traffic slot.

### B-06 · `ar` brand defects: the app's own name is translated, and the app is called a book *(out-of-scope keys — authorised, see §6)*
**Instances:** 3. F-MECH-06 (Major) + F-AR-13 item 3/4 + F-VOCAB-09.
- `appName` = `صلاة دوكسا` — **both transliterated and translated**, meaning "prayer of Doxa". Every other locale carries `Doxa Prayer` verbatim.
- `reminderNotificationBody` = `افتح كتاب «دوكسا» لبدء صلاة اليوم.` — tells the user to open **the book** Doxa. The app is not a book, and English is `Open Doxa to start today's prayer.`
- `wizardWelcomeBody` transliterates `«دوكسا»`.
Raised to Blocker (B1 filed Major): `appName` misstates what the product is called, `reminderNotificationBody` misstates what it is, and plan §5.2.8 requires `Doxa` untranslated and unscripted in Arabic. The same Arabic user sees Latin `Doxa` in 10 strings and `دوكسا` in these three within one session; `shareMessage` in the *same file* already writes `«Doxa Prayer»`.

---

## 2. Terminology corrections

### T-01 · `ar` `engaged` fails gender agreement — `مُنخرَط` → `مُنخرَطة` · Major
**Instances:** 1. F-AR-03 + F-VOCAB-03 (independently concurring).
The **lexeme is correct** and must not move: `glossary.ar.md:132` heads §2 «الانخراط / المجموعة الشعبية المنخرطة», and §2 explicitly warns against `مشاركة`/`اتصال`/`التزام` — which the Arabic avoids. What is wrong is the **inflection**. The chip is a bare marker caption (`lib/screens/people_group_details_screen.dart:162-166`) whose only possible referent is `المجموعة الشعبية` — feminine, as the app's own `peopleGroup` = «مجموعة شعبية» and `engagementStatus` = «حالة الانخراط» confirm. The feminine vocalised form is directly attested in `ar.tsv:6` («جماعات عرقية غير مُنخرَطة»). Masculine `مُنخرَط` reads as describing a male person.
*Noted by B2:* `glossary.ar.md` §6 once writes «منخرطاً معها» (masculine) of a feminine noun. §2's heading is the clean form and is what this ruling cites.

### T-02 · `ar` exact-alarms cluster: `التنبيهات` → `المنبّهات` · Major
**Instances:** 3 keys. F-AR-05 (Minor) + F-VOCAB-02 (Major) — **confirmed, at Major.**
`تنبيه` means *alert/notice*. The app already spends `الإشعارات` on **notifications** and shows a notifications-permission page immediately adjacent, so `التنبيهات` is a third word that maps to neither screen. `allowExactAlarms` is the button that opens Android's **Alarms & reminders** special-app-access screen — `المنبّهات والتذكيرات` in Arabic — so the noun must be the one printed there or the instruction is unfollowable. A user told `التنبيهات الدقيقة غير مسموح بها` will hunt in notification settings, which is the wrong screen. `المنبّهات` also restores the `المنبّهات`/`التذكيرات` pairing the system screen name uses.
Severity taken from B2 (Major) rather than A1 (Minor): B2's deliverable binds cluster vocabulary, and unfollowable wayfinding on a permission instruction is a defect a user notices, not polish. All three strings move together; nothing else in them changes (`تذكيرات` stays the single noun for *reminder*, Latin `Doxa` stays).

### T-03 · `prayerReminderTitle` weakens the daily commitment in **all five languages** · Major
**Instances:** 5. F-AR-04 (Major), F-ES-07 (Minor), F-FR-03 (Major), F-PT-04 (Minor), F-RU-06 (Minor) — five independent reviewers, five independent glossary citations, one shared diagnosis. **This is the audit's strongest cross-language result.**
English asks about the user's readiness for the prayer they have committed to make *each day*. All five translations softened it into "do you feel like praying at some point today?", which is precisely what §4.1 forbids for this key, and each collided with its file's own `reminderNotificationTitle`. Every language's fix reuses the definite noun phrase its own `reminderNotificationBody` already uses for the same English — so banner and notification stop sounding like two products:

| Lang | Current | Final | Glossary section cited |
|---|---|---|---|
| `ar` | `حان وقت الصلاة اليوم؟` | `هل أنت مستعد لصلاة اليوم؟` | ar §3 «الصلاة اليومية ★» |
| `es` | `¿Todo listo para orar hoy?` | `¿Todo listo para la oración de hoy?` | es_ES §3 «Oración diaria ★» |
| `fr` | `C'est le moment de prier aujourd'hui ?` | `Prêt pour la prière d'aujourd'hui[NNBSP]?` | fr_FR §3 «Prière quotidienne ★» |
| `pt` | `Tudo pronto para orar hoje?` | `Tudo pronto para a oração de hoje?` | pt_PT §3 «Oração diária ★» |
| `ru` | `Готовы помолиться сегодня?` | `Готовы к сегодняшней молитве?` | ru_RU §3 «Ежедневная молитва ★» |

Two deliberate retentions, recorded so no D-agent "simplifies" them: `es`/`pt` keep `¿Todo listo` / `Tudo pronto` because it makes *todo* the subject and stays gender-neutral for an unknown user (`¿Listo?`/`Pronto?` would gender the reader masculine). `ar` gains the required interrogative particle `هل` — the current string is a declarative with a question mark bolted on. `fr` uses the file's established masculine default (`Tenez-moi informé`, `Restez informé`).

### T-04 · `ru` `prayForPeopleGroupLabel` / `prayerReminderBody` drop the ★ head noun · Minor
**Instances:** 2. F-RU-04, F-RU-05.
Case government is sound either way — «за» takes the accusative and the guillemeted insert is grammatically inert. The defect is the **missing head noun**: the file's two comparable approved strings both name it (`peopleGroupIntroTitle` «Помолитесь за народ «{name}»», `switchPeopleGroupConfirm` «за народ «{currentName}»»), and `prayForPeopleGroupLabel` is a TalkBack label where guillemets are **not spoken** — so the user hears bare «Помолиться за Кырк», an IMB name with nothing marking it as a people group, easily heard as a person's name. Adding «народ» restores `glossary.ru_RU.md` §1's ★ unit and gives the preposition a real head.

### T-05 · `ar` `feedbackTypeCompliment`: `إطراء` → `إشادة` · Minor
**Instances:** 1. F-AR-06 + F-VOCAB-04 (concurring). `إطراء` carries *flattery / insincere praise*, so the chip invites the user to classify their own message as flattery, while the two sibling chips (`اقتراح`, `مشكلة`) are flatly neutral. `إشادة` is the neutral *commendation* and is the standard third member of the Arabic feedback triad `مشكلة · اقتراح · إشادة`.

### T-06 · Terminology **confirmed correct** — no change, do not "fix"

| Item | Ruling | Basis |
|---|---|---|
| `es` `engaged` = **`Comprometido`** | **CORRECT. §6.5's suspicion is REFUTED.** | C1 read `glossary.es_ES.md:147` directly: §2 is headed *"Compromiso / comprometido (grupo de personas)"*, and lines 156–159 warn against **«participación»** and **«contacto»** — *not* «compromiso». §1 renders the whole family *no comprometido / poco comprometido / subcomprometido*; `es.tsv:14` agrees. Changing it would break `engagementStatus` ("Estado del compromiso"), `peopleCommittedToPraying`, and the public site. Agreement is right: `grupo` is masculine singular. (F-ES-09, F-VOCAB-05.) |
| `fr` `Engagé` · `pt` `Engajado` · `ru` `Вовлечён` | Correct, unchanged | Each is its own glossary's §2 heading form, masculine singular agreeing with `peuple` / `povo` / `народ`. `ru` keeps the **short predicative** form: as a bare caption a long-form adjective strands itself, and the sibling caption «Межкультурные служители присутствуют» is likewise predicative. |
| `dailyPrayerCoverage` in `ar`, `es`, `fr`, `pt` | **Keep all four.** | Each language's own glossary §3 **chose** `تغطية` / `cobertura` / `couverture` / `cobertura` *and then wrote the insurance warning underneath it* — native reviewers weighed the polysemy and told translators to keep it from drifting. The warning constrains the *reading*, it does not ban the word. Each string composes the two glossaried halves with the ★ *daily prayer* term intact and contiguous. Confirmed independently by A1, A2, A3, A4 and B2, each citing its own §3. Russian is the sole exception, and it is not a calque problem — it is the wrong head noun (B-02). |
| `signUp` and the `newsSignupSuccess*` family, all five | Correct | The glossaried form is used in all five (`التسجيل`, `Registrarse`, `S'inscrire`, `Inscrever-se`, `Зарегистрироваться`), with the file's button inflection. B2 Deliverable 4 row 9. `ar` is the one place a reviewer preferred the `.tsv` masdar over the glossary's imperative CTA voice — recorded and accepted, because the imperative there is the *website's* voice and this app's buttons are uniformly masdar. |
| `es`, `fr`, `pt`, `ru` exact-alarms terminology | **Keep the descriptive term.** | Four reviewers independently declined to adopt Android's screen title (*Alarmas y recordatorios* / *Alarmes et rappels* / *Alarmes e lembretes* / *Будильники и напоминания*) for the same reason: it collides with the app's own word for **reminders**, which would make one word mean two things on one screen, and it drops "exact", which is load-bearing in the two body strings. `ar` is different only because `التنبيهات` matches *neither* screen. |
| `partial`, all five, on the **agreement** question | **§6.7 refuted. No change for agreement.** | C1 verified `engagement_item.dart:50-69`: the status word is the `label` of its **own isolated `Semantics` node**, deliberately split from the caption — the code comment records that a bare "No" at the tail of a longer phrase was read by TTS as "№". It is never uttered adjacent to a noun, and the markers it can describe have mismatched genders anyway, so no fixed agreement target exists. (F-VOCAB-06, plus A1/A2/A4/A5 concurring.) One French wording change survives for a different reason — see P-02. |
| `forwardLabel`, all five | **§6.8 refuted. No change.** | C1 verified `arrow_button.dart:25-27`: the back arrow's label comes from **Flutter's own** `MaterialLocalizations.backButtonTooltip`, not from the `.arb`. So `التالي` / `Adelante` / `Suivant` / `Avançar` / `Вперёд` each pair with `رجوع` / `Atrás` / `Retour` / `Voltar` / `Назад` — the canonical arrow pair in each language. A literal *forward* (`إلى الأمام`, `Para frente`) would be worse as speech. Must **not** be aligned to `back`, `nextDay` or `continueLabel`. |
| B2's canonical grid (17 terms × 5 languages) | **Ratified in full; only two cells differed from the files and both are Arabic** (T-02, T-05). | No reviewer contradicted a canonical cell. Three apparent conflicts were checked and are not conflicts — see the arbitration table in §5. |

---

## 3. Polish

### P-01 · Placeholder-guillemet convention (§6.6) · Minor — never lets this displace a Blocker
One finding, **19 instances across 5 languages**. Every language applies **its own** convention uniformly to every name-like placeholder; numeric and technical placeholders (`{count}`, `{time}`, `{weekday}`, `{version}`, `{seconds}`, `{email}`) stay bare everywhere. Purely typographic — the ICU tokens are untouched, so substitution is unaffected, and screen readers do not speak the delimiters.

| Lang | Convention | Keys to fix | Count |
|---|---|---|---|
| `ar` | `«{x}»` U+00AB/U+00BB, no inner space | `switchPeopleGroupConfirm` (both names bare) | 1 |
| `es` | `«{x}»`, no inner space | `prayForPeopleGroupLabel`, `prayerReminderBody`, `scanToPray`, `switchPeopleGroupConfirm` | 4 |
| `fr` | `« {x} »` with **`[NNBSP]` inside both** | all seven eligible keys | 7 |
| `pt` | `[LDQ]{x}[RDQ]` U+201C/U+201D, no inner space | all seven eligible keys | 7 |
| `ru` | `«{x}»`, no inner space | `scanToPray` | 1 |

Three sub-rulings:
1. **`pt` picks curly quotes, not guillemets** — `app_pt.arb` had no convention at all, and A4 established from `glossary.pt_PT.md`'s own front matter (`language: Portuguese (Brazil-leaning)`) and its Brazilian §9 UI labels that the target is **pt-BR**. Guillemets are the European tradition and would contradict the variant. Portuguese, unlike French, uses no inner space. Question marks and sentence periods stay **outside** the closing quote.
2. **A11y-only labels are NOT exempted.** A4 raised the option (F-PT-08) since TalkBack does not speak quotation marks. Ruled: apply uniformly. §6.6 says "every name-like placeholder in its file"; a uniform rule is cheaper to verify in Phase 4 than an exemption list, and applying it costs nothing.
3. **`fr` necessarily drops the elided article.** `peopleGroupIntroTitle`, `scanToPray` and `shareMessage` currently glue an elided article to the placeholder (`l'{name}`). That is not merely inconsistent — it is **ungrammatical for any people-group name beginning with a consonant** ("l'Peul", "l'Kurde"), and `l'« {name} »` is not legal French. `Priez pour « Peul »` is correct for every name; the guillemets do the work the article was attempting. (F-FR-11.)

### P-02 · `fr` `partial`: `Partiel` → `En partie` · Minor
**One instance. This is the single place C1 departs from B2's table — see arbitration A-07.** Spoken alone, `Partiel` is ambiguous in French: as a bare noun *un partiel* is a mid-term exam, and as an adjective it wants a noun that a standalone announcement does not supply. `En partie` is invariable, cannot be misheard as a noun, and sits in the same register as `Oui`/`Non` — the words the user hears from the sibling markers. Never seen, only spoken, so no slot risk.

### P-03 · `fr` French punctuation and unit spacing · Minor
**7 instances.** F-FR-07 + F-FR-08 + F-MECH-09 — A3 and B1 agree on all of these; they differ only on `shareMessage`'s colon (ruling R3).
B1 computed the file's convention: `?`+U+202F ×3 and `;`+U+202F ×2 in approved strings, versus `?`+ASCII ×2, `!`+ASCII ×2, `;`+ASCII ×1 — **and all five ASCII cases are new keys.** So this is a regression against the file's own settled typography, not a pre-existing inconsistency. Beyond consistency it is a rendering defect: a breaking space lets Flutter wrap the line with the `!`, `?` or `;` orphaned at the start of the next line.
`exactAlarmsDisabledStatus`, `feedbackSuccessTitle`, `feedbackTypeLabel`, `newsSignupSuccessTitle`, `prayerReminderTitle` → `[NNBSP]` before the punctuation mark; `resendVerificationCooldown`, `resendVerificationCountdown` → `[NBSP]` between `{seconds}` and the unit `s` (French never separates a number from its unit symbol, and the countdown is a wrapping button label — exactly where "12" / "s" would split).

### P-04 · Tense, register and naturalness · Minor
**13 instances**, all with the reviewer's own in-file precedent cited:

| Lang | Key | Change | Finding |
|---|---|---|---|
| `es` | `resendVerificationFailed` | preterite → compound perfect, matching the file's pattern for a just-failed action | F-ES-04 |
| `es` | `feedbackSuccessBody` | `se enviaron como` → `se han enviado desde`; add the demonstrative `esa` | F-ES-05 |
| `es` | `exactAlarmsDisabledStatus` | impersonal passive → Doxa as the subject lacking the permission, matching `exactAlarmsPromptBody`'s active framing | F-ES-06 |
| `fr` | `feedbackSubmit` | `les commentaires` → `des commentaires` (partitive; also Google's own French for this exact button) | F-FR-10 |
| `fr` | `prayerReminderBody` | `Touchez` → `Appuyez ici` — the file's one verb for *tap*, and it separates the repeated `pour` | F-FR-05 |
| `pt` | `feedbackIntro` | restore the subject pronoun `você`, per the file's pt-BR practice | F-PT-05 |
| `pt` | `feedbackSuccessBody` | add `esse`; drop the correto/certo synonym swap | F-PT-06 |
| `pt` | `resendVerificationSent` | `Verifique` → `Confira` — removes the *verificação…Verifique* echo and the "verify your inbox" misreading | F-PT-07 |
| `ar` | `resendVerificationSent` | `تحقق من` → `تفقَّد` — same collision, same fix | F-AR-07 |
| `ar` | `resendVerificationFailed` | restore the dropped "Please" (`يرجى`), matching the three sibling error strings | F-AR-08 |
| `ar` | `feedbackIntro` | `نسمع رأيك` → `نسمع منك` — English says "hear *from you*", and `رأيك` was said twice | F-AR-09 |
| `ar` | `feedbackSuccessBody` | `باسم {email}` ("in the name of") → `من العنوان {email}` | F-AR-10 |
| `ru` | `resendVerification` | `Отправить письмо для подтверждения ещё раз` → `Отправить письмо повторно` | F-RU-08 |

### P-05 · Precision where the English is loose · Major (`es`) / Minor (`ru`)
**2 instances.** `emailsLoadError` — English "your emails" means email **addresses** (`account_settings_section.dart:78-99`, `List<SignedUpEmail>`), not messages.
- `es` `tus correos` reads as *your email messages*, so a Spanish user in a settings screen headed "Tu cuenta" is told the app could not load their inbox — which the app never touches. **Major** (F-ES-03).
- `ru` `ваши адреса` reads most naturally as **postal** addresses, with nothing to disambiguate. **Minor** (F-RU-07).
`ar` (`عناوين بريدك الإلكتروني`), `fr` (`vos e-mails`) and `pt` (`seus e-mails`) were judged fine by their reviewers. The underlying English imprecision is escalated in §8.

### P-06 · Consent voice · Major (`pt`) / Minor (`ru`)
**2 instances, and an accepted strategy divergence.** `feedbackConsentLabel` is a §4.1 key requiring unambiguous consent language.
- `pt` `Mantenha-me atualizado com as novidades da Doxa` → **`Quero receber novidades da Doxa`**. F-PT-03, **Major**. It is a `CheckboxField` — the *same widget* as the approved `updatesFromDoxa` and `updatesAboutMyPeopleGroup`, which use a non-imperative consent voice. An imperative reflexive reads as an instruction addressed to the app rather than a declaration by the user, and two identical widgets expressing consent in two grammatical voices is the register clash. It also removes the gendered `atualizado`, which mis-genders every female user.
- `ru` `Держите меня в курсе новостей от Doxa` → **`Хочу получать новости от Doxa`**. F-RU-09, Minor. Ticking a box that issues an instruction is not the same speech act as granting permission; `Хочу получать` is the standard Russian opt-in formula and reuses the approved `updatesFromDoxa`'s «новости от Doxa».

**Ruled: do not harmonise `ar`, `es`, `fr` toward the first-person form.** See arbitration A-08.

---

## 4. Mechanical

| # | Item | Scope | Action |
|---|---|---|---|
| M-01 | **21 `@key` blocks missing per locale** — the 19 of §6.2 plus the 2 new keys. F-MECH-05: **confirmed at exactly 19, identical set in all five files** (symmetric difference empty between every pair); no *older* key is affected; `app_en.arb` is complete at 170/170. **105 blocks across the five files.** | all 5 | Each D-agent adds all 21, copying `description` **and any `placeholders` sub-object** (`feedbackSuccessBody` → `email`, `prayerReminderBody` → `peopleGroup`) from the **live** `app_en.arb`. |
| M-02 | **`@feedback` description stale in all five locales.** All five still say *"Button that opens the feedback page in the browser"*; English says *"Button that opens the in-app feedback panel"* — the behaviour genuinely changed in `f48ad3a`. Weblate shows the *locale* file's description to the translator, so a translator is currently told the button opens a browser page it no longer opens. F-MECH-13 + F-FR-13 + F-RU-14. | all 5 | Replace in all five. Authorised (§6). |
| M-03 | **`ar` / `ru` `appVersion` missing the space before `{version}`** — renders `Версия1.15.0` and `الإصدار1.15.0`. F-MECH-08 + F-RU-11. Only two instances in the whole sweep. | ar, ru | Authorised (§6). |
| M-04 | `ar` `nPeopleGroups` / `nRemindersSet` lack `two` and `few` — wrong at count 2 (dual) and 3–10 (broken plural). F-MECH-04. | ar | **NOT applied this pass** — the Arabic morphology is not in any findings file. See §6 and §10. |
| M-05 | **No dead keys anywhere.** `newsSignupThanks` and `prayerCoverage24h` were removed from `app_en.arb` *and* all five locale files, strings and `@` blocks alike. Every locale key set is a strict subset of English's, short by exactly the two keys in B-01. F-MECH-14. | all | **D1–D5 add and never remove.** Once B-01 lands, key-set parity is achieved with zero deletions. |
| M-06 | All 46 new keys are **referenced from `lib/`** — zero dead weight — and every `l10n.<key>` reference in `lib/` resolves to a key in `app_en.arb`, so zero build breaks. F-MECH-15. | — | No action. |
| M-07 | JSON validity, no BOM, no CRLF, no tabs, no duplicate top-level keys, no empty values: **clean in all six files.** Placeholder *name-set* integrity: **clean in all six files** (zero mismatches). | all | No action; re-verify in Phase 4. |
| M-08 | **B1's quoted `@enableNotificationsButton` description is stale.** B1 wrote *"Button that asks the OS for notification permission"*; the live text is *"Button that requests OS notification permission so the user can receive push notifications"*. B1 warned about exactly this. | all 5 | D-agents read descriptions from the **live** `app_en.arb`, never from a report quote. |
| M-09 | Two `@` blocks differ from English only in **key ordering inside `placeholders`** (`@nextReminderOn`, `@nRemindersSet`), content identical. Per §6.3 ordering is out of scope. | all 5 | **Not drift. No action** — recorded so no D-agent "fixes" it. |
| M-10 | No `@@locale` in any of the six files; `app_en.arb` has no trailing newline. F-MECH-16/17. | — | **No action** — both would touch `app_en.arb`. Flagged so nobody perturbs five files D1–D5 are concurrently writing. |
| M-11 | **Slot lengths.** Ten constrained-slot strings exceed 1.6× English (worst: `ru` `signUp` 2.57×, `fr` `notNow` 2.00×). B1 established that `lib/` contains **zero** occurrences of `maxLines: 1`, `softWrap: false`, `TextOverflow.ellipsis` or `TextOverflow.clip`, so nothing can be truncated — worst case is an extra line — and `ButtonBarWrap` measures both labels with a `TextPainter` at the live `textScaler` and stacks them full width when the pair will not fit (the `344ff12` fix). F-MECH-12. | — | **No action.** Two of the ten shorten as a side effect of accepted findings (`ru` `resendVerification` 1.68× → 25 chars; `fr` `feedbackSubmit` unchanged in length). |

---

## 5. Plan corrections

The plan was right about most things and wrong about five. All five corrections are carried into the change sets.

| § | The plan said | Correction | Evidence |
|---|---|---|---|
| **§6.5** | `es` "Comprometido" (*committed*) "is the likeliest defect, since the English glossary explicitly warns against rendering the missions term as generic involvement or commitment." | **REFUTED for Spanish.** `glossary.es_ES.md:147` heads §2 *"Compromiso / comprometido (grupo de personas)"* — the precision term **is** *compromiso* — and its warning list at lines 156–159 is **«participación»** and **«contacto»**, not «compromiso». §2 authority order puts the *Spanish* glossary above the English one for word choice. `Comprometido` **stays.** The plan reasoned from `glossary.md` (English), which §2.3 says to use for *meaning*, not to pick words. | C1 read the section; A2 (F-ES-09) and B2 (F-VOCAB-05) reached it independently. |
| **§6.6** table | `ru`: "guillemets throughout — new keys already consistent." | **WRONG for `ru`.** True of the new keys, false of the file: `scanToPray` is the one name-like placeholder in `app_ru.arb` left bare. Every other one is guillemeted. **D5 must not skip `scanToPray`.** | F-RU-10; C1 verified the string. |
| **§6.6** table | `ar`: "guillemets throughout — new keys already consistent." | **WRONG for `ar`.** Six of the seven eligible keys carry `«…»`; `switchPeopleGroupConfirm` has **both** name placeholders bare, with two people-group names running unquoted into surrounding Arabic prose. **D1 must not skip it.** | F-AR-12; C1 verified the string. |
| **§6.7** | `partial` — adverb vs adjective, "unconfirmed"; `ru` "Частично" may be wrong because the Romance locales use adjectives. | **REFUTED in every language, on code evidence. Resolved — no action.** `engagement_item.dart:50-69` utters the status as an **isolated `Semantics` node**, deliberately split from the caption; the code comment records the TTS bug ("№") that forced the split. There is nothing to agree with, and the markers it can describe have mismatched genders anyway. `ru`'s adverb is arguably the best of the five, since `yes`/`no` are likewise bare invariable tokens. | C1 read the code; F-VOCAB-06, F-AR-13, F-ES notes, F-PT-17, F-RU answers. |
| **§6.8** | `forwardLabel` "renders as *next*", unconfirmed; check against the paired back control. | **REFUTED in every language, on code evidence. Resolved — no action.** `arrow_button.dart:25-27` pairs it with **Flutter's own** `MaterialLocalizations.backButtonTooltip`, not with any `.arb` key. Every current label is the canonical counterpart of its language's platform back label. | C1 read the code; F-AR-13, F-ES coherence note, F-FR contract note, F-PT-18, F-RU answers. |

**§6.1, §6.2, §6.3, §6.4 all stand as written**, each independently confirmed (§6.1 exhaustive; §6.2 exactly 19; §6.4 confirmed mechanically — old key gone from all six files, new key present and reachable in all six).

### Arbitration log — every live conflict, ruled

| # | Conflict | Ruling | Reason |
|---|---|---|---|
| **A-01** | `engaged`: is Spanish wrong? | **No — `Comprometido` is correct in all senses; §6.5 refuted.** All five languages keep their own glossary's engagement-family root: `مُنخرَطة` (root `انخراط`), `Comprometido` (root `compromiso`), `Engagé`, `Engajado`, `Вовлечён`. | Cross-language pass result: **no language diverges in *strategy*.** Every one uses its glossary's precision term; none uses a general-purpose word. Divergence in *surface cognate* is not divergence in strategy, and §2 forbids harmonising a language away from its own glossary. Only `ar`'s inflection changes (T-01). |
| **A-02** | `dailyPrayerCoverage`: harmonise or split? | **`ru` → `Ежедневный молитвенный охват` (Blocker). `ar`/`es`/`fr`/`pt` keep.** Adjective ending changes with the masculine `охват`. | Four reviewers each cited their own §3 sanctioning the coverage word *with the insurance warning attached*; `ru`'s §3 chose a **different head noun** and its `.tsv` disagrees. The asymmetry is glossary-driven, which is exactly what §2 requires. **Confirmed as briefed.** |
| **A-03** | `fr` `shareMessage` colon: A3 says keep U+00A0; B1 says normalise to U+202F. **Genuine conflict.** | **A3 WINS. Keep `[NBSP]` U+00A0 before the final `:`.** B1's F-MECH-09 row for `shareMessage` is **overruled**; its other five rows stand. | §8.3: the language-specific argument wins. It is also the stronger argument on the facts: French takes the *full* no-break space before a colon and the narrow one before `; ? !`, and C1's codepoint dump confirms `shareMessage` is the **only** approved string in the file with a colon needing a space — so there is no in-file precedent for U+202F before `:` to be consistent with. The file's U+202F cases are all `; ? !`. Current state is already correct. |
| **A-04** | `fr` apostrophe: ASCII `'` or typographic `’`? | **ASCII `'` U+0027 is the house convention** (27 vs 3). **And A3's F-FR-11 makes it fully moot:** both `’` live in `peopleGroupIntroTitle` and `shareMessage`; the guillemet change deletes the elided article from the first (no apostrophe survives) and A3's own final string for the second spells `l'application` with ASCII. Applying the change sets leaves **zero U+2019** in `app_fr.arb`. No separate F-MECH-10 action. | F-MECH-10 asked for one ruling instead of five; B1 itself noted the mooting. Mixing was the defect, and it disappears. |
| **A-05** | `ar` exact alarms: `التنبيهات` → `المنبّهات`? | **Confirmed, all three keys, at Major.** | A1 and B2 concur on the string; severity taken from B2 because its deliverable binds cluster vocabulary and unfollowable OS wayfinding is not polish. See T-02. |
| **A-06** | `ar` `resendVerification{Cooldown,Countdown}`: B1 offers abbreviate-vs-pluralise; A1 proposes ICU plurals with a flat fallback. | **Route 2 — ICU Arabic plurals, using A1's exact strings.** Route 1 (abbreviate to `ث`) rejected. | A1 supplied **complete, correct CLDR-category strings including the dual `ثانيتين` and the 3–10 plural `ثوانٍ`** — so unlike M-04, there is no morphology gap. The counter demonstrably ticks 60 → 0 once a second (`signed_up_email_tile.dart:28,41-53,73`), so every value 1–60 renders, including the dual and broken-plural ranges; `5 ثانية` is ungrammatical. `@resendVerification{Cooldown,Countdown}` already declare `seconds` as `int`, and `gen-l10n` permits English being the only flat locale. Route 1 is rejected because abbreviating a unit is not this file's convention anywhere, and the cooldown string is a **SnackBar sentence** where an abbreviation reads worse than in a button. B1's length concern was its own Note, downgraded after it established there is no `maxLines: 1` in `lib/`. A1's flat fallback is therefore **not** taken. |
| **A-07** | `fr` `partial`: B2 says no change in any language (strength *strong*); A3 proposes `En partie`. | **A3 wins, at Minor. This is the one departure from B2's table.** | B2's ruling is grounded, by its own words, in the **render site** — it decides that *no agreement target exists*, and it is upheld on exactly that (§6.7 refuted, all five). A3 agrees there is no agreement problem and cites `glossary.fr_FR.md` §1 only to confirm neither reading is at risk. A3's argument is **orthogonal**: French homonymy in a spoken-only string (*un partiel* = a mid-term exam), plus register parity with the `Oui`/`Non` answer-word set. B2 gave French one line ("unmarked masculine, the default") and did not consider the homonym. Where B2's stated basis does not reach the reviewer's argument, B2 does not bind. The change also aligns French with the answer-word register B2 itself called "arguably the best of the five" in Russian. Minor and cheaply reversible. |
| **A-08** | `feedbackConsentLabel`: `pt`/`ru` move to first-person declarative; `ar`/`es`/`fr` keep imperative-with-clitic. Strategy divergence on a §4.1 key. | **Accept the split. Do not harmonise `ar`/`es`/`fr`.** | Both changes rest on precedent *specific to their own language*: `pt` on the two approved sibling `CheckboxField` labels in the same widget family, plus a real gender defect (`atualizado` mis-genders every female user); `ru` on «Держите меня в курсе» being a calque and «Хочу получать» being the standard Russian opt-in. Meanwhile the English source is *itself* imperative-with-clitic, so `ar`/`es`/`fr` faithfulness is a legitimate strategy, and each reviewer affirmatively judged its string unambiguous as consent, with `es`'s `al día` invariable and `fr` using the file's established masculine default. §2 forbids reasoning "the other locales say X, so X is right." Recorded as an **accepted divergence, not a defect**. |
| **A-09** | `ru` `resendVerification`: B2 conditioned the shortening on "if B1 confirms overflow"; B1 explicitly did **not** ("No action proposed"). | **Apply A5's `Отправить письмо повторно` anyway, at Minor.** | A5's basis is not length. It is C5 naturalness — the discontinuous «Отправить … ещё раз» wrapped around a four-word noun phrase is clumsy as a button — plus anaphoric coherence with `resendVerificationCountdown` «Повторить через {seconds} с», which already carries the *повтор-* root. The cluster noun `письмо` is retained and «письмо для подтверждения» is still spelled out in `resendVerificationSent` and `newsSignupSuccessBody`. B2 marked its own row *yieldable*/Note. Dropping from 42 to 25 chars is a bonus, not the reason. |
| **A-10** | `pt` `resendVerificationSent` `Verifique` → `Confira`, and `ar` `تحقق من` → `تفقَّد`: do these break B2's row 5 (*to verify*)? | **No conflict. Both apply.** | B2 row 5 governs the verb for **verifying an address**. These strings change the verb for **checking a mailbox** — a different act that happens to share a root in both languages, producing an echo two words apart and inviting the misreading "verify your inbox". The cluster noun (`e-mail de verificação` / `رسالة التحقق`) is untouched in both. |
| **A-11** | `pt` exact alarms (F-PT-20) and `ru` exact alarms — should the cluster track the Android *settings screen title* across all five languages? | **No. Keep the descriptive term in `es`/`fr`/`pt`/`ru`.** | Four reviewers reached the same conclusion independently and for the same reason: the screen title's noun collides with the app's own word for **reminders**, and it drops "exact", which is load-bearing in the two body strings. A4's recommendation ("I do not recommend it") is accepted. `ar` is not an exception to this rule — `التنبيهات` is being changed because it matches *neither* screen, not to match the screen title. |
| **A-12** | `pt` variant: does `glossary.pt_PT.md`'s filename mandate European Portuguese? | **No — the target is pt-BR.** | The glossary declares it: front matter line 5 `language: Portuguese (Brazil-leaning)`, its `note` block, and its own Brazilian §9 UI labels ("Inscreva-se", "Entre em contato"). `app_pt.arb` is internally consistent on every diagnostic form. **Nothing in `app_pt.arb` is to be "corrected" toward European Portuguese**, and this is what settles P-01's curly-quote choice. |
| **A-13** | `pt` `Doxa` article gender: `o Doxa` in some strings, `a Doxa` in others. | **Systematic and correct — keep both. D4 must not harmonise them.** | `o Doxa` = the app (ellipsis of *o aplicativo Doxa*), used where Doxa holds a permission or is opened. `a Doxa` = the ministry, used where Doxa sends news — which is the glossary's own gender ("A DOXA", "da DOXA" throughout §2/§4/§5/§7). Every in-scope key obeys the rule. |
| **A-14** | `.tsv` ↔ glossary disagreements on core ★ terms (`people group` in ar/es/pt/ru; `24-hour prayer coverage` in ru/es). | **Glossary wins in every case; the app already complies in every case except the `ru` coverage head noun (B-02).** Notes only — `../translation/` is read-only. | Recorded so no D-agent "fixes" the app toward a `.tsv`: `ar.tsv` says `جماعة عرقية` but the app and glossary say `مجموعة شعبية`; `es.tsv`/`pt.tsv` say `grupo étnico` but the glossaries say `grupo de personas`/`povo`; `ru.tsv` says `этническая группа` but both say `народ`. The `ar.tsv` also carries a competing `مُتواصَل` family for *unengaged* — **do not mix it into the engagement-marker cluster**; §2 of the Arabic glossary keeps the `الانخراط` family, which is what the app does. |

---

## 6. Out-of-scope authorisations

§2's hard rules bar D1–D5 from touching approved keys outside §4's 46 and outside §6.6's seven **unless C1 names them explicitly in a change set**. C1 applied one uniform test, stated here so the boundary is auditable:

> **Authorise** if (a) a Phase 1 agent stated an **exact replacement string**, AND (b) the current string is factually wrong, ungrammatical, breaks a placeholder, misrenders the brand, or contradicts a string the new content introduces.
> **Refuse** if the objection is stylistic preference, or if no exact replacement exists.

| Key | Lang | Sev | Ruling | Reason |
|---|---|---|---|---|
| `nRemindersSet` | fr | **Blocker** | **AUTHORISED** | Stray `s` renders at every count ≥ 2. Exact string from B1, concurred by A3. (B-03) |
| `nPeopleGroups` | ru | **Blocker** | **AUTHORISED** | Literal `1` at 21/31/41/101; `2 народов` for `2 народа`. Noun forms `народ`/`народа`/`народов` **confirmed** by C1 — standard paradigm, and the genitive plural is already attested in the key's own `=0` branch. (B-04) |
| `nRemindersSet` | ru | **Blocker** | **AUTHORISED** | Same defect. `напоминание`/`напоминания`/`напоминаний` **confirmed**. (B-04) |
| `nPeopleGroups`, `nRemindersSet` | ar | Major | **REFUSED this pass — gap recorded** | Test (a) fails. The Arabic **dual** and **3–10 plural** forms of `مجموعة شعبية` and `تذكير` appear in **no findings file** — A1 did not address these keys, and A1's dual/plural morphology (F-AR-11) is for `ثانية` only. **C1 will not invent Arabic morphology, and will not let a literal `<A1: dual>` placeholder ship to users.** D1 must leave both keys **exactly as they are**. The structural skeleton is preserved below for the follow-up pass; the defect (counts 2 and 3–10 disagree) is carried forward as **open**. See §10. |
| `appName` | ar | **Blocker** | **AUTHORISED** → `Doxa Prayer` | `صلاة دوكسا` transliterates **and translates** the product name to "prayer of Doxa". (B-06) |
| `reminderNotificationBody` | ar | **Blocker** | **AUTHORISED** → `افتح تطبيق Doxa لبدء صلاة اليوم.` | Says "open the **book** Doxa" and transliterates the brand. Exact string from B2 (F-VOCAB-09); A1 and B1 both flagged the defect. (B-06) |
| `wizardWelcomeBody` | ar | **Blocker** | **AUTHORISED — script swap only** | `«دوكسا»` → bare `Doxa`. **C1 deliberately declined B1's proposed change of the verb from `تساعدك` to `يساعدك`:** verb gender is an Arabic grammar call, B1 is a structural agent not authorised to make one, and no Arabic reviewer ruled on it. The guillemets are dropped because in this file guillemets mark the *product* name (`«Doxa Prayer»`) and placeholder names, while the bare organisation form is what the in-scope strings A1 verified as correct use (`تطبيق Doxa`, `أخبار Doxa`). (B-06) |
| `nextReminderToday`, `nextReminderTomorrow`, `nextReminderOn` | ar | **Blocker** | **AUTHORISED** | Render "at {time}" as "on the website"/"on the link". A1 stated the correct form (`اليوم في الساعة {time}`) and "etc."; C1 applied that pattern mechanically to all three, preserving each string's existing leading element. (B-05) |
| `appVersion` | ar, ru | Minor | **AUTHORISED** | Missing space renders `Версия1.2.3` / `الإصدار1.2.3`. (M-03) |
| `@feedback` description | all 5 | Minor | **AUTHORISED** | States a behaviour the app no longer has, and Weblate shows it to translators. D-agents are already rewriting `@` blocks under §6.2, so this is squarely in their lane. (M-02) |
| `reminders` | ar | Minor | **AUTHORISED** → `التذكيرات` | Singular `تذكير` titles a screen that **lists** reminders, contradicting `تذكيرات` used everywhere else in the same file. B2 supplied the canonical plural, attested twice in-file (F-VOCAB-08). One word, number error, zero risk. |
| `nameLabel` | ar | Minor | **AUTHORISED** → `الاسم` | `الإسم` is a misspelling (no hamza on the alif of `الاسم`), **and the new `feedbackNameLabel` spells the same word correctly** — so the new content has created a two-spellings-one-label inconsistency. Test (b) satisfied on both limbs. A1 stated the correct form (F-AR-13 item 5). |
| `search` | ar | Minor | **AUTHORISED** → `ابحث` | `إبحث` is ungrammatical — no hamza on the imperative of a form-I verb. A1 stated the correct form (F-AR-13 item 6). |
| `prayerThankYouVerse` | ru | Minor | **AUTHORISED** → «за всё» | The brief invited me to consider leaving the Synodal spelling. **Ruled to apply.** The word *is* `всё` (neuter, *everything*); the Synodal text predates routine `ё` printing, so writing `всё` does not alter the text, it disambiguates the same word. `app_ru.arb` is a `ё`-writing file (A5's house-style finding, uncontested). And A5's own point is decisive: without the `ё` it is "genuinely misreadable as *give thanks for everyone*" — an ambiguity in a Scripture quotation is the worst place to leave one. Minor, and trivially reversible if a human prefers the bare spelling. |
| `updateRequiredBody` | ru | — | **REFUSED** | Test (b) fails: cosmetic by A5's own label, and the current bare product name is not wrong. Two further reasons: the sentence *already* says «приложение» earlier, so the proposal would repeat it; and authorising cosmetics dilutes the Blocker signal in a parallel five-file write. Deferred. |
| `switchPeopleGroupConfirm` uses `الدعاء` where the file says `الصلاة` | ar | — | **REFUSED** | Test (a) fails — A1 explicitly declined to propose a replacement. **D1 changes only the guillemets on this key** (P-01) and must not touch `الدعاء`. |
| `dismissNextReminder` `إغلاق` vs `dismissReminderLabel` `تجاهل` | ar | — | **REFUSED** | Test (a) fails; A1 says both are defensible in isolation. Note `ru` deliberately keeps its two verbs distinct (`Скрыть` hides a banner, `Отклонить` turns a rule off) — different actions, so a single verb is not obviously right in Arabic either. |
| Diacritic variance (`تعذر`/`تعذّر`, `يرجى`/`يُرجى`) | ar | — | **REFUSED** | Both spellings are correct Arabic; A1 says the variance is invisible in practice and not worth a diff. No proposed strings normalise it. |
| `emailLabel` "Email" vs "e-mail" | fr | — | **REFUSED** | A3 filed it as a Note with no action; neither in scope nor in the §4.3 verification cluster. |
| `notificationsHowToEnable` "Pulsa" vs "Toca" | es | — | **REFUSED** | A2 explicitly recommended no change; Android es-ES itself splits *Toca* (touchscreen) from *Pulsa* (hardware key), which is close to how the file already splits them. |
| `dismissNextReminder`, `saveAndContinue` — unreferenced dead keys | all 6 | — | **REFUSED for Phase 3** | Deleting them requires editing `app_en.arb`, which §2 forbids during implementation. Escalated in §8. |

**Preserved for the follow-up pass — `ar` plural skeletons with the gap marked.** These are **not** for D1 and must not be pasted into any `.arb` file; `<GAP: Arabic dual>` / `<GAP: Arabic 3–10 plural>` are placeholders for a native speaker to fill:

```
nPeopleGroups: {count, plural, =0{لا توجد مجموعات شعبية} one{مجموعة شعبية واحدة} two{<GAP: Arabic dual>} few{{count} <GAP: Arabic 3–10 plural>} many{{count} مجموعة شعبية} other{{count} مجموعة شعبية}}
nRemindersSet: {count, plural, =0{لم يتم تعيين أي تذكير} one{تم تعيين تذكير واحد} two{<GAP: Arabic dual>} few{تم تعيين {count} <GAP: Arabic 3–10 plural>} many{تم تعيين {count} تذكير} other{تم تعيين {count} تذكير}}
```

*(Arabic's CLDR `ONE` is exactly `n == 1`, so the existing `=1` branch is safe and renaming it to `one` is equivalent — unlike Russian, where the `=1` branch is the bug.)*

**Already sanctioned by §6.6, no C1 authorisation needed:** `es` `scanToPray` + `switchPeopleGroupConfirm`; `pt`'s five (`peopleGroupIntroTitle`, `scanToPray`, `shareMessage`, `switchPeopleGroupConfirm`, `wizardConfirmPeopleGroupTitle`); `fr`'s five (same list); `ru` `scanToPray`; `ar` `switchPeopleGroupConfirm`.

---

## 7. Non-`.arb` items — for the orchestrator, NOT for D1–D5

These are Dart-side and must not enter any change set. D-agents own exactly one `.arb` file each.

| # | File | Line | Issue | Fix |
|---|---|---|---|---|
| N-01 | `lib/screens/people_group_details_screen.dart` | **526** | Hardcoded English `FilledButton(onPressed: onRetry, child: const Text('Retry'))`. Whenever `fetchPeopleGroupDetail` fails, `_ErrorView` renders a correctly localised message (`l.couldNotLoadPeopleGroupDetailsMessage`, line 89) directly above an English button, for all five non-English audiences. **The key already exists** — `retry`, with its `@retry` block, translated in all five locale files. C1 verified the line. (F-MECH-07, Major) | `child: Text(AppLocalizations.of(context)!.retry)` — `AppLocalizations` is already imported (used at line 106). One-line change, no `.arb` edit. |
| N-02 | `lib/components/buttons/arrow_button.dart` | **22-24** | `direction == ArrowDirection.back ? TriangleDirection.left : TriangleDirection.right` — the forward arrow is drawn rightward **unconditionally**, so in RTL Arabic it points the wrong way regardless of its label. C1 verified the code. (F-AR-13 item 10) | Mirror on `Directionality.of(context)`. Not a translation defect — `forwardLabel` is correct in all five (§5, A-refutation of §6.8). |
| N-03 | `lib/components/buttons/arrow_button.dart` / `lib/screens/gallery_screen.dart:358-359` | — | `ArrowButton` is instantiated **only** in the component gallery, so `forwardLabel` has never rendered in a shipping flow. Five reviewers judged it against the widget's paired back label rather than a real screen. | Re-check when the arrow lands in a real flow. No action now. |
| N-04 | `lib/screens/debug_screen.dart`, `lib/screens/gallery_screen.dart` | — | Many English literals; both routed **unconditionally** in `lib/router.dart:205,211`. B1 treated them as developer tools reachable only by typing the route and excluded them from N-01. | Confirm they are not user-reachable. If they ship as reachable UI, there is more un-localised text than this report claims. |
| N-05 | `lib/components/buttons/action_button.dart:101`, `lib/components/buttons/button_bar_wrap.dart` | — | `ActionButton` renders `label.toUpperCase()`, and `ButtonBarWrap._labelWidth` measures the uppercased form. Uppercase Cyrillic and accented Latin are ~10–15 % wider than mixed case, so `РАЗРЕШИТЬ` / `AUTORISER` will force the exact-alarms modal into its stacked layout on narrow devices at large text scale. | **Degradation, not breakage** — the code is explicit about it. No action proposed. Worth one screenshot in Phase 4. |

---

## 8. Raised for a human

**English-source problems only.** No translation decision is escalated here — §2 forbids it, and every terminology question in this audit was resolved from a glossary or its nearest precedent, with the precedent recorded.

| # | Item | Why it needs a human |
|---|---|---|
| H-01 | **`enableNotificationsPromptBody`'s English is tautological.** "Enable notifications to also receive updates in push notifications." uses *notifications* as both the thing being enabled and the channel, so a faithful translation reads as circular in all five languages. (F-VOCAB-10, filed against `en`.) | Changing `app_en.arb` invalidates all five translations, so it cannot land in this pass. **It does not block anything:** all five translations were written against the English as it stands, all use B2's canonical *push notifications* form, and all read acceptably. Suggested English: *"Enable notifications to also get these updates on your phone."* |
| H-02 | **`dismissNextReminder` and `saveAndContinue` are unreferenced dead keys.** B1 grepped all 170 English keys as whole-word identifiers across every non-generated `.dart` file; these two are the only ones with zero hits. Both are present, translated and `@`-documented in all six files. | Deleting them is a six-file, twelve-block change that must start in `app_en.arb`, and Weblate needs telling. Both predate the audit baseline. Separate cleanup. |
| H-03 | **English `emailsLoadError` is imprecise.** "Couldn't load your emails" means email **addresses** (`List<SignedUpEmail>`), but "emails" reads as messages. Spanish and Russian reviewers **independently** had to disambiguate in translation (P-05); Spanish rated it Major because it makes a settings screen appear to be talking about the user's inbox. | The English is the root cause. Suggested: *"Couldn't load your email addresses."* Two of five reviewers hitting the same ambiguity is the signal. |
| H-04 | **`resendVerificationCooldown` / `resendVerificationCountdown` should arguably have been authored as plurals.** English sidesteps agreement by abbreviating (`{seconds}s`); `es`/`fr`/`pt`/`ru` followed with `s`/`с`, which take no agreement — but the counter ticks 60 → 0 through every value, and Arabic must spell the unit out, so it needs real plural machinery (A-06). Two agents reached this independently (F-AR-11's closing flag, F-MECH-11). | Not blocking — the Arabic ICU plural is well-formed with a flat English template, and `gen-l10n` permits it. Flagged as an authoring-pattern question for whoever adds the next counted string. |
| H-05 | **The `=0` / `=1` skeleton in English's plural keys is a trap when copied into locale files.** `gen-l10n` compiles `=1` to the `one:` argument of `Intl.pluralLogic`, which for Russian matches 21/31/41/101 — producing B-04. The pattern is legitimate in English and was copied verbatim into locales where it is wrong. | A process/tooling caution rather than a defect in `app_en.arb`, but it is an English-source pattern with a five-locale blast radius, and the same trap will fire on the next `=N` branch added. Worth a note in the translation guide. |
| H-06 | **No `@@locale` in any of the six `.arb` files; `app_en.arb` lacks a trailing newline.** (F-MECH-16/17.) | Both would require editing `app_en.arb`. Weblate identifies an ARB component's language from `@@locale` when present. Deliberately **not** fixed mid-audit, so five files under concurrent write are not perturbed. |

---

## 9. Coverage table

46 keys × 5 languages = **230 verdicts, all present.** No gaps in the audit itself.

Legend: `—` checked and correct, no change · `T` typography only (§6.6 / spacing) · `m` Minor · `M` Major · **`B`** Blocker · `N` new string added

### §4.1 Glossary-sensitive (12 keys)

| Key | ar | es | fr | pt | ru |
|---|---|---|---|---|---|
| `dailyPrayerCoverage` | — | — | — | — | **B** |
| `engaged` | M | — | — | — | — |
| `partial` | — | — | m | — | — |
| `prayForPeopleGroupLabel` | — | T | T | T | m+T |
| `prayerReminderBody` | — | T | m+T | T | m+T |
| `prayerReminderTitle` | M | M | M | M | M |
| `prayerRecordedAnnouncement` | — | — | — | — | — |
| `signUp` | — | — | — | — | — |
| `feedbackConsentLabel` | — | — | — | M | m |
| `newsSignupSuccessTitle` | — | — | T | — | — |
| `newsSignupSuccessBody` | — | — | — | — | — |
| `enableNotificationsPromptBody` | **B**/N | **B**/N | **B**/N | **B**/N | **B**/N |

### §4.2 General UI (34 keys)

| Key | ar | es | fr | pt | ru |
|---|---|---|---|---|---|
| `accountSectionTitle` | — | — | — | — | — |
| `allow` | — | — | — | — | — |
| `allowExactAlarms` | M | — | — | — | — |
| `clearSearchLabel` | — | — | — | — | — |
| `dismissReminderLabel` | — | — | — | — | — |
| `emailUnverified` | — | — | — | — | — |
| `emailVerified` | — | — | — | — | — |
| `emailsLoadError` | — | M | — | — | m |
| `enableNotificationsButton` | **B**/N | **B**/N | **B**/N | **B**/N | **B**/N |
| `exactAlarmsDisabledStatus` | M | m | T | — | — |
| `exactAlarmsPromptBody` | M | — | — | — | — |
| `feedbackError` | — | — | — | — | — |
| `feedbackIntro` | m | — | — | m | — |
| `feedbackMessageLabel` | — | — | — | — | — |
| `feedbackMessageRequired` | — | — | — | — | — |
| `feedbackNameLabel` | — | — | — | — | — |
| `feedbackRateLimited` | — | — | — | — | — |
| `feedbackSubmit` | — | — | m | — | — |
| `feedbackSuccessBody` | m | m | M | m | — |
| `feedbackSuccessTitle` | — | — | T | — | — |
| `feedbackTypeCompliment` | m | — | — | — | — |
| `feedbackTypeLabel` | — | — | T | — | — |
| `feedbackTypeProblem` | — | — | — | — | — |
| `feedbackTypeRequired` | — | — | — | — | — |
| `feedbackTypeSuggestion` | — | — | — | — | — |
| `forwardLabel` | — | — | — | — | — |
| `notNow` | — | — | — | — | — |
| `pictureCreditLabel` | — | — | — | — | — |
| `resendVerification` | — | — | — | — | m |
| `resendVerificationCooldown` | m | — | T | — | — |
| `resendVerificationCountdown` | m | — | T | — | — |
| `resendVerificationFailed` | m | m | — | — | — |
| `resendVerificationSent` | m | — | — | m | — |
| `viewProfile` | — | — | — | — | — |

### Approved keys touched (§6.6 exception + §6 authorisations)

| Key | ar | es | fr | pt | ru |
|---|---|---|---|---|---|
| `peopleGroupIntroTitle` | — | — | T | T | — |
| `scanToPray` | — | T | T | T | T |
| `shareMessage` | — | — | T | T | — |
| `switchPeopleGroupConfirm` | T | T | T | T | — |
| `wizardConfirmPeopleGroupTitle` | — | — | T | T | — |
| `nPeopleGroups` | *open* | — | — | — | **B** |
| `nRemindersSet` | *open* | — | **B** | — | **B** |
| `appName` | **B** | — | — | — | — |
| `appVersion` | m | — | — | — | m |
| `nextReminderToday` / `Tomorrow` / `On` | **B**×3 | — | — | — | — |
| `reminderNotificationBody` | **B** | — | — | — | — |
| `wizardWelcomeBody` | **B** | — | — | — | — |
| `reminders` | m | — | — | — | — |
| `nameLabel` | m | — | — | — | — |
| `search` | m | — | — | — | — |
| `prayerThankYouVerse` | — | — | — | — | m |
| `@feedback` (metadata) | m | m | m | m | m |

**Change counts:** `ar` 27 strings + 1 metadata + 21 `@` blocks · `es` 11 + 1 + 21 · `fr` 20 + 1 + 21 · `pt` 14 + 1 + 21 · `ru` 15 + 1 + 21.

---

## 10. Per-language change sets

**These are the critical deliverable. D-agents apply them verbatim.** Each list is flat and ordered; the two new keys are marked **`NEW`** and go at their alphabetical position, between `emailsLoadError` and `engaged`. Every key not named here stays exactly as it is. Do not re-sort the file. Do not substitute your own wording — if a string is genuinely unusable, apply nothing for that key and record why.

Every D-agent also, in all five files:
- adds the **21 `@key` blocks** (M-01), copying `description` and any `placeholders` sub-object from the **live** `app_en.arb` (M-08);
- replaces the `@feedback` description with `"Button that opens the in-app feedback panel"` (M-02);
- verifies valid JSON, placeholder parity against `app_en.arb`, and key-set equality with `app_en.arb` before finishing.

---

### 10.1 `ar` — D1 `apply-ar` → `lib/l10n/app_ar.arb`

Guillemets are `«` U+00AB and `»` U+00BB, **no inner space**. `Doxa` is Latin, never `دوكسا`. Verify after applying that no RTL string reordered — a bidi-naive editor can silently permute these.

**In-scope keys (§4)**

| # | Key | Exact final string |
|---|---|---|
| 1 | `allowExactAlarms` | `السماح بالمنبّهات الدقيقة` |
| 2 | `enableNotificationsButton` **NEW** | `تمكين الإشعارات` |
| 3 | `enableNotificationsPromptBody` **NEW** | `قم بتمكين الإشعارات لتصلك آخر المستجدات عبر الإشعارات الفورية أيضًا.` |
| 4 | `engaged` | `مُنخرَطة` |
| 5 | `exactAlarmsDisabledStatus` | `المنبّهات الدقيقة غير مسموح بها لتطبيق Doxa، لذا قد تصل تذكيرات الصلاة متأخرة بعدة دقائق.` |
| 6 | `exactAlarmsPromptBody` | `لكي تصل تذكيرات الصلاة في وقتها تمامًا، اسمح لتطبيق Doxa باستخدام المنبّهات الدقيقة.` |
| 7 | `feedbackIntro` | `يسعدنا أن نسمع منك. أخبرنا برأيك في التطبيق.` |
| 8 | `feedbackSuccessBody` | `تم إرسال تعليقاتك من العنوان {email}. إذا لم يكن هذا هو العنوان الصحيح، فأعد إرسالها بالعنوان الصحيح.` |
| 9 | `feedbackTypeCompliment` | `إشادة` |
| 10 | `prayerReminderTitle` | `هل أنت مستعد لصلاة اليوم؟` |
| 11 | `resendVerificationCooldown` | `{seconds, plural, zero{يُرجى الانتظار قليلًا قبل طلب رسالة أخرى.} one{يُرجى الانتظار ثانية واحدة قبل طلب رسالة أخرى.} two{يُرجى الانتظار ثانيتين قبل طلب رسالة أخرى.} few{يُرجى الانتظار {seconds} ثوانٍ قبل طلب رسالة أخرى.} many{يُرجى الانتظار {seconds} ثانية قبل طلب رسالة أخرى.} other{يُرجى الانتظار {seconds} ثانية قبل طلب رسالة أخرى.}}` |
| 12 | `resendVerificationCountdown` | `{seconds, plural, one{إعادة الإرسال خلال ثانية} two{إعادة الإرسال خلال ثانيتين} few{إعادة الإرسال خلال {seconds} ثوانٍ} many{إعادة الإرسال خلال {seconds} ثانية} other{إعادة الإرسال خلال {seconds} ثانية}}` |
| 13 | `resendVerificationFailed` | `تعذّر إرسال الرسالة. يرجى المحاولة مرة أخرى.` |
| 14 | `resendVerificationSent` | `تم إرسال رسالة التحقق. تفقَّد صندوق الوارد.` |

**§6.6 placeholder typography (approved key — guillemets only, nothing else)**

| # | Key | Exact final string |
|---|---|---|
| 15 | `switchPeopleGroupConfirm` | `هل تريد التوقف عن الدعاء من أجل «{currentName}» والبدء في الدعاء من أجل «{newName}»؟` |

> Do **not** change `الدعاء` → `الصلاة` on this key. That was refused (§6) — guillemets only.

**Authorised out-of-scope (§6)**

| # | Key | Exact final string |
|---|---|---|
| 16 | `appName` | `Doxa Prayer` |
| 17 | `appVersion` | `الإصدار {version}` |
| 18 | `nameLabel` | `الاسم` |
| 19 | `nextReminderToday` | `اليوم في الساعة {time}` |
| 20 | `nextReminderTomorrow` | `غدًا في الساعة {time}` |
| 21 | `nextReminderOn` | `{weekday} في الساعة {time}` |
| 22 | `reminderNotificationBody` | `افتح تطبيق Doxa لبدء صلاة اليوم.` |
| 23 | `reminders` | `التذكيرات` |
| 24 | `search` | `ابحث` |
| 25 | `wizardWelcomeBody` | `تساعدك Doxa على الصلاة من أجل إحدى المجموعات الشعبية غير المُبشَّر بها. سنساعدك في اختيار مجموعة معينة، وضبط تذكير، ومتابعة آخر المستجدات.` |

**Metadata:** `@feedback` → `"description": "Button that opens the in-app feedback panel"`. Plus the 21 `@key` blocks.

**Explicitly NOT to be touched by D1:** `nPeopleGroups`, `nRemindersSet` — left as-is; the Arabic dual and 3–10 forms were not determined (§6, §11). `dismissNextReminder`, `switchPeopleGroupConfirm`'s verb, and the file's diacritic variance — all refused.

---

### 10.2 `es` — D2 `apply-es` → `lib/l10n/app_es.arb`

Guillemets are `«` U+00AB and `»` U+00BB, **no inner space** — Spanish takes no inner space, unlike French. `¿`/`¡` pairs stay paired. `Doxa` never translated, never inflected, never articled.

**In-scope keys (§4)**

| # | Key | Exact final string |
|---|---|---|
| 1 | `emailsLoadError` | `No se han podido cargar tus direcciones de correo.` |
| 2 | `enableNotificationsButton` **NEW** | `Activar notificaciones` |
| 3 | `enableNotificationsPromptBody` **NEW** | `Activa las notificaciones para recibir también las novedades como notificaciones push.` |
| 4 | `exactAlarmsDisabledStatus` | `Doxa no tiene permiso para usar alarmas exactas, por lo que tus recordatorios de oración pueden llegar con varios minutos de retraso.` |
| 5 | `feedbackSuccessBody` | `Tus comentarios se han enviado desde {email}. Si esa no es la dirección correcta, vuelve a enviarlos con la correcta.` |
| 6 | `prayForPeopleGroupLabel` | `Orar por «{peopleGroup}»` |
| 7 | `prayerReminderBody` | `Toca para orar por «{peopleGroup}».` |
| 8 | `prayerReminderTitle` | `¿Todo listo para la oración de hoy?` |
| 9 | `resendVerificationFailed` | `No se ha podido enviar el correo. Inténtalo de nuevo.` |

**§6.6 placeholder typography (approved keys — guillemets only)**

| # | Key | Exact final string |
|---|---|---|
| 10 | `scanToPray` | `Escanea el código para descargar la aplicación y ora por los «{name}»` |
| 11 | `switchPeopleGroupConfirm` | `¿Quieres dejar de orar por «{currentName}» y empezar a orar por «{newName}»?` |

> `peopleGroupIntroTitle`, `shareMessage`, `wizardConfirmPeopleGroupTitle` already carry guillemets correctly — leave them alone.

**Metadata:** `@feedback` → `"description": "Button that opens the in-app feedback panel"`. Plus the 21 `@key` blocks.

**Explicitly NOT to be changed:** `engaged` = `Comprometido` — **confirmed correct against `glossary.es_ES.md` §2; §6.5's suspicion is refuted.** Also `dailyPrayerCoverage` = `Cobertura de oración diaria`, the whole `alarmas exactas` cluster term, the `comentarios` feedback scheme, `feedbackConsentLabel`, `notificationsHowToEnable`'s `Pulsa`, and the deliberate `{seconds} s` unit space (correct RAE/SI typography, an improvement on the English).

---

### 10.3 `fr` — D3 `apply-fr` → `lib/l10n/app_fr.arb`

**Codepoints are the substance of half these changes. Read the token legend at the top of this report.** `[NNBSP]` = U+202F, `[NBSP]` = U+00A0. Guillemets are `«` U+00AB and `»` U+00BB **with `[NNBSP]` inside both**. Every apostrophe is **ASCII `'` U+0027** — after this pass the file must contain **zero U+2019**. Verify with a codepoint check, not by eye.

The four spacing rules, stated in prose because they cannot be seen:
- Before `;` `?` `!` → **U+202F NARROW NO-BREAK SPACE**.
- Before `:` → **U+00A0 NO-BREAK SPACE**. (Ruling R3/A-03 — `shareMessage`'s existing U+00A0 is *correct French* and is **preserved**. B1's suggestion to normalise it to U+202F is overruled.)
- Between `{seconds}` and the unit `s` → **U+00A0**.
- Inside `« … »` → **U+202F** on both sides of the content.

**In-scope keys (§4)**

| # | Key | Exact final string |
|---|---|---|
| 1 | `enableNotificationsButton` **NEW** | `Activer les notifications` |
| 2 | `enableNotificationsPromptBody` **NEW** | `Activez les notifications pour recevoir aussi les actualités par notification push.` |
| 3 | `exactAlarmsDisabledStatus` | `Les alarmes exactes ne sont pas autorisées pour Doxa[NNBSP]; vos rappels de prière peuvent donc arriver avec plusieurs minutes de retard.` — wording unchanged; **only** the space before `;` becomes U+202F |
| 4 | `feedbackSubmit` | `Envoyer des commentaires` |
| 5 | `feedbackSuccessBody` | `Vos commentaires ont été envoyés depuis l'adresse {email}. Si ce n'est pas la bonne adresse, renvoyez-les avec la bonne.` — `à` → `depuis`; ASCII apostrophes |
| 6 | `feedbackSuccessTitle` | `Merci[NNBSP]!` |
| 7 | `feedbackTypeLabel` | `Quel type de commentaire[NNBSP]?` |
| 8 | `newsSignupSuccessTitle` | `Merci de votre inscription[NNBSP]!` |
| 9 | `partial` | `En partie` |
| 10 | `prayForPeopleGroupLabel` | `Prier pour «[NNBSP]{peopleGroup}[NNBSP]»` |
| 11 | `prayerReminderBody` | `Appuyez ici pour prier pour «[NNBSP]{peopleGroup}[NNBSP]».` |
| 12 | `prayerReminderTitle` | `Prêt pour la prière d'aujourd'hui[NNBSP]?` — ASCII apostrophes |
| 13 | `resendVerificationCooldown` | `Veuillez patienter {seconds}[NBSP]s avant de demander un autre e-mail.` — wording unchanged; **only** the space before `s` becomes U+00A0 |
| 14 | `resendVerificationCountdown` | `Renvoyer dans {seconds}[NBSP]s` — same, U+00A0 |

**§6.6 placeholder typography (approved keys)**

| # | Key | Exact final string |
|---|---|---|
| 15 | `peopleGroupIntroTitle` | `Priez pour «[NNBSP]{name}[NNBSP]»` — the elided `l'` is **deliberately dropped**; `l'« {name} »` is not legal French and `l'Peul` is ungrammatical |
| 16 | `scanToPray` | `Scannez le code pour télécharger l'application et priez pour «[NNBSP]{name}[NNBSP]»` — elided `l'` dropped before the placeholder; ASCII apostrophe in `l'application` |
| 17 | `shareMessage` | `Priez avec moi pour «[NNBSP]{name}[NNBSP]» — téléchargez l'application Doxa Prayer[NBSP]:` — em dash U+2014 preserved; both `’` → ASCII `'` (only one apostrophe survives, in `l'application`); **the space before `:` stays U+00A0** |
| 18 | `switchPeopleGroupConfirm` | `Voulez-vous cesser de prier pour «[NNBSP]{currentName}[NNBSP]» et commencer à prier pour «[NNBSP]{newName}[NNBSP]»[NNBSP]?` — wording unchanged; the four inner guillemet spaces become U+202F; the existing U+202F before `?` is preserved |
| 19 | `wizardConfirmPeopleGroupTitle` | `Prier pour «[NNBSP]{name}[NNBSP]»[NNBSP]?` — wording unchanged; the two inner spaces become U+202F; the existing U+202F before `?` is preserved |

**Authorised out-of-scope (§6)**

| # | Key | Exact final string |
|---|---|---|
| 20 | `nRemindersSet` | `{count, plural, =0{Aucun rappel défini} =1{1 rappel défini} other{{count} rappels définis}}` — the stray `s` after `{count}` is removed |

**Metadata:** `@feedback` → `"description": "Button that opens the in-app feedback panel"`. Plus the 21 `@key` blocks.

**Explicitly NOT to be changed:** `engaged` = `Engagé`, `dailyPrayerCoverage` = `Couverture de prière quotidienne`, `forwardLabel` = `Suivant`, the `alarmes exactes` cluster, `emailLabel`, and — critically — **`shareMessage`'s U+00A0 before the colon**.

---

### 10.4 `pt` — D4 `apply-pt` → `lib/l10n/app_pt.arb`

**The target is Brazilian Portuguese (pt-BR)**, despite the `glossary.pt_PT.md` filename — the glossary declares it in its own front matter. Nothing in this file is to be "corrected" toward European Portuguese.

**Name delimiters are `[LDQ]` U+201C and `[RDQ]` U+201D, with no inner space — never ASCII `"`, never guillemets `« »`.** The guillemet-vs-curly distinction *is* the decision, so verify the codepoints before and after applying. Question marks and sentence periods stay **outside** the closing quote.

**In-scope keys (§4)**

| # | Key | Exact final string |
|---|---|---|
| 1 | `enableNotificationsButton` **NEW** | `Ativar notificações` |
| 2 | `enableNotificationsPromptBody` **NEW** | `Ative as notificações para receber as novidades também por notificações push.` |
| 3 | `feedbackConsentLabel` | `Quero receber novidades da Doxa` |
| 4 | `feedbackIntro` | `Adoraríamos ouvir você. Conte-nos o que você acha do aplicativo.` |
| 5 | `feedbackSuccessBody` | `Seus comentários foram enviados como {email}. Se esse não for o endereço certo, envie-os novamente com o correto.` |
| 6 | `prayForPeopleGroupLabel` | `Orar por [LDQ]{peopleGroup}[RDQ]` |
| 7 | `prayerReminderBody` | `Toque para orar por [LDQ]{peopleGroup}[RDQ].` |
| 8 | `prayerReminderTitle` | `Tudo pronto para a oração de hoje?` — **keep `Tudo pronto`**; it makes *tudo* the subject and stays gender-neutral. Do not "simplify" to `Pronto para…?` |
| 9 | `resendVerificationSent` | `E-mail de verificação enviado. Confira sua caixa de entrada.` |

**§6.6 placeholder typography (approved keys — delimiters only)**

| # | Key | Exact final string |
|---|---|---|
| 10 | `peopleGroupIntroTitle` | `Ore por [LDQ]{name}[RDQ]` |
| 11 | `scanToPray` | `Escaneie o código para baixar o aplicativo e orar por [LDQ]{name}[RDQ]` |
| 12 | `shareMessage` | `Ore comigo por [LDQ]{name}[RDQ] — baixe o aplicativo Doxa Prayer:` — em dash U+2014 preserved |
| 13 | `switchPeopleGroupConfirm` | `Você quer parar de orar por [LDQ]{currentName}[RDQ] e começar a orar por [LDQ]{newName}[RDQ]?` |
| 14 | `wizardConfirmPeopleGroupTitle` | `Orar por [LDQ]{name}[RDQ]?` |

**Metadata:** `@feedback` → `"description": "Button that opens the in-app feedback panel"`. Plus the 21 `@key` blocks.

**Explicitly NOT to be changed:** `engaged` = `Engajado` (the glossaried form; `comprometido` is correctly reserved for a **different** concept in `peopleCommittedToPraying`), `dailyPrayerCoverage` = `Cobertura de oração diária`, `forwardLabel` = `Avançar`, the `alarmes exatos` cluster, `partial` = `Parcial`, and **the `o Doxa` / `a Doxa` article split — do not harmonise it** (`o Doxa` = the app, `a Doxa` = the ministry; every in-scope key already obeys the rule).

---

### 10.5 `ru` — D5 `apply-ru` → `lib/l10n/app_ru.arb`

Guillemets are `«` U+00AB and `»` U+00BB, **no inner space**. The file is a **`ё`-writing** file — preserve `ё` in every string below. `Doxa` is always Latin, never transliterated; the bare organisation form is correct in all the new strings.

**In-scope keys (§4)**

| # | Key | Exact final string |
|---|---|---|
| 1 | `dailyPrayerCoverage` | `Ежедневный молитвенный охват` — note the **masculine** adjective ending; `охват` is masculine, so `Ежедневное` → `Ежедневный` |
| 2 | `emailsLoadError` | `Не удалось загрузить ваши адреса электронной почты.` |
| 3 | `enableNotificationsButton` **NEW** | `Включить уведомления` |
| 4 | `enableNotificationsPromptBody` **NEW** | `Включите уведомления, чтобы получать новости также в push-уведомлениях.` |
| 5 | `feedbackConsentLabel` | `Хочу получать новости от Doxa` |
| 6 | `prayForPeopleGroupLabel` | `Помолиться за народ «{peopleGroup}»` |
| 7 | `prayerReminderBody` | `Нажмите, чтобы помолиться за народ «{peopleGroup}».` |
| 8 | `prayerReminderTitle` | `Готовы к сегодняшней молитве?` |
| 9 | `resendVerification` | `Отправить письмо повторно` |

**§6.6 placeholder typography (approved key — guillemets only)**

| # | Key | Exact final string |
|---|---|---|
| 10 | `scanToPray` | `Отсканируйте QR-код, чтобы установить приложение, и помолитесь за «{name}»` |

> Guillemets **only**. Do **not** also add «народ» here — §6.6 licenses typography on approved strings and nothing else.

**Authorised out-of-scope (§6)**

| # | Key | Exact final string |
|---|---|---|
| 11 | `appVersion` | `Версия {version}` |
| 12 | `nPeopleGroups` | `{count, plural, =0{Нет народов} one{{count} народ} few{{count} народа} many{{count} народов} other{{count} народов}}` |
| 13 | `nRemindersSet` | `{count, plural, =0{Напоминаний не установлено} one{Установлено {count} напоминание} few{Установлено {count} напоминания} many{Установлено {count} напоминаний} other{Установлено {count} напоминаний}}` |
| 14 | `prayerThankYouVerse` | `Всегда радуйтесь, непрестанно молитесь, за всё благодарите; ибо такова воля Божья для вас во Христе Иисусе.` — `все` → `всё` only |

> On 12 and 13: the change from `=1{1 народ}` to `one{{count} народ}` is **deliberate and load-bearing.** Keeping a literal `1` inside a category that also matches 21/31/41/101 *is* the bug. `=0` stays — Russian has no CLDR `zero` category, so that branch fires only at an exact 0.

**Metadata:** `@feedback` → `"description": "Button that opens the in-app feedback panel"`. Plus the 21 `@key` blocks.

**Explicitly NOT to be changed:** `engaged` = `Вовлечён` (masculine **short** form — a long-form adjective would strand itself as a bare caption), `partial` = `Частично` (the adverb is correct and arguably the best of the five), `forwardLabel` = `Вперёд`, the `точные будильники` cluster, `signUp` = `Зарегистрироваться` (glossaried, despite being the app's longest button at 2.57×), the deliberate `{seconds} с` unit space, `почта` for *inbox* in running text, and `updateRequiredBody` (**refused** — §6).

---

## 11. What the audit could not determine

Stated plainly. Nothing here blocks Phase 3.

1. **The Arabic dual and 3–10 plural noun forms for `nPeopleGroups` and `nRemindersSet`.** This is the one real gap in the audit's output. The *structural* defect is proven by simulation (F-MECH-04): counts 2 and 3–10 fall through to `other`, which carries the accusative singular, rendering `3 مجموعة شعبية`. But the correct forms of `مجموعة شعبية` and `تذكير` in the dual and in the 3–10 broken plural appear in **no findings file** — A1 did not reach these keys, and A1's dual/plural work (F-AR-11) covers `ثانية` only. C1 declined to invent Arabic morphology and declined to let a `<GAP>` marker ship. **Consequence: `app_ar.arb` remains wrong at counts 2 and 3–10 for both keys after this pass.** The marked skeleton is preserved in §6 so a native Arabic speaker can close it in one edit.
2. **Whether the Android system-settings screen titles the reviewers reasoned from are the actual shipped strings.** None of the five is checkable from this repo. B2 rated confidence *high* for es/fr/pt/ru and *medium-high* for `ar`'s `المنبّهات والتذكيرات` — and `ar` is the one language where the finding turns on it (T-02). The independent argument stands regardless: `التنبيهات` collides with the app's own `الإشعارات` for notifications, so it points at the wrong screen whatever the exact Arabic title is.
3. **Rendered pixel widths at large text scale on a real device.** F-MECH-12's ratios are character counts, and "no hard overflow" is a code-reading conclusion (zero `maxLines: 1` / `softWrap: false` / `TextOverflow.*` anywhere in `lib/`; `ButtonBarWrap` measures with a `TextPainter` and stacks). The app was not launched. Phase 4 could confirm cheaply: `--flavor production` at maximum font scale in `ru` and `fr`, on the exact-alarms modal and the wizard news-signup button bar.
4. **Whether `gen-l10n` accepts an ICU plural branch that omits the placeholder.** A1's `ar` `resendVerificationCooldown` `zero` and `one` branches, and the `resendVerificationCountdown` `one`/`two` branches, do not interpolate `{seconds}`. This is legal ICU and `{seconds}` is still referenced in other branches, so C1 expects it to compile — but it was not built. **Phase 4 must confirm `flutter gen-l10n` is clean before this is considered done.**
5. **Whether count ≥ 21 is reachable for `ru` `nRemindersSet`.** `nPeopleGroups` definitely is (the unfiltered IMB list far exceeds 21). Whether a user ever creates 21 reminders is unknown — but the defect class and the fix are identical, so it was fixed anyway.
6. **Whether `debug_screen.dart` / `gallery_screen.dart` are user-facing.** Both hold many English literals and both are routed **unconditionally** in `lib/router.dart:205,211`. Treated as developer tools reachable only by typing the route. If they ship as reachable UI, there is more un-localised text than this report accounts for.
7. **`forwardLabel` was judged against a widget, not a screen.** `ArrowButton` is instantiated only in the component gallery, so all five labels were validated against the paired `MaterialLocalizations.backButtonTooltip` rather than a shipping flow. Re-check when the arrow lands in real UI. The RTL arrow-direction bug (N-02) means Arabic in particular needs a second look then.
8. **Three renderings rest on composed or inferred forms rather than a glossary lookup**, by necessity, and are flagged so a human can overturn them cheaply without re-deriving the reasoning: `dailyPrayerCoverage` in all five languages (§6.4 froze the glossaries with only the superseded 24-hour form, so every language's string is *composed* from two glossaried halves); `fr` `partial` = `En partie` (the glossary is silent on adjective-vs-adverbial, and this is C1's one departure from B2's table — A-07); and `ar` `wizardWelcomeBody`, where C1 applied the script fix but deliberately left the verb `تساعدك` un-regendered because no Arabic reviewer ruled on the agreement.
9. **No terminology question was left unresolved and none was escalated to a human.** Every one was decided from the relevant glossary or, where a glossary was silent, from the nearest precedent — with the precedent recorded in the arbitration log (§5) or in the originating findings file's "decisions made where the glossary was silent" table. §8's "Raised for a human" contains English-source items only, as §2 requires.
