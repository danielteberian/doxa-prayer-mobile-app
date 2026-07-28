# Findings — review-pt

**Agent:** review-pt (A4, Phase 1)
**Scope:** 46 keys, Portuguese
**Glossary consulted:** `../translation/translated-glossaries/glossary.pt_PT.md` (plus `../translation/glossary.md`, `../translation/deepl-glossaries/pt.tsv`)
**Keys verdicted:** 46 / 46
**Findings:** 2 Blocker · 1 Major · 11 Minor · 8 Note

> **Persistence note (orchestrator):** produced by the A4 subagent and persisted by the orchestrator, because subagents are blocked from writing findings files. Content is the agent's, unaltered in substance.
>
> **Characters to protect:** the §6.6 delimiter decision for pt-BR is **curly double quotes U+201C `“` and U+201D `”`** — never ASCII `"`, never guillemets `« »`. The guillemet-vs-curly distinction *is* the substance of that decision, so D4 must verify the codepoints before applying F-PT-08 … F-PT-14.

## Variant conclusion — the target is Brazilian Portuguese (pt-BR)

**The filename `glossary.pt_PT.md` is misleading. The glossary itself declares the target variant, and it is Brazilian.** Front matter, line 5: `language: Portuguese (Brazil-leaning)`, and the `note` block: *"A variante alvo é português com inclinação brasileira, priorizando a clareza para usuários do Brasil."* The glossary's own UI table (§9) uses Brazilian forms — **"Inscreva-se"** (pt-PT would be *Inscreve-te*), **"Entre em contato"** (pt-PT *Contacte-nos*), **"Ore, Contribua e Envie"**.

`app_pt.arb` is therefore correct to be Brazilian, and it is **internally consistent** — there is no variant clash and hence no Major finding on that axis. Every diagnostic form in the file lands on the same side:

| pt-BR form used | pt-PT form that is *not* used |
|---|---|
| `aplicativo` (×3), `Configurações`, `Salvar`, `Excluir`, `Compartilhar`, `Pular`, `Escaneie`, `Status` (×4), `Horário`, `e-mail`, `Sua conta`, `seus e-mails`, `toque no link` | *aplicação, definições, guardar, eliminar, partilhar, ignorar, digitalize, estado, hora, email, A sua conta, os seus emails, toque na ligação* |

Address form is uniformly **você** (never *tu*): "Você pode mudar isso depois", "no horário que você escolher", "Deus ouve você". Imperatives are uniformly the você-imperative (*Insira, Escolha, Toque, Verifique, Aguarde, Abra, Pressione, Ore*). Button labels are uniformly **infinitive** (*Continuar, Salvar e continuar, Voltar, Pular, Enviar comentários, Atualizar, Permitir, Ativar notificações*).

Everything below is judged against pt-BR. Nothing in this file should be "corrected" toward European Portuguese, and the `pt_PT` filename must not be read as a mandate to do so.

---

## Findings

### F-PT-01 · Blocker · missing key (§6.1)
- **Key:** `enableNotificationsButton`
- **English:** "Enable notifications"
- **Current:** *absent from `app_pt.arb` — falls back to English for every Portuguese user*
- **Proposed:** `"Ativar notificações"`
- **Glossary ref:** glossary silent (platform vocabulary, not ministry vocabulary); decided from in-file precedent
- **Why:** The key is missing entirely. Its English text is character-for-character identical to the already-approved `enableNotifications` key, which this file renders "Ativar notificações" — two different Portuguese strings for one English string would be an unforced inconsistency, so the existing rendering must be reused verbatim. Infinitive form matches the file's settled button style. Renders as a full-width `ActionButton` (`lib/components/notifications/enable_notifications_prompt.dart:89`), so length is not a constraint.

### F-PT-02 · Blocker · missing key (§6.1)
- **Key:** `enableNotificationsPromptBody`
- **English:** "Enable notifications to also receive updates in push notifications."
- **Current:** *absent from `app_pt.arb` — falls back to English for every Portuguese user*
- **Proposed:** `"Ative as notificações para receber as novidades também por notificações push."`
- **Glossary ref:** glossary silent; "novidades" taken from the approved `updatesFromDoxa` / `signUpForUpdates` / `wizardNewsSignupBody` cluster, which is this file's settled rendering of *updates / news*
- **Why:** The key is missing entirely. Context (`@description`): shown after the user signs up for updates, offering to *also* get them as push. The definite "as novidades" is deliberate — it points back at the updates the user has just subscribed to, which is what "also" carries in the English. `notificações push` is the standard Brazilian rendering and keeps `notificações` consistent with the approved `notifications` key. The repetition of "notificações" mirrors the English, which repeats it too. Centred body text above the button from F-PT-01, so 76 chars (1.12× English) is safe.

### F-PT-03 · Major · C4 register & consistency
- **Key:** `feedbackConsentLabel`
- **English:** "Keep me updated with news from Doxa"
- **Current:** `"Mantenha-me atualizado com as novidades da Doxa"`
- **Proposed:** `"Quero receber novidades da Doxa"`
- **Glossary ref:** glossary silent on consent phrasing; decided from the two approved sibling checkbox labels
- **Why:** This is a `CheckboxField` label (`lib/components/widgets/feedback_form.dart:159`) — the *same widget* as the approved `updatesFromDoxa` ("Receber novidades da Doxa") and `updatesAboutMyPeopleGroup` ("Receber novidades sobre meu povo") at `lib/components/widgets/news_signup.dart:162,170`. Those two use a non-imperative consent voice; this one uses an imperative reflexive ("Mantenha-me atualizado"), which reads as an *instruction addressed to the app* rather than a declaration of consent by the user — the opposite of what a consent tick-box must express, and the plan flags this key as needing unambiguous consent wording (§4.1). Two identical widgets in the same app expressing consent in two different grammatical voices is the register clash. "Quero receber novidades da Doxa" is the standard Brazilian consent formula, preserves the first-person voice of the English "me", stays distinguishable from `updatesFromDoxa`, and is 15 chars shorter than the current string. Also note the gendered "atualizado" in the current string, which mis-genders every female user; the proposal has no gendered agreement at all.

### F-PT-04 · Minor · C1 glossary fidelity / C4 consistency
- **Key:** `prayerReminderTitle`
- **English:** "Ready for today's prayer?"
- **Current:** `"Tudo pronto para orar hoje?"`
- **Proposed:** `"Tudo pronto para a oração de hoje?"`
- **Glossary ref:** glossary.pt_PT.md §3 "Oração diária (por um povo) ★" — *"'Diária' é intencional … Evitar traduzir como 'oração regular' ou 'oração ocasional'"*
- **Why:** Not wrong, but it weakens the daily-commitment frame the plan requires of this key (§4.1: "must read as the *daily* commitment, not a casual nudge"). "orar hoje" is an open-ended *pray at some point today*; "a oração de hoje" names the defined daily act the user has committed to. This file already uses exactly that collocation for the same concept in the approved `reminderNotificationBody` ("Abra o Doxa para começar **a oração de hoje**."), so the change also buys banner/notification cohesion. **Keep the "Tudo pronto" opening** — it is a deliberate and good choice: the bare "Pronto para…?" would gender the reader masculine, whereas "Tudo pronto" makes *tudo* the subject and stays gender-neutral. Do not "simplify" it.

### F-PT-05 · Minor · C5 grammar & naturalness
- **Key:** `feedbackIntro`
- **English:** "We'd love to hear from you. Tell us what you think of the app."
- **Current:** `"Adoraríamos ouvir você. Conte-nos o que acha do aplicativo."`
- **Proposed:** `"Adoraríamos ouvir você. Conte-nos o que você acha do aplicativo."`
- **Glossary ref:** n/a (no glossaried term); C5 naturalness against the file's own register
- **Why:** Brazilian Portuguese keeps the subject pronoun in this construction; the bare "o que acha" is a European-leaning ellipsis and reads clipped next to the rest of the file, which consistently spells the pronoun out ("Deus ouve **você**", "**Você** pode mudar isso depois", "no horário que **você** escolher"). Purely a naturalness fix — meaning is already correct.

### F-PT-06 · Minor · C3 standalone sense
- **Key:** `feedbackSuccessBody`
- **English:** "Your feedback was sent as {email}. If that isn't the right address, send it again with the correct one."
- **Current:** `"Seus comentários foram enviados como {email}. Se não for o endereço correto, envie-os novamente com o endereço certo."`
- **Proposed:** `"Seus comentários foram enviados como {email}. Se esse não for o endereço certo, envie-os novamente com o correto."`
- **Glossary ref:** n/a; C3 read-it-cold check
- **Why:** Two small things. (1) "Se não for o endereço correto" has no subject, so read cold it can attach to the wrong thing ("if *sending it* isn't the right address…"); the English pins it with "that", and "esse" restores it. (2) "o endereço correto … o endereço certo" repeats the noun and then swaps synonyms for no reason, which reads like a machine hedge; "com o correto" is the natural Brazilian ellipsis. Placeholder `{email}` unchanged and correctly positioned; the plural pronoun "-os" correctly agrees with "comentários".

### F-PT-07 · Minor · C5 grammar & naturalness
- **Key:** `resendVerificationSent`
- **English:** "Verification email sent. Check your inbox."
- **Current:** `"E-mail de verificação enviado. Verifique sua caixa de entrada."`
- **Proposed:** `"E-mail de verificação enviado. Confira sua caixa de entrada."`
- **Glossary ref:** n/a; C5
- **Why:** "verificação … Verifique" in one short SnackBar is an unintended echo of the same root two words apart, and it also invites the misreading *verify your inbox*. "Confira sua caixa de entrada" is the idiomatic Brazilian phrasing for "check your inbox" and removes the collision. The noun phrase "e-mail de verificação" is kept — it is the settled cluster term shared with `resendVerification` and the approved `newsSignupSuccessBody`, per §4.3.

### F-PT-08 · Minor · C6 placeholders (§6.6)
- **Key:** `prayForPeopleGroupLabel`
- **English:** "Pray for {peopleGroup}"
- **Current:** `"Orar por {peopleGroup}"`
- **Proposed:** `"Orar por “{peopleGroup}”"`
- **Glossary ref:** glossary silent on typography; convention chosen per §6.6 (see the glossary-silent decisions table)
- **Why:** §6.6 standing decision: every name-like placeholder in a file carries that language's delimiter convention uniformly. `app_pt.arb` currently has none anywhere, so this reviewer picks the Brazilian standard — the curly double quotation marks **“ ” (U+201C / U+201D), no inner spaces** — *not* guillemets, which are the European Portuguese tradition and would clash with the pt-BR variant this file targets. The infinitive "Orar" is right for a control label and consistent with the approved `pray` key; only the delimiters change. *Caveat for C1:* this key is screen-reader-only. TalkBack pt-BR does not speak quotation marks at default verbosity, so this is harmless, but it is also typographically pointless in a spoken-only string — if C1 would rather exempt a11y-only labels from §6.6, this finding is the one to drop. Applying it costs nothing.

### F-PT-09 · Minor · C6 placeholders (§6.6)
- **Key:** `prayerReminderBody`
- **English:** "Tap to pray for {peopleGroup}."
- **Current:** `"Toque para orar por {peopleGroup}."`
- **Proposed:** `"Toque para orar por “{peopleGroup}”."`
- **Glossary ref:** §6.6; convention as in F-PT-08
- **Why:** Same convention, applied uniformly. This one is a *visible* banner body, where the quotes do real work — they fence an interpolated proper name off from the surrounding sentence. Sentence-final period stays outside the closing quote, which is correct Brazilian practice for a quoted fragment rather than a quoted sentence.

### F-PT-10 · Minor · C6 placeholders (§6.6, approved key)
- **Key:** `peopleGroupIntroTitle`
- **English:** "Pray for the {name}"
- **Current:** `"Ore por {name}"`
- **Proposed:** `"Ore por “{name}”"`
- **Glossary ref:** §6.6 — one of the seven keys where implementation may touch an approved string
- **Why:** Uniform application of the delimiter convention. Only the quotes change; the imperative "Ore" is correct for a section heading and is left alone.

### F-PT-11 · Minor · C6 placeholders (§6.6, approved key)
- **Key:** `scanToPray`
- **English:** "Scan to get the app and pray for the {name}"
- **Current:** `"Escaneie o código para baixar o aplicativo e orar por {name}"`
- **Proposed:** `"Escaneie o código para baixar o aplicativo e orar por “{name}”"`
- **Glossary ref:** §6.6
- **Why:** Uniform application of the delimiter convention. Nothing else changes.

### F-PT-12 · Minor · C6 placeholders (§6.6, approved key)
- **Key:** `shareMessage`
- **English:** "Pray with me for the {name} — get the Doxa Prayer app:"
- **Current:** `"Ore comigo por {name} — baixe o aplicativo Doxa Prayer:"`
- **Proposed:** `"Ore comigo por “{name}” — baixe o aplicativo Doxa Prayer:"`
- **Glossary ref:** §6.6
- **Why:** Uniform application of the delimiter convention. This string is shared into WhatsApp/SMS as plain text; curly quotes are safe there. The em dash and the product name `Doxa Prayer` are untouched.

### F-PT-13 · Minor · C6 placeholders (§6.6, approved key)
- **Key:** `switchPeopleGroupConfirm`
- **English:** "Do you want to stop praying for {currentName} and start praying for {newName}?"
- **Current:** `"Você quer parar de orar por {currentName} e começar a orar por {newName}?"`
- **Proposed:** `"Você quer parar de orar por “{currentName}” e começar a orar por “{newName}”?"`
- **Glossary ref:** §6.6
- **Why:** Uniform application of the delimiter convention, and the key where it pays off most: two interpolated names in one question are much easier to tell apart when each is fenced. Both placeholder names stay spelled exactly as in `app_en.arb`.

### F-PT-14 · Minor · C6 placeholders (§6.6, approved key)
- **Key:** `wizardConfirmPeopleGroupTitle`
- **English:** "Pray for {name}?"
- **Current:** `"Orar por {name}?"`
- **Proposed:** `"Orar por “{name}”?"`
- **Glossary ref:** §6.6
- **Why:** Uniform application of the delimiter convention. Question mark stays outside the closing quote.

### F-PT-15 · Note · C1 glossary fidelity — `dailyPrayerCoverage` verified, no change
- **Key:** `dailyPrayerCoverage`
- **English:** "Daily prayer coverage"
- **Current:** `"Cobertura de oração diária"`
- **Proposed:** `"Cobertura de oração diária"` *(unchanged — confirmed correct)*
- **Glossary ref:** glossary.pt_PT.md §3 "Oração diária ★" (`oração diária`) + §3 "Cobertura de oração de 24 horas" and its warning *"Evitar que 'cobertura' seja lida como seguro ou cobertura legal; significa oração ininterrupta ao longo do dia"*; `pt.tsv` lines 39–40
- **Why (recorded because §6.4 requires the reasoning to be visible):** I scrutinised "cobertura" as instructed and am keeping it. The insurance sense of *cobertura* is real in isolation, but **the Portuguese glossary itself sanctions the collocation "cobertura de oração"** while carrying that exact warning — the warning is about not letting the reading drift, not a ban on the word, and the authority order puts the glossary above my instinct. The string composes the two glossaried pieces intact: `cobertura de oração` + the ★ term `oração diária`. The 24-hour form's structure (`cobertura de oração` + qualifier) is preserved with the qualifier swapped, which is precisely what §6.4 asks for now that the ministry goal is daily rather than 24-hour. The theoretical ambiguity of "diária" attaching to *cobertura* rather than *oração* is harmless — both readings deliver the same meaning. Context kills any insurance reading outright: the string is the caption under, and the a11y label of, a prayer progress bar announcing "N/144" intercessors (`lib/screens/people_group_details_screen.dart:390,410`), directly under "Pessoas comprometidas a orar". 26 chars, 1.24× English, centred full-card caption — no overflow risk.

### F-PT-16 · Note · C1 glossary fidelity — `engaged` verified, no change
- **Key:** `engaged`
- **English:** "Engaged"
- **Current:** `"Engajado"`
- **Proposed:** `"Engajado"` *(unchanged — confirmed correct)*
- **Glossary ref:** glossary.pt_PT.md §2 "Engajamento / povo engajado" (and §1 "Não engajado (povo) ★", "povos não engajados", §1 "Sub-engajado ★"); `pt.tsv` line 14 `engaged → engajado`
- **Why:** "Engajado" is **the glossaried form**, not a Brazilian slip — the Portuguese glossary uses the *engajar / engajamento / engajado* family throughout, including in the ★ seed entries, and the `.tsv` pairs it explicitly. It carries the precision sense the English glossary demands (resident, sustained, cross-cultural, CPM-oriented) and is not the vague "participação"/"contato" the glossary warns against. Contrast §6.5's worry about Spanish "Comprometido": Portuguese has no such problem, and note that this file correctly keeps *comprometido* for a **different** concept — `peopleCommittedToPraying` "Pessoas comprometidas a orar" — so the two senses stay distinct.
  **Agreement:** correct. Verified in code (`lib/screens/people_group_details_screen.dart:162-166`): when a group is engaged, the last three engagement markers collapse into one marker whose visible label is this string, under the heading `engagementStatus` "Status de engajamento". The implied noun is `peopleGroup` = "Povo", masculine singular, so masculine singular "Engajado" agrees. Reconciled with `engagementStatus`: same root, same family, no divergence. 8 chars in a 200 px-wide marker cell — no fit risk.

### F-PT-17 · Note · C5 grammar — `partial` verified, refutes §6.7 for Portuguese
- **Key:** `partial`
- **English:** "Partial"
- **Current:** `"Parcial"`
- **Proposed:** `"Parcial"` *(unchanged — confirmed correct)*
- **Glossary ref:** glossary silent (not a ministry term); judged as speech per §4.3
- **Why:** §6.7 asks whether the adjective can fail to agree with whatever it is uttered alongside. For Portuguese the question dissolves twice over. First, *parcial* is **invariable in gender** (parcial / parciais), so it cannot mis-agree with any marker noun. Second, the code deliberately utters it **in isolation**: the tick/cross icon gets its own `Semantics` node carrying only the status word, explicitly separated from the marker label to avoid a TTS defect — see the comment at `lib/components/cards/engagement_item.dart:61-65`. So TalkBack speaks "Parcial" as a standalone word after the label, never inside a phrase. Judged as speech it is clear, unabbreviated, and carries no punctuation artefact. It also cannot be heard as a slur on the people group: it describes the marker (some but not enough intercessors), and the neighbouring statuses it alternates with are `yes`/`no` = "Sim"/"Não". No change.

### F-PT-18 · Note · C4 consistency — `forwardLabel` verified, refutes §6.8 for Portuguese
- **Key:** `forwardLabel`
- **English:** "Forward"
- **Current:** `"Avançar"`
- **Proposed:** `"Avançar"` *(unchanged — confirmed correct)*
- **Glossary ref:** glossary silent; decided from the paired control in code
- **Why:** §6.8 suspects this says *next* rather than *forward*. For Portuguese that is not the defect it looks like. `Avançar` means *to advance / go forward*, not "next" (which would be "Próximo", as in the approved `nextDay` "Próximo dia"). Decisively, the code pairs it with the **platform's own** back label: `lib/components/buttons/arrow_button.dart:25-27` uses `MaterialLocalizations.backButtonTooltip` for the back arrow, which Flutter renders in Portuguese as **"Voltar"** — and *Voltar / Avançar* is the canonical Brazilian back/forward arrow pair (it is also what this file already uses for `back`). A literal "Para frente" or "Adiante" would be worse: correct but not what a Brazilian user expects to hear from a paired arrow. It does not collide with `continueLabel` ("Continuar"), which is a distinct wizard-progression control. No change.
  *(Reachability note for B1: `ArrowButton` is currently instantiated only in `lib/screens/gallery_screen.dart:358-359`, the component gallery.)*

### F-PT-19 · Note · C1 non-translatables — `Doxa` untranslated; the gender split is settled
- **Keys:** `exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`, `feedbackConsentLabel`
- **Current:** "…não são permitidos para **o** Doxa…", "…permita que **o** Doxa use…", "…novidades **da** Doxa"
- **Proposed:** *(unchanged in all in-scope keys)*
- **Glossary ref:** glossary.pt_PT.md §7 "DOXA" — *"Manter como nome próprio… não o traduzir"*; the same glossary consistently writes the organisation as **feminine**: "**A** DOXA foi fundada e é tutelada…", "**A** DOXA trabalha com as agências enviadoras", "missionários parceiros **da** DOXA" (§2, §4, §5, §7)
- **Why:** `Doxa` appears untranslated and unscripted in all three in-scope keys — no finding there. On the gender question I was asked to settle: **the apparent inconsistency is a systematic, defensible split, and I am keeping it.**
  - **`o Doxa` = the app** (ellipsis of *o aplicativo Doxa*), used wherever Doxa is the piece of software holding a permission or being opened: `exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`, and the approved `notificationsHowToEnable`, `reminderNotificationBody`.
  - **`a Doxa` = the ministry/organisation**, used wherever Doxa is the sender of news: `feedbackConsentLabel`, and the approved `updatesFromDoxa`, `wizardNewsSignupBody`. This is the glossary's own gender.

  Every in-scope key obeys the rule. The one arguable edge is the approved `wizardWelcomeBody` ("**A** Doxa ajuda você a orar…"), where the helper could be read as either the app or the ministry — the ministry reading is legitimate, so **no change is proposed** and the key is out of scope anyway. D4 must not "harmonise" the two articles into one; that would break the rule in one direction or the other.

### F-PT-20 · Note · C4 cluster consistency — exact-alarm wording vs the Android settings screen
- **Keys:** `allowExactAlarms`, `allow`, `exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`
- **Current:** `"Permitir alarmes exatos"` / `"Permitir"` / `"Os alarmes exatos…"` / `"…use alarmes exatos."`
- **Proposed:** *(unchanged — the cluster is coherent)*
- **Glossary ref:** glossary silent (platform vocabulary); decided on C2 fidelity
- **Why:** The cluster uses one noun, "alarmes exatos", across all four strings, and "Permitir" matches the verb Android pt-BR uses on its own permission dialogs — so no action. Recorded for C1 only: §4.3 suggests matching the Android *settings screen* title, which in pt-BR is **"Alarmes e lembretes"**, not "alarmes exatos". I chose not to propose that swap, because (a) it would drop the English's "exact", which is the whole point of the warning in `exactAlarmsDisabledStatus`, and (b) it would force restructuring all four strings, three of them prose, for a marginal wayfinding gain. If C1 rules the other way across all five languages, the pt change set would be `allowExactAlarms` → "Permitir alarmes e lembretes" and the two body strings reworded; I do not recommend it.

### F-PT-21 · Note · `.tsv` ↔ glossary disagreement on the core ★ term (no app action)
- **Affects:** the `peopleGroup` family, incl. `prayForPeopleGroupLabel`
- **English:** "people group"
- **Current:** the app uses **"Povo"** / "Povos" throughout (`peopleGroup`, `peopleGroups`, `nPeopleGroups`, `myPeopleGroupTitle`, `peopleGroupOfTheDay`)
- **Proposed:** *(no change — the app is right)*
- **Glossary ref:** glossary.pt_PT.md §1 "**Povo** ★ Termo fundamental" vs `pt.tsv` line 1 `people group → grupo étnico`
- **Why:** Reported as a Note only, since `../translation/` is read-only. The two sources disagree on the single most important ★ term: the reviewed glossary uses **povo** (its §1 heading, its examples "2 085 povos não engajados", its whole §1), while the DeepL `.tsv` pairs it to *grupo étnico*. Per §2 authority order the **glossary wins**, and `app_pt.arb` already follows the glossary. Flagged so that no later agent "fixes" the app toward the `.tsv`, and so C1 knows the pt `.tsv` cannot be trusted as a standalone index for this term.

### F-PT-22 · Note · C7 fits the slot — `signUp` / `skip` button bar
- **Key:** `signUp`
- **English:** "Sign up"
- **Current:** `"Inscrever-se"`
- **Proposed:** `"Inscrever-se"` *(unchanged — confirmed correct)*
- **Glossary ref:** glossary.pt_PT.md §9 "**Inscreva-se** — Assinar/registrar para pontos de oração diários"; `pt.tsv` line 86 `sign up → inscrever-se`
- **Why:** The glossaried term family was used, so C1 is satisfied. The infinitive "Inscrever-se" (rather than the glossary's imperative "Inscreva-se") is the right inflection for this slot — it is a button, and this file's buttons are uniformly infinitive; it is also exactly what Brazilian users see on mainstream apps. Consistency downstream is intact: `newsSignupSuccessTitle` "Obrigado por se **inscrever**!", `newsSignupSuccessBody` "confirmar sua **inscrição**", `signUpForUpdates` "**Inscreva-se** para receber novidades". Recorded for B1's length check only: 12 chars is 1.71× the English "Sign up", and it sits in a `ButtonBarWrap` next to `skip` "Pular" (`lib/components/wizard/wizard_step_news_signup.dart:93-105`) — the widget family that produced the overflow bug in `344ff12`. Combined pair is 17 chars vs 11 in English, which the wrapping bar handles; no shorter faithful alternative exists, so no change is proposed.

---

## Verdict table

46 / 46 in-scope keys verdicted. `OK` means checked against C1–C7 and correct as it stands. Findings F-PT-10 … F-PT-14 target five **approved** keys under the §6.6 exemption and so have no row here.

| Key | Verdict | Finding |
|---|---|---|
| `accountSectionTitle` | OK | — |
| `allow` | OK | F-PT-20 (note) |
| `allowExactAlarms` | OK | F-PT-20 (note) |
| `clearSearchLabel` | OK | — |
| `dailyPrayerCoverage` | OK | F-PT-15 (note) |
| `dismissReminderLabel` | OK | — |
| `emailUnverified` | OK | — |
| `emailVerified` | OK | — |
| `emailsLoadError` | OK | — |
| `enableNotificationsButton` | **Blocker** | F-PT-01 |
| `enableNotificationsPromptBody` | **Blocker** | F-PT-02 |
| `engaged` | OK | F-PT-16 (note) |
| `exactAlarmsDisabledStatus` | OK | F-PT-19, F-PT-20 (notes) |
| `exactAlarmsPromptBody` | OK | F-PT-19, F-PT-20 (notes) |
| `feedbackConsentLabel` | **Major** | F-PT-03 (+ F-PT-19 note) |
| `feedbackError` | OK | — |
| `feedbackIntro` | Minor | F-PT-05 |
| `feedbackMessageLabel` | OK | — |
| `feedbackMessageRequired` | OK | — |
| `feedbackNameLabel` | OK | — |
| `feedbackRateLimited` | OK | — |
| `feedbackSubmit` | OK | — |
| `feedbackSuccessBody` | Minor | F-PT-06 |
| `feedbackSuccessTitle` | OK | — |
| `feedbackTypeCompliment` | OK | — |
| `feedbackTypeLabel` | OK | — |
| `feedbackTypeProblem` | OK | — |
| `feedbackTypeRequired` | OK | — |
| `feedbackTypeSuggestion` | OK | — |
| `forwardLabel` | OK | F-PT-18 (note) |
| `newsSignupSuccessBody` | OK | — |
| `newsSignupSuccessTitle` | OK | — |
| `notNow` | OK | — |
| `partial` | OK | F-PT-17 (note) |
| `pictureCreditLabel` | OK | — |
| `prayForPeopleGroupLabel` | Minor | F-PT-08 |
| `prayerRecordedAnnouncement` | OK | — |
| `prayerReminderBody` | Minor | F-PT-09 |
| `prayerReminderTitle` | Minor | F-PT-04 |
| `resendVerification` | OK | — |
| `resendVerificationCooldown` | OK | — |
| `resendVerificationCountdown` | OK | — |
| `resendVerificationFailed` | OK | — |
| `resendVerificationSent` | Minor | F-PT-07 |
| `signUp` | OK | F-PT-22 (note) |
| `viewProfile` | OK | F-PT-21 (note, family only) |

### Why the remaining `OK`s are OK (one line each, for the keys with no finding)

- `accountSectionTitle` "Sua conta" — correct você-possessive, matches the file's "seus e-mails" / "sua caixa de entrada".
- `clearSearchLabel` "Limpar pesquisa" — natural as speech, consistent with `search` "Pesquisar".
- `dismissReminderLabel` "Dispensar lembrete" — same verb as approved `dismissNextReminder` "Dispensar o próximo"; one noun "lembrete" across the whole reminder cluster.
- `emailVerified` / `emailUnverified` "Verificado" / "Não verificado" — masculine, agreeing with *o e-mail*; polarity intact.
- `emailsLoadError` "Não foi possível carregar seus e-mails." — follows the file's settled `couldNotLoad*` pattern.
- `feedbackError` "Algo deu errado…" — byte-identical to the approved `newsSignupError`, whose English is also identical. Correct.
- `feedbackMessageRequired` / `feedbackTypeRequired` — match the approved validation style "Insira…" / "Escolha…" (`nameRequired`, `emailInvalid`).
- `feedbackRateLimited`, `feedbackSubmit`, `feedbackTypeLabel`, `feedbackTypeCompliment/Problem/Suggestion`, `feedbackMessageLabel`, `feedbackNameLabel` — one feedback noun, *comentário(s)*, used consistently and inherited from the approved `feedback` key; "Elogio" is the standard Brazilian word for a compliment; singular in "Que tipo de comentário?" is correct because it asks about one item.
- `feedbackSuccessTitle` "Obrigado!" — matches approved `prayerThankYouTitle` and `newsSignupSuccessTitle`; app-voice masculine is the Brazilian convention.
- `newsSignupSuccessTitle` / `newsSignupSuccessBody` — both use the `inscrever`/`inscrição` family settled by `signUp`; `{email}` intact.
- `notNow` "Agora não" — identical to approved `updateDismiss`, same English.
- `pictureCreditLabel` "Crédito da imagem" — clear spoken label.
- `prayerRecordedAnnouncement` "Oração registrada" — correct feminine agreement, natural as a spoken announcement.
- `resendVerification*` — one noun ("e-mail de verificação"), one verb ("reenviar"/"enviar"), `{seconds}` intact in both. The space in "{seconds} s" is deliberate and correct (SI/ABNT unit spacing); spelling out "segundos" was rejected because it would break at `{seconds}` = 1, which the flat (non-plural) English tolerates only because "1s" is idiomatic.
- `viewProfile` "Ver perfil" — matches approved `profile` "Perfil"; shorter than the English.

---

## Decisions made where the glossary was silent

| Term | Chosen rendering | Glossary precedent applied |
|---|---|---|
| Target variant | **Brazilian Portuguese (pt-BR)**, despite the `pt_PT` filename | glossary.pt_PT.md front matter `language: Portuguese (Brazil-leaning)` and its `note` block ("A variante alvo é português com inclinação brasileira"); confirmed by the glossary's own Brazilian UI labels in §9 ("Inscreva-se", "Entre em contato") |
| "Enable notifications" (button) | `Ativar notificações` | Not glossary-silent by accident — the identical English already exists as the approved `enableNotifications` key with this rendering; reused verbatim rather than invented (§5.1 C4, contract with pre-existing translations) |
| "push notifications" | `notificações push` | Nearest glossary precedent is §7 DOXA / §7 Pentecostal: established loanwords are kept rather than calqued. Keeps the head noun aligned with the approved `notifications` "Notificações" |
| "updates / news" (as a thing you subscribe to) | `novidades` | The file's approved cluster `updatesFromDoxa`, `signUpForUpdates`, `wizardNewsSignupBody`; glossary §3 reserves "pontos de oração" for the prayer content, so a separate word for marketing news is required and *novidades* is it |
| Marketing-consent voice on a checkbox | first-person declarative, `Quero receber …` — never an imperative | The two approved sibling `CheckboxField` labels (`updatesFromDoxa`, `updatesAboutMyPeopleGroup`) use a non-imperative voice; the glossary's §9 imperatives ("Inscreva-se", "Ore") are all *action buttons/CTAs*, not consent statements, so that precedent does not extend to tick-boxes |
| "coverage" in "daily prayer coverage" | `cobertura` — kept | glossary.pt_PT.md §3 sanctions the collocation "cobertura de oração" while itself carrying the do-not-read-as-insurance warning; the warning constrains the reading, it does not ban the word (see F-PT-15) |
| "feedback" (noun, the thing sent and the feature) | `comentário(s)` | The approved `feedback` key; §4.3 requires one settled rendering per cluster, and the approved key outranks a reviewer's preference for the loanword *feedback* |
| "exact alarms" | `alarmes exatos` | Glossary silent; resolved on C2 fidelity (the English names the permission "exact", which the warning strings depend on) over Android pt-BR's screen title "Alarmes e lembretes" — recorded as F-PT-20 for C1 to arbitrate cross-language |
| "verification email" | `e-mail de verificação` | The approved `newsSignupSuccessBody`, which predates the new keys |
| "reminder" | `lembrete` | The approved `reminders` / `newReminder` / `setReminder` family; used unchanged in every new reminder-cluster string |
| "profile" | `perfil` | The approved `profile` key |
| "compliment" | `Elogio` | No glossary hook; standard Brazilian noun, and short enough for a chip (6 chars vs 10 in English) |
| "Partial" (spoken) | `Parcial` | Glossary silent; chosen as gender-invariable so it cannot mis-agree, and verified against the code's isolated-utterance `Semantics` node (see F-PT-17) |
| "Forward" (arrow a11y label) | `Avançar` | Glossary silent; resolved from the paired control — Flutter's own pt `backButtonTooltip` is "Voltar", and *Voltar / Avançar* is the canonical Brazilian arrow pair (see F-PT-18) |
| Name-placeholder delimiter | **curly double quotes `“ ”` (U+201C / U+201D), no inner spaces** — applied to `{name}`, `{currentName}`, `{newName}`, `{peopleGroup}`; never to `{count}`, `{time}`, `{seconds}`, `{email}`, `{version}`, `{weekday}` | Glossary is silent on typography, so §6.6's standing decision applies: pick the one standard for the language. Guillemets `« »` are the *European* Portuguese tradition and would contradict the pt-BR variant established above; the Brazilian norm is `“ ”`. Portuguese, unlike French, uses no space inside the quotes |
| Gender of the proper noun `Doxa` | `o Doxa` = the app · `a Doxa` = the ministry | glossary.pt_PT.md §7 and §2/§4/§5 write the organisation feminine ("A DOXA", "da DOXA"); the masculine app usage is ellipsis of *o aplicativo Doxa*. Both already applied consistently in-file (see F-PT-19) |
| "people group" | `povo` (app is already correct) | glossary.pt_PT.md §1 "Povo ★" outranks `pt.tsv`'s "grupo étnico" per §2 authority order (see F-PT-21) |

---

## What this audit could not determine

Nothing was left unresolved: every one of the 46 keys has a verdict, and every finding carries a final Portuguese string ready to apply. Two items are flagged as *judgement calls for C1*, not as gaps — both are recorded above with my recommendation:

1. **F-PT-20** — whether the exact-alarm cluster should track Android's pt-BR settings screen title ("Alarmes e lembretes") instead of the English's "exact alarms". I recommend no change; the decision is cross-language and belongs to C1/B2.
2. **F-PT-08** — whether §6.6's placeholder delimiters should apply to screen-reader-only labels, where they are inaudible. I applied them as the plan directs; harmless either way.
