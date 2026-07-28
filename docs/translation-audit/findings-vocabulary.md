# Findings — vocabulary

**Agent:** B2 `vocabulary`
**Scope:** un-glossaried recurring app vocabulary (17 rows × 5 languages); `engaged` and
`partial` in their new grammatical roles; `dailyPrayerCoverage`; `.tsv` ↔ glossary
disagreements touching new content
**Glossaries consulted:** all five of
`../translation/translated-glossaries/glossary.{ar,es_ES,fr_FR,pt_PT,ru_RU}.md`, plus
`../translation/glossary.md` and all five `../translation/deepl-glossaries/{ar,es,fr,pt,ru}.tsv`
**Files read but not modified:** `lib/l10n/app_{en,ar,es,fr,pt,ru}.arb`,
`lib/components/cards/engagement_item.dart`,
`lib/components/settings/signed_up_email_tile.dart`,
`lib/screens/people_group_details_screen.dart`
**Nothing was edited.** `../translation/` was treated as read-only throughout.

**How to read the strength column:** `strong` = the decision rests on a specific section of
that language's own glossary and must not be overridden by a cross-language consistency
preference. `yieldable` = the decision rests on app precedent, platform terminology and
reasoning; a language reviewer who cites a specific glossary section overrides it (plan §8.3).

---

## Deliverable 1 — Canonical renderings for un-glossaried recurring vocabulary

### 1A · The grid (this is the binding table)

| # | Term (EN) | `ar` | `es` | `fr` | `pt` | `ru` |
|---|---|---|---|---|---|---|
| 1 | **feedback** — feature name (button, panel title) | التعليقات | Comentarios | Commentaires | Comentários | Отзывы |
| 2 | **feedback** — the thing submitted (one submission) | تعليق / تعليقاتك | comentario(s) | commentaire(s) | comentário(s) | отзыв |
| 3 | **exact alarms** | المنبّهات الدقيقة | alarmas exactas | alarmes exactes | alarmes exatos | точные будильники |
| 4 | **verification email** | رسالة التحقق | correo de verificación | e-mail de vérification | e-mail de verificação | письмо для подтверждения |
| 5 | **to verify** (verb / verbal noun) | التحقق (من) | verificar | vérifier | verificar | подтвердить / подтверждение |
| 6 | **verified** (status of an address) | تم التحقق | Verificado | Vérifié | Verificado | Подтверждён |
| 7 | **not verified** | لم يتم التحقق | Sin verificar | Non vérifié | Não verificado | Не подтверждён |
| 8 | **reminder** | تذكير · pl. التذكيرات | recordatorio | rappel | lembrete | напоминание |
| 9 | **profile** | الملف الشخصي | perfil | profil | perfil | профиль |
| 10 | **compliment** (feedback category) | إشادة | Elogio | Compliment | Elogio | Похвала |
| 11 | **suggestion** (feedback category) | اقتراح | Sugerencia | Suggestion | Sugestão | Предложение |
| 12 | **problem** (feedback category) | مشكلة | Problema | Problème | Problema | Проблема |
| 13 | **notifications** | الإشعارات | notificaciones | notifications | notificações | уведомления |
| 14 | **push notifications** | الإشعارات الفورية | notificaciones push | notifications push | notificações push | push-уведомления |
| 15 | **account** | حساب (حسابك) | cuenta | compte | conta | аккаунт |
| 16 | **inbox** | صندوق الوارد | bandeja de entrada | boîte de réception | caixa de entrada | почта (see 1B) |
| 17 | **subscription** (to the news list) | اشتراك | suscripción | inscription | inscrição | подписка |

Only **two** cells differ from what is in the `.arb` files today, both Arabic: row 3
(`المنبّهات` for `التنبيهات`) and row 10 (`إشادة` for `إطراء`). Everything else in this grid
is a ratification of the existing approved wording — recorded so that five reviewers do
not each substitute a synonym.

### 1B · Justification, per term

| # | Term | Basis | Strength |
|---|---|---|---|
| 1–2 | **feedback** | No glossary entry in any language; no ministry meaning. All five files already carry **one lexeme** with the feature name in the plural and the submitted item in the singular — `feedback`/`feedbackSubmit`/`feedbackTypeLabel`/`feedbackRateLimited`/`feedbackSuccessBody` agree in every locale. That lexeme is also the platform's own: Google's shipped rendering of *Send feedback* is `Enviar comentarios` (es), `Envoyer des commentaires` (fr), `Enviar comentários` (pt), `Отправить отзыв` (ru), `إرسال تعليقات` (ar). **Ratified as-is. Do not substitute** `opinión`/`valoración`, `avis`/`retour`, `opinião`, `обратная связь`, or `ملاحظات` — the English/target split the plan warns about is already solved by the singular/plural contrast, not by two different words. | yieldable, but binding on A1–A5 absent a glossary citation (there is none to find) |
| 3 | **exact alarms** | Android's own permission name (`SCHEDULE_EXACT_ALARM`), reachable only via **Settings → Apps → Special app access → Alarms & reminders**. The noun must be the one on that screen, or "allow exact alarms" is unfollowable. System screen names: es *Alarmas y recordatorios*, fr *Alarmes et rappels*, pt *Alarmes e lembretes*, ru *Будильники и напоминания*, ar *المنبّهات والتذكيرات*. Confidence that the app noun matches the system screen: **es/fr/pt high**, **ru high** (`будильник` is unambiguously Android's word for *alarm*; the collocation `точные будильники` reads slightly technical but is findable, which is the requirement), **ar medium-high** — see F-VOCAB-02. | yieldable (platform terminology), but *findability* is the deciding criterion, not naturalness |
| 4–7 | **verification email / verify / verified / not verified** | No glossary entry. All five files already use one noun for the email and one verb root for verifying across all six affected keys (`emailVerified`, `emailUnverified`, `resendVerification`, `resendVerification{Sent,Failed,Cooldown}`, `newsSignupSuccessBody`). Gender agreement was checked against the render site: `signed_up_email_tile.dart:106-108` puts the status label directly *beneath the literal address string*, with **no target-language noun in the same widget**. The implied head is therefore each file's own word for the address — `correo` (es), `e-mail` (fr/pt), `адрес` (ru, cf. `emailsLoadError` «ваши адреса») — all masculine, and all five current forms agree with it. Arabic sidesteps agreement entirely with a verbal status (`تم التحقق`), which is correct and needs no adjective. **No defect; ratified as-is.** ru `Подтверждён`/`Не подтверждён` also match the file's `ё` convention. | yieldable |
| 8 | **reminder** | No glossary entry. Every locale already uses one noun across all eleven reminder keys, and in all five it is the *same word Android uses on the Alarms & reminders screen* — which is a bonus the exact-alarm cluster depends on. Ratified. Arabic plural is `التذكيرات` (see F-VOCAB-08 for the one stale singular, out of scope). | yieldable |
| 9 | **profile** | Pre-existing approved key `profile` sets the precedent; new key `viewProfile` matches it in all five. Ratified. | yieldable |
| 10 | **compliment** | No glossary entry. Register must sit level with the other two chips (a neutral category name, not praise-as-flattery). `Elogio`/`Compliment`/`Elogio`/`Похвала` are all neutral. Arabic `إطراء` carries a *flattery/insincerity* tinge that `اقتراح` and `مشكلة` do not; `إشادة` (commendation) is the neutral register-matched form. | yieldable (F-VOCAB-04) |
| 11–12 | **suggestion / problem** | No glossary entry; all five current renderings are the standard neutral category nouns and fit the chip slot. Ratified. | yieldable |
| 13–14 | **notifications / push notifications** | `notifications` is set by the pre-existing approved key of the same name plus `notifications_{enabled,disabled}`, `notificationsEnabledStatus`, `notificationsHowToEnable`, `enableNotifications` — consistent in all five. For **push notifications** (needed only by the untranslated `enableNotificationsPromptBody`), use the platform form: the bare loanword `push` post-modifying the noun in es/fr/pt, `push-уведомления` (hyphenated) in ru, and `الإشعارات الفورية` in ar — **never** the calque `إشعارات الدفع` / `уведомления-толчки`. | yieldable |
| 15 | **account** | No glossary entry. `accountSectionTitle` is the only site. ru: `аккаунт` (consumer register, matches Google's ru) over `учётная запись` (enterprise register). Possessive register matches each file's established address form — fr `vous`, es `tú`, pt `você`, ar 2nd-person suffix. Ratified as-is in all five. | yieldable |
| 16 | **inbox** | No glossary entry. Two sites: `resendVerificationSent`, `newsSignupSuccessBody`. es/fr/pt/ar already use the mail-client term (Gmail's own: *bandeja de entrada* / *boîte de réception* / *caixa de entrada* / صندوق الوارد) consistently across both. **ru deliberately differs**: both strings say `почту` («проверьте/откройте почту»), not `Входящие`. That is the idiomatic Russian equivalent of the English sentence and is *internally consistent*, so it is ratified: **ru canonical = `почта` in running text; reserve `Входящие` for labelling a mail folder, which this app never does.** | yieldable |
| 17 | **subscription** | Glossary §9 "Sign up" is the nearest precedent and it explicitly sanctions *both* the subscribe and the register root ("Subscribe/register for daily prayer points"; fr «S'abonner/s'inscrire», es «Suscribirse/registrarse», ru «Подписаться/зарегистрироваться»). Each file has already picked one and stayed with it: fr `inscription` (matching `signUp` "S'inscrire" and `newsSignupSuccessTitle`), pt `inscrição`, es `suscripción` alongside `registrarse`, ru `подписка` alongside `регистрация`, ar `اشتراك`. All coherent. **Do not "harmonise" fr/pt to `abonnement`/`assinatura`** — that would break their own `signUp` verb, which *is* glossaried (§9 + `.tsv`). | strong (glossary §9 sanctions both roots; the per-file choice is fixed by the glossaried `sign up` verb) |

---

## Deliverable 2 — Glossary terms in a new grammatical role

### 2A · `engaged` — bare standalone marker label

**Render site (verified):** `people_group_details_screen.dart:162-166` puts `l.engaged`
into an `EngagementItem` as the caption under a tick icon, in the same `Wrap` as
`prayerStatus`, `adoptionStatus`, `crossCulturalWorkersPresent`,
`workInLocalLanguageAndCulture`, `discipleAndChurchMultiplication`, under the `H2` header
`engagementStatus`. So it is a **criterion caption with no visible head noun**; the implied
subject is the people group, and the correct gender/number is that of each language's
glossaried rendering of *people group*.

| Lang | Implied head (glossaried *people group*) | Current | **Exact form to use** | Glossary section | Verdict | Strength |
|---|---|---|---|---|---|---|
| `ar` | المجموعة الشعبية — **feminine** (glossary.ar.md §1 «المجموعة الشعبية»; the app's own `peopleGroup` = «مجموعة شعبية», not the `.tsv`'s «جماعة عرقية») | مُنخرَط | **مُنخرَطة** | glossary.ar.md §2 heading «الانخراط / المجموعة الشعبية المنخرطة»; the feminine form `مُنخرَطة` is directly attested in `ar.tsv` line 6 («جماعات عرقية غير مُنخرَطة») | **change** — F-VOCAB-03 | strong |
| `es` | grupo de personas — masculine (glossary.es_ES.md §1) | Comprometido | **Comprometido** (unchanged) | glossary.es_ES.md §2 heading «Compromiso / comprometido (grupo de personas)» | **OK — do not change** (F-VOCAB-05) | strong |
| `fr` | peuple — masculine (glossary.fr_FR.md §1) | Engagé | **Engagé** (unchanged) | glossary.fr_FR.md §2 heading «Engagement / engagé (peuple)» | OK | strong |
| `pt` | povo — masculine (glossary.pt_PT.md §1) | Engajado | **Engajado** (unchanged) | glossary.pt_PT.md §2 heading «Engajamento / povo engajado» | OK | strong |
| `ru` | народ — masculine (glossary.ru_RU.md §1) | Вовлечён | **Вовлечён** (unchanged) | glossary.ru_RU.md §2 heading «Вовлечение / вовлечённый (народ)» for the lexeme | OK | lexeme strong; short-vs-long form yieldable |

No language needs an article, and none has one today. Short-form vs long-form is a live
question only in Russian: the glossary heading gives the long attributive `вовлечённый`,
but as a bare caption a long-form adjective strands itself with no head noun, whereas the
short predicative `Вовлечён` parallels the already-approved sibling caption
`Межкультурные служители присутствуют`, which is likewise predicative. **Keep `Вовлечён`**
(masculine short form, agreeing with `народ`, `ё` per file convention). If A5 prefers
`Вовлечённый` on a glossary citation, C1 may take it — the lexeme is what matters.

**Important counter-ruling for A2 (Spanish).** Plan §6.5 names `es` "Comprometido" as the
likeliest defect because `glossary.md` (English) warns the engagement precision term must
not become generic "involvement"/"contact"/"commitment". **The Spanish glossary decides,
and it chose exactly this word.** `glossary.es_ES.md` §2 is titled *"Compromiso /
comprometido (grupo de personas)"*, its warning list is «participación» and «contacto» —
*not* «compromiso» — and §1 renders the whole family as *no comprometido /
subcomprometido / poco comprometido*. `es.tsv` line 14 agrees. Changing `es` `engaged` to
anything else would break its own glossary and desynchronise it from `engagementStatus`
("Estado del compromiso") and `peopleCommittedToPraying` ("Personas comprometidas con la
oración"). **`Comprometido` stays.**

### 2B · `partial` — screen-reader status

**Render site (verified):** `engagement_item.dart:50-69`. `l.partial` is the `label` of its
**own isolated `Semantics` node** wrapping the icon; the marker's visible caption is a
*separate* node. The code comment records why: a status word concatenated onto a longer
phrase was mis-spoken by TTS. TalkBack therefore utters `partial` **alone**, never adjacent
to a noun.

**Ruling: there is no agreement problem, in any language.** Plan §6.7's adverb-vs-adjective
question is moot — there is nothing in the utterance to agree with, and the thing whose
status is partial (the marker) has a different gender for every caption anyway
("Estado…" masc., "Multiplicación…" fem.), so no fixed agreement target exists. All five
current strings are correct as isolated status utterances:

| Lang | Current | Verdict | Note |
|---|---|---|---|
| `ar` | جزئي | OK | Isolated utterance; no agreement target. `جزئياً` would be equally acceptable — not worth churn on an a11y-only string. |
| `es` | Parcial | OK | `parcial` is gender-invariable — immune by construction. |
| `fr` | Partiel | OK | Unmarked masculine, the default for a bare status token. |
| `pt` | Parcial | OK | Gender-invariable. |
| `ru` | Частично | OK | Adverbial and invariable — arguably the *best* of the five, since `yes`/`no` are likewise bare invariable tokens (`Да`/`Нет`). |

Nothing must imply the *people* are half-hearted; none of the five does — each reads as a
partly-met threshold, which is what the `@partial` description specifies.
Strength: **strong** (grounded in the render site, not in taste).

---

## Deliverable 3 — `dailyPrayerCoverage`

Composed from each language's glossaried **daily prayer ★** term plus its glossary's own
*coverage* entry, honouring the constraint that coverage means *uninterrupted prayer
through the day* and must never read as insurance or legal cover.

| Lang | Glossaried *daily prayer* ★ | Glossaried *coverage* head noun | Current app string | **Verdict / final string** | Strength |
|---|---|---|---|---|---|
| `ar` | الصلاة اليومية (§3) | تغطية (§3 «تغطية الصلاة على مدار ٢٤ ساعة», §9) | تغطية الصلاة اليومية | **Accept as-is** | strong |
| `es` | oración diaria (§3) | cobertura (§3, §9) | Cobertura de oración diaria | **Accept as-is** | strong |
| `fr` | prière quotidienne (§3) | couverture (§3 «Couverture de prière 24h/24», §9) | Couverture de prière quotidienne | **Accept as-is** | strong |
| `pt` | oração diária (§3) | cobertura (§3, §9) | Cobertura de oração diária | **Accept as-is** | strong |
| `ru` | ежедневная молитва (§3) | **охват** (§3 «24-часовой молитвенный охват», §9) — **not** покрытие | Ежедневное молитвенное покрытие | **REPLACE → `Ежедневный молитвенный охват`** | strong — F-VOCAB-01 |

**On the calque worry.** The brief flags fr *couverture*, es/pt *cobertura*, ru *покрытие*
as carrying insurance readings. For four of the five that worry is already settled *against*
me by the glossaries themselves: `glossary.fr_FR.md` §3, `glossary.es_ES.md` §3,
`glossary.pt_PT.md` §3 and `glossary.ar.md` §3 each **chose** couverture / cobertura /
cobertura / تغطية *and then wrote the insurance warning underneath it* — i.e. native
reviewers weighed the polysemy, accepted the word in a *prayer* collocation where the
insurance sense does not arise, and told translators to keep it from drifting. Per plan §2
the glossary outranks my judgement, and there is no residual defect. Building the daily
form is then purely mechanical: swap the 24-hour modifier for the glossaried *daily*
adjective, agreeing with the head — `quotidienne` (f., agreeing with `prière`), `diaria`,
`diária`, `اليومية`.

**Russian is the exception, and it is not a calque problem — it is the wrong head noun.**
`glossary.ru_RU.md` chose `охват`, in the §3 entry title, in the §3 example, in the §3
warning ("avoid reading *охват* as an insurance or legal term") and in the §9 label table.
`ru.tsv` line 40 says `покрытие` and therefore loses to the glossary (plan §2.2). And
`покрытие` is the specific word the warning exists to prevent: *страховое покрытие* is the
standard Russian for insurance coverage, *покрытие сети* is network coverage, and
*молитвенное покрытие* is an established Russian evangelical idiom meaning **spiritual
covering/protection over a person** — a different doctrine from "144 intercessors so the
day is continuously prayed through". Under a progress bar counting committed intercessors,
that reading makes the number incoherent. Word order follows the glossary's own pattern
(modifier + `молитвенный` + head): **`Ежедневный молитвенный охват`**.

This is a translation decision for the app. **No glossary change is proposed or implied.**

---

## Deliverable 4 — `.tsv` ↔ glossary disagreements touching new content

Severity **Note** in every case: `../translation/` is read-only and nothing there will be
changed. Listed so reviewers who reach for the fast `.tsv` index do not import a term the
prose glossary already overruled.

| # | Lang | English term | `.tsv` says | Glossary prose says | Which the app should use | New keys affected |
|---|---|---|---|---|---|---|
| 1 | `ru` | 24-hour prayer coverage | круглосуточное молитвенное **покрытие** (`ru.tsv:40`) | 24-часовой молитвенный **охват** (§3 title, §3 example, §3 warning, §9 table) | **glossary — охват** | `dailyPrayerCoverage` (drives F-VOCAB-01) |
| 2 | `es` | 24-hour prayer coverage | cobertura **de** oración de 24 horas (`es.tsv:40`) | *Cobertura **en** oración las 24 horas* (§3 title, §9 label table) — but §3's own example text says «cobertura de oración de 24 horas» | **`de`** for the app: `en` works only with the adverbial «las 24 horas»; with the adjective *diaria* modifying *oración*, `de` is required. Both forms are glossary-attested, so no defect either way. | `dailyPrayerCoverage` |
| 3 | `ar` | people group | جماعة عرقية (`ar.tsv:1`) | المجموعة الشعبية (§1 throughout, §9 «اختر مجموعة شعبية») | **glossary** — and the app already complies (`peopleGroup` = «مجموعة شعبية») | fixes the gender of `engaged`; also `prayForPeopleGroupLabel`, `prayerReminderBody` |
| 4 | `ar` | unengaged (people group) | غير مُنخرَط (`ar.tsv:13`) | غير مُتواصَل معها (§1) — while §2 keeps الانخراط / المنخرطة for engagement/engaged | Two competing families exist in Arabic. For `engaged` / `engagementStatus` use the **الانخراط family** (§2), which is what the app already does. Do not mix «مُتواصَل» into the engagement-marker cluster. | `engaged` |
| 5 | `es` | people group | grupo étnico (`es.tsv:1`) | grupo de personas (§1 title and throughout) | **glossary**; app already complies | referent for `engaged` agreement |
| 6 | `pt` | people group | grupo étnico (`pt.tsv:1`) | povo (§1 title «Povo ★», §9 «Escolhe um povo») | **glossary**; app already complies | referent for `engaged` agreement |
| 7 | `ru` | people group | этническая группа (`ru.tsv:1`) | народ (§1 title, §9 «Выбрать народ») | **glossary**; app already complies | referent for `engaged` agreement |
| 8 | `fr` | people group / engaged | peuple / engagé | peuple / engagé | no disagreement | — |
| 9 | all | sign up | matches §9 in all five | matches | no disagreement; `signUp` uses the glossaried form in all five (ar «التسجيل», es «Registrarse», fr «S'inscrire», pt «Inscrever-se», ru «Зарегистрироваться») | `signUp`, `newsSignupSuccess*` — **all OK** |

---

## Findings

### F-VOCAB-01 · Blocker · C1 glossary fidelity
- **Key:** `dailyPrayerCoverage`
- **Language:** `ru`
- **English:** "Daily prayer coverage"
- **Current:** "Ежедневное молитвенное покрытие"
- **Proposed:** "Ежедневный молитвенный охват"
- **Glossary ref:** `glossary.ru_RU.md` §3 «24-часовой молитвенный охват» (entry title, example and warning) and §9 label table, both of which use `охват`; §3 «Ежедневная молитва ★» for the modifier. `ru.tsv:40` («покрытие») is the derived index and loses to the prose (plan §2.2).
- **Why:** `покрытие` is the exact failure mode the glossary's own warning exists to prevent. *Страховое покрытие* is standard Russian for insurance coverage and *покрытие сети* for network coverage; worse, *молитвенное покрытие* is an established Russian evangelical idiom for **spiritual covering/protection over an individual**. Under a progress bar that counts intercessors toward continuous daily prayer for a people group, that reading makes the metric incoherent and changes what Doxa is claiming — from "the day is prayed through without a gap" to "a person is spiritually covered". `охват` is the glossary's chosen head noun and carries the intended *reach across the whole day* sense. Word order mirrors the glossary's own «24-часовой молитвенный охват».

### F-VOCAB-02 · Major · exact-alarms cluster / platform findability
- **Keys:** `allowExactAlarms`, `exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`
- **Language:** `ar`
- **Current:** «السماح بالتنبيهات الدقيقة» · «التنبيهات الدقيقة غير مسموح بها لتطبيق Doxa، لذا قد تصل تذكيرات الصلاة متأخرة بعدة دقائق.» · «لكي تصل تذكيرات الصلاة في وقتها تمامًا، اسمح لتطبيق Doxa باستخدام التنبيهات الدقيقة.»
- **Proposed:**
  - `allowExactAlarms` → «السماح بالمنبّهات الدقيقة»
  - `exactAlarmsDisabledStatus` → «المنبّهات الدقيقة غير مسموح بها لتطبيق Doxa، لذا قد تصل تذكيرات الصلاة متأخرة بعدة دقائق.»
  - `exactAlarmsPromptBody` → «لكي تصل تذكيرات الصلاة في وقتها تمامًا، اسمح لتطبيق Doxa باستخدام المنبّهات الدقيقة.»
- **Glossary ref:** none — un-glossaried platform term. Decided from Android's own terminology (plan §5.3.1) and from the app's existing approved vocabulary.
- **Why:** `allowExactAlarms` is the button that opens Android's **Alarms & reminders** special-app-access screen, so the noun has to be the one printed there or the instruction cannot be followed. Arabic for *alarm (clock)* on that screen is `منبّه` (pl. `المنبّهات`); `تنبيه` means *alert/notice*. The app already spends `الإشعارات` on **notifications**, so `التنبيهات` is a third word that maps to neither the notifications screen nor the alarms screen — a user told «اسمح بالتنبيهات الدقيقة» will most likely go hunting in the notifications settings, which is precisely the wrong screen. `المنبّهات` also keeps the pairing with `التذكيرات` (reminders) that the system screen name uses.
- **Confidence:** medium-high on `المنبّهات` being Android's Arabic word for alarms; high that `التنبيهات` is wrong here given the app's own use of `الإشعارات`. Severity is Major, not Blocker: the surrounding sentences still explain the intent.

### F-VOCAB-03 · Major · C5 grammar & agreement
- **Key:** `engaged`
- **Language:** `ar`
- **English:** "Engaged"
- **Current:** "مُنخرَط"
- **Proposed:** "مُنخرَطة"
- **Glossary ref:** `glossary.ar.md` §2, heading «الانخراط / المجموعة الشعبية المنخرطة» (feminine); §1 treats المجموعة الشعبية as feminine throughout («غير مُتواصَل معها»). The feminine vocalised form `مُنخرَطة` is directly attested in `ar.tsv:6`.
- **Why:** the label is a criterion caption whose implied subject is `المجموعة الشعبية`, which is feminine — as the app's own `peopleGroup` («مجموعة شعبية») and `engagementStatus` («حالة الانخراط») confirm. The masculine `مُنخرَط` fails agreement with the only noun it can be predicated of. `مُنخرَطة` keeps the glossaried `الانخراط` root, so the missiological precision the English glossary insists on is preserved.
- **Note for D1:** the ar glossary is internally inconsistent here — §6 once writes «منخرطاً معها» (masculine) of a feminine noun. §2's heading is the clean form and is what this ruling cites.

### F-VOCAB-04 · Minor · C4 register
- **Key:** `feedbackTypeCompliment`
- **Language:** `ar`
- **English:** "Compliment"
- **Current:** "إطراء"
- **Proposed:** "إشادة"
- **Glossary ref:** none — un-glossaried. Decided on register parity with the sibling chips.
- **Why:** `إطراء` leans toward *flattery* — praise with a hint of insincerity — where the other two chips (`اقتراح`, `مشكلة`) are flatly neutral category names. `إشادة` (*commendation*) is the neutral, register-matched form and reads correctly as "positive feedback" per the `@feedbackTypeCompliment` description. Same length class, so no chip-overflow risk. Yieldable: if A1 prefers `ثناء` or `مدح`, either is acceptable; `إطراء` is the one to move away from.

### F-VOCAB-05 · Note · counter-ruling on plan §6.5
- **Key:** `engaged`
- **Language:** `es`
- **Current / Proposed:** "Comprometido" → **"Comprometido" (no change)**
- **Glossary ref:** `glossary.es_ES.md` §2, heading «Compromiso / comprometido (grupo de personas)»; §1 «Grupo de personas no comprometido», «poco comprometido», «subcomprometido»; §9 label table; `es.tsv:14`.
- **Why this is filed as a finding at all:** plan §6.5 names Spanish as "the likeliest defect", reasoning from the *English* glossary's warning against generic "commitment". Per plan §2 the **Spanish** glossary decides, and it selected `compromiso/comprometido` as the precision term for the whole engagement family — its warning list is «participación» and «contacto», not «compromiso». Changing it would break the file's own `engagementStatus` ("Estado del compromiso") and `peopleCommittedToPraying` ("Personas comprometidas con la oración"), and desynchronise the app from the Spanish website. Filed so A2 does not "fix" a correct string. Agreement is also right: `grupo` is masculine singular.

### F-VOCAB-06 · Note · counter-ruling on plan §6.7
- **Key:** `partial`
- **Languages:** all five
- **Current / Proposed:** no change in any language.
- **Why:** verified at the render site. `engagement_item.dart:50-69` gives the status word its **own** `Semantics` node, deliberately separated from the caption (the code comment records the TTS bug that forced the split). TalkBack utters it alone, so there is no noun to agree with — and the markers it can describe have mismatched genders anyway ("Estado…" masc., "Multiplicación…" fem.), so no fixed agreement target exists. ru's adverb `Частично` and the Romance adjectives are therefore equally valid; `parcial` is gender-invariable in es/pt, and fr `Partiel` is the unmarked default. Nothing implies the people are half-hearted. Filed to close the question rather than have A5 re-litigate it.

### F-VOCAB-07 · Note · slot length, verification cluster
- **Key:** `resendVerification`
- **Language:** `ru`
- **Current:** "Отправить письмо для подтверждения ещё раз" (41 chars vs 26 in English, ≈1.6×)
- **Proposed if B1 confirms overflow:** "Отправить письмо повторно" — keeps the cluster noun `письмо` and drops only the analytic "для подтверждения", which the adjacent `emailUnverified` status already supplies.
- **Why:** this app has shipped button-bar overflow bugs (`344ff12`, `1d10434`) and this is a `btn`-slot string with the longest expansion ratio in the verification cluster. Terminology is correct as it stands — this is a length observation for B1/C1, not a vocabulary defect. Do not apply unless B1's length check flags it.

### F-VOCAB-08 · Note · out of scope, reminder cluster
- **Key:** `reminders` (pre-existing, not in the §4 scope list)
- **Language:** `ar`
- **Current:** "تذكير" (singular) for a screen titled "Reminders"
- **Canonical:** the plural is `التذكيرات`, which is what every other Arabic reminder string uses (`لا توجد تذكيرات حتى الآن`, `تذكيرات الصلاة`) and what Android's own screen name uses.
- **Why:** recorded only so the reminder-cluster canonical form in table 1A is unambiguous. Out of scope for Phase 3 per plan §2 hard rules; raise separately.

### F-VOCAB-09 · Note · non-translatable violation, out of scope
- **Key:** `reminderNotificationBody` (pre-existing, not in the §4 scope list)
- **Language:** `ar`
- **Current:** «افتح كتاب «دوكسا» لبدء صلاة اليوم.»
- **Why:** this both **transliterates** Doxa as «دوكسا» and **reclassifies** it as «كتاب» (*a book*) — the app is not a book. Plan §5.2.8 requires `Doxa` to appear untranslated and unscripted in every language, Arabic included, and every other Arabic string in the file complies (`تطبيق Doxa`, `أخبار Doxa`). Out of scope for Phase 3; flagged for B1's non-translatable sweep and for a follow-up pass. Correct form would be «افتح تطبيق Doxa لبدء صلاة اليوم.».

### F-VOCAB-10 · Note · filed against `en`
- **Key:** `enableNotificationsPromptBody`
- **English:** "Enable notifications to also receive updates in push notifications."
- **Why:** the sentence is tautological — it uses *notifications* as both the thing being enabled and the channel, so a faithful translation reads as circular in all five languages. Several targets will naturally collapse it (e.g. "…to also receive these updates on your phone"). Per plan §2 English is not changed during this audit; recorded so C1 can put it in "Raised for a human" rather than have five reviewers each invent a different de-duplication. **This does not block translation:** A1–A5 should translate the English as written, using the canonical `push notifications` renderings in table 1A row 14, and C1 arbitrates any divergence.

---

## Verdict table

Scope for this agent is terms and clusters, not the 46 keys individually (A1–A5 own those).
Verdicts below are per term/cluster × language, plus the specific keys this agent files
against.

| Term / cluster | `ar` | `es` | `fr` | `pt` | `ru` | Finding |
|---|---|---|---|---|---|---|
| feedback (feature + item) | OK | OK | OK | OK | OK | — |
| exact alarms | **Major** | OK | OK | OK | OK | F-VOCAB-02 |
| verification email / verify / verified / not verified | OK | OK | OK | OK | Note (length) | F-VOCAB-07 |
| reminder | Note (out of scope) | OK | OK | OK | OK | F-VOCAB-08 |
| profile | OK | OK | OK | OK | OK | — |
| compliment | **Minor** | OK | OK | OK | OK | F-VOCAB-04 |
| suggestion | OK | OK | OK | OK | OK | — |
| problem | OK | OK | OK | OK | OK | — |
| notifications | OK | OK | OK | OK | OK | — |
| push notifications | canonical set | canonical set | canonical set | canonical set | canonical set | table 1A row 14 |
| account | OK | OK | OK | OK | OK | — |
| inbox | OK | OK | OK | OK | OK (ru uses `почта` by design) | — |
| subscription | OK | OK | OK | OK | OK | — |
| `engaged` (new bare-label role) | **Major** | OK | OK | OK | OK | F-VOCAB-03, F-VOCAB-05 |
| `partial` (a11y status) | OK | OK | OK | OK | OK | F-VOCAB-06 |
| `dailyPrayerCoverage` | OK | OK | OK | OK | **Blocker** | F-VOCAB-01 |
| `signUp` / `newsSignupSuccess*` (glossaried) | OK | OK | OK | OK | OK | Deliverable 4 row 9 |
| `.tsv` ↔ glossary conflicts | Note | Note | none | Note | Note | Deliverable 4 |

**Strings this agent proposes changing: 6, across 5 keys and 2 languages.**
`ru:dailyPrayerCoverage` · `ar:allowExactAlarms` · `ar:exactAlarmsDisabledStatus` ·
`ar:exactAlarmsPromptBody` · `ar:engaged` · `ar:feedbackTypeCompliment`.

---

## Decisions made where the glossary was silent

| Term | Chosen rendering | Precedent applied | Strength |
|---|---|---|---|
| feedback (feature vs. item) | one lexeme per language, plural for the feature and singular for the submission — see 1A rows 1–2 | (b) the app's existing approved strings, which already do this consistently in all five; (c) Google's shipped rendering of *Send feedback* | yieldable |
| exact alarms | 1A row 3 — the noun printed on Android's **Alarms & reminders** screen in that locale | (c) platform terminology; findability is the deciding criterion, over naturalness | yieldable |
| verification email / verify / verified / not verified | 1A rows 4–7 | (b) app precedent, all six affected keys already agreeing per language; agreement checked against the render site (`signed_up_email_tile.dart:106-108`) rather than guessed | yieldable |
| reminder | 1A row 8 | (b) app precedent across eleven keys; (c) reinforced by the Android system screen name, which the exact-alarm cluster depends on | yieldable |
| profile | 1A row 9 | (b) pre-existing approved `profile` key | yieldable |
| compliment / suggestion / problem | 1A rows 10–12 | (b) register parity across the three sibling chips; only `ar:إطراء` deviates | yieldable |
| notifications / push notifications | 1A rows 13–14 | (b) pre-existing `notifications` family; (c) platform form of *push* — loanword post-modifier in es/fr/pt, hyphenated in ru, `الإشعارات الفورية` in ar | yieldable |
| account | 1A row 15 | (b) register of each file's own address form; (c) consumer register `аккаунт` for ru | yieldable |
| inbox | 1A row 16 | (c) each locale's mail-client term; ru deliberately uses `почта` in running text, consistently in both sites | yieldable |
| subscription | 1A row 17 | (a) **glossary §9 "Sign up"**, which sanctions both the subscribe and register roots; each file's choice is then fixed by its glossaried `signUp` verb | strong |
| `engaged` gender/number | agree with each glossary's rendering of *people group*: masc. in es/fr/pt/ru, **fem. in ar** | (a) each language's glossary §1 + §2 headings | strong |
| `engaged` ru short-vs-long form | short predicative `Вовлечён` | (a) glossary §2 for the lexeme; (b) app precedent — the sibling caption `Межкультурные служители присутствуют` is likewise predicative | lexeme strong, form yieldable |
| `partial` | no change in any language | render site: the status word is spoken in an isolated `Semantics` node, so no agreement target exists | strong |
| *daily* prayer coverage | glossaried *coverage* head noun + glossaried *daily prayer* ★ modifier, agreeing with the head | (a) each language's glossary §3 + §9. Four accept as-is; ru replaces `покрытие` with the glossary's `охват` | strong |
