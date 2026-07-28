# Findings — review-ru

**Agent:** review-ru (A5)
**Scope:** 46 keys, Russian
**Glossary consulted:** ../translation/translated-glossaries/glossary.ru_RU.md (source of truth), ../translation/glossary.md (concepts), ../translation/deepl-glossaries/ru.tsv (index)
**Keys verdicted:** 46 / 46
**Severity counts:** 3 Blocker · 0 Major · 6 Minor · 4 Note (Notes are all out-of-scope observations)

> **Persistence note (orchestrator):** produced by the A5 subagent and persisted by the orchestrator, because subagents are blocked from writing findings files. Content is the agent's, unaltered in substance.

## House style established from the already-approved strings

- **Address form:** вы throughout, plural вы, never capitalised «Вы» (`noPeopleGroupSelected`, `wizardWelcomeBody`). All new strings use вы. ✔
- **Button style:** infinitive (`Сохранить`, `Удалить`, `Выбрать`, `Повторить попытку`, `Открыть настройки`), *not* imperative. Body prose uses imperative вы-forms (`Нажмите ниже, чтобы…`, `Откройте Doxa, чтобы…`). New buttons follow this. ✔
- **`ё`:** the file is a **`ё`-writing** file (`Вперёд`, `Подтверждён`, `ещё`, `своё`, `моём`). All new strings comply. One out-of-scope lapse — F-RU-12.
- **Guillemets:** `«…»` on name-like placeholders and quoted proper names (`Фильм «Иисус»`, `Нажмите «Назад» ещё раз`, `«Doxa Prayer»`). Never on numeric/technical placeholders (`{seconds}`, `{time}`, `{version}`, `{email}`, `{count}`, `{weekday}` all bare). New keys comply; one *approved* key breaks it — F-RU-10.
- **People-group head noun:** the file renders the ★ term as **`народ`** (`peopleGroup`, `peopleGroups`, `myPeopleGroupTitle`, `nPeopleGroups`), **not** the `.tsv`'s «этническая группа» — matching `glossary.ru_RU.md` §1 «Народ ★», which outranks the `.tsv`. Two approved strings place the head noun before the placeholder: `peopleGroupIntroTitle` «за народ «{name}»», `switchPeopleGroupConfirm` «за народ «{currentName}»». See F-RU-04/05.
- **`Doxa`:** always Latin, never transliterated. Bare `Doxa` for the organisation (`updatesFromDoxa`, `notificationsHowToEnable`); the *product* name normally guillemeted, «Doxa Prayer» (`shareMessage`, `wizardWelcomeTitle`, `updateAvailableBody`). Every new string uses the bare-organisation form, which is correct — no change needed. One approved inconsistency in F-RU-13.
- **Status captions:** bare short forms are the house pattern — approved `selected` = «Выбрано». This licenses `engaged` = «Вовлечён» and `emailVerified` = «Подтверждён».

## Findings

### F-RU-01 · Blocker · C2 meaning preserved (string absent)
- **Key:** `enableNotificationsButton`
- **English:** "Enable notifications"
- **Current:** *absent from `app_ru.arb`* — falls back to English at runtime
- **Proposed:** `Включить уведомления`
- **Glossary ref:** glossary.ru_RU.md silent (platform vocabulary); §9 precedent — UI action labels take the settled everyday local term.
- **Why:** §6.1. The English is identical to the already-approved `enableNotifications`, which the file renders «Включить уведомления». Reusing that exact string is required by C4 — two buttons with identical English must not read differently. Rendered by `ActionButton.fullWidth` (`lib/components/notifications/enable_notifications_prompt.dart:88`), so 20 characters has no slot risk.

### F-RU-02 · Blocker · C2 meaning preserved (string absent)
- **Key:** `enableNotificationsPromptBody`
- **English:** "Enable notifications to also receive updates in push notifications."
- **Current:** *absent from `app_ru.arb`* — falls back to English at runtime
- **Proposed:** `Включите уведомления, чтобы получать новости также в push-уведомлениях.`
- **Glossary ref:** glossary.ru_RU.md silent; §9 precedent for plain UI prose.
- **Why:** §6.1. Body prose, so the imperative вы-form «Включите» is correct per house style (`notificationsHowToEnable`), not the infinitive used on buttons. "updates" here means the news just signed up for, so it takes the file's settled **новости** (`updatesFromDoxa`), not «обновления», which the file reserves for app updates (`updateAvailableTitle`). `push-уведомления` is standard, hyphenated, Latin *push*. Shown centred above the button in the same widget — length fine.

### F-RU-03 · Blocker · C1 glossary fidelity
- **Key:** `dailyPrayerCoverage`
- **English:** "Daily prayer coverage"
- **Current:** `Ежедневное молитвенное покрытие`
- **Proposed:** `Ежедневный молитвенный охват`
- **Glossary ref:** glossary.ru_RU.md §3 «24-часовой молитвенный охват» (head noun **охват**, plus the explicit warning «Избегайте прочтения "охвата" как страхового или юридического термина; речь идёт о непрерывной молитве в течение всего дня») and §9 nav table, which repeats «24-часовой молитвенный охват». §3 «Ежедневная молитва ★» supplies the *daily* element.
- **Why:** The glossary — native-reviewed, source of truth — renders "prayer coverage" as **молитвенный охват** in both places it appears. The `.tsv` line `24-hour prayer coverage → круглосуточное молитвенное покрытие` is the only occurrence of «покрытие», and per §2 the `.tsv` loses to glossary prose. It loses on merits too: «покрытие» is the ordinary Russian word for insurance cover («страховое покрытие») and signal reach («зона покрытия») — precisely the two readings the glossary forbids. Under a progress bar counting intercessors toward a goal, «Ежедневное молитвенное покрытие» invites the "coverage area / policy cover" reading and misstates what Doxa measures. **The fix also changes the adjective ending: `охват` is masculine → «Ежедневный», not «Ежедневное».** Per §6.4 composed from the frozen glossary, not a glossary patch. 28 chars vs 31 — the caption slot (`lib/screens/people_group_details_screen.dart:390,410`, used both as the progress bar's `Semantics` label and the visible caption) gets shorter.

### F-RU-04 · Minor · C1 glossary fidelity / C4 consistency
- **Key:** `prayForPeopleGroupLabel`
- **English:** "Pray for {peopleGroup}"
- **Current:** `Помолиться за «{peopleGroup}»`
- **Proposed:** `Помолиться за народ «{peopleGroup}»`
- **Glossary ref:** glossary.ru_RU.md §1 «Народ (этнолингвистическая группа) ★»; §9 «Молитесь».
- **Why:** Case government is *sound either way* — «за» governs the accusative, the guillemeted insert is grammatically inert, and for an inanimate masculine noun the accusative equals the nominative, so the uninflected data string never disagrees. The defect is elsewhere: (a) the file's two comparable approved strings both name the head noun — `peopleGroupIntroTitle` «Помолитесь за народ «{name}»» and `switchPeopleGroupConfirm` — so omitting it breaks house style; (b) this is an **a11y label spoken by TalkBack** (`lib/components/misc/prayer_reminder_banner.dart:77`) and guillemets are *not* spoken, so the user hears bare «Помолиться за Кырк» — an IMB name with nothing marking it as a people group, easily heard as a person's name. Adding «народ» restores the glossary's ★ unit and gives the preposition a real head noun. The infinitive «Помолиться» is correct and stays: it's an action label on a `Semantics(button: true)` node, matching approved `wizardConfirmPeopleGroupTitle`.

### F-RU-05 · Minor · C1 glossary fidelity / C4 consistency
- **Key:** `prayerReminderBody`
- **English:** "Tap to pray for {peopleGroup}."
- **Current:** `Нажмите, чтобы помолиться за «{peopleGroup}».`
- **Proposed:** `Нажмите, чтобы помолиться за народ «{peopleGroup}».`
- **Glossary ref:** glossary.ru_RU.md §1 «Народ ★»; §9 «Молитесь».
- **Why:** Same omission as F-RU-04, in the visible banner body. Case government fine as-is; the head noun is what's missing, against `peopleGroupIntroTitle` and `switchPeopleGroupConfirm`. Everything else is right — вы-imperative «Нажмите» matches body-prose register, placeholder keeps its guillemets.

### F-RU-06 · Minor · C4 register & consistency
- **Key:** `prayerReminderTitle`
- **English:** "Ready for today's prayer?"
- **Current:** `Готовы помолиться сегодня?`
- **Proposed:** `Готовы к сегодняшней молитве?`
- **Glossary ref:** glossary.ru_RU.md §3 «Ежедневная молитва ★» — «"Ежедневно" — намеренное указание… Избегайте перевода как "регулярная молитва" или "периодическая молитва"».
- **Why:** The file already has a settled rendering of *today's prayer* as a definite, expected thing: approved `reminderNotificationBody` «Откройте Doxa, чтобы начать **сегодняшнюю молитву**.» «Готовы помолиться сегодня?» re-frames it as an open invitation to pray at some point today — a casual nudge, which §4.1 says this key must not be. «Готовы к сегодняшней молитве?» presupposes the daily commitment and reuses the existing noun phrase, satisfying the reminder cluster in §4.3. Same length class, banner-title slot, no risk.

### F-RU-07 · Minor · C3 standalone sense
- **Key:** `emailsLoadError`
- **English:** "Couldn't load your emails."
- **Current:** `Не удалось загрузить ваши адреса.`
- **Proposed:** `Не удалось загрузить ваши адреса электронной почты.`
- **Glossary ref:** glossary.ru_RU.md silent; precedent = approved `emailLabel` «Электронная почта».
- **Why:** Read with no English in view, «ваши адреса» is most naturally *postal* addresses; nothing in the message disambiguates. It's the error state of the account section (`lib/components/settings/account_settings_section.dart:96`), a body slot with room, and the file already owns the full phrase «адрес электронной почты» (`emailInvalid`, and «на адрес {email}» in `newsSignupSuccessBody`). The «Не удалось загрузить…» opening is retained to match `couldNotLoadPeopleGroupsMessage` / `couldNotLoadPrayerContent`.

### F-RU-08 · Minor · C5 naturalness / C7 slot fit
- **Key:** `resendVerification`
- **English:** "Resend verification email"
- **Current:** `Отправить письмо для подтверждения ещё раз`
- **Proposed:** `Отправить письмо повторно`
- **Glossary ref:** glossary.ru_RU.md silent; §9 precedent that UI action labels stay short.
- **Why:** 41 characters against the English's 25 (1.64×) for a `TextButton` label (`lib/components/settings/signed_up_email_tile.dart:134`), and the discontinuous «Отправить … ещё раз» wrapped around a four-word noun phrase is clumsy as a button. «Отправить письмо повторно» is 25 characters, idiomatic, and anaphoric rather than lossy: the button only exists when the tile above reads «Не подтверждён», and the cluster noun «письмо для подтверждения» is still spelled out in `resendVerificationSent` and `newsSignupSuccessBody`. It also ties the button to its own countdown state, `resendVerificationCountdown` «Повторить через {seconds} с», which already uses the *повтор-* root. Verification-email cluster (§4.3) stays single-nouned.

### F-RU-09 · Minor · C3 standalone sense / C4 consistency
- **Key:** `feedbackConsentLabel`
- **English:** "Keep me updated with news from Doxa"
- **Current:** `Держите меня в курсе новостей от Doxa`
- **Proposed:** `Хочу получать новости от Doxa`
- **Glossary ref:** glossary.ru_RU.md §7 «DOXA» — keep as a proper name, Latin, untranslated (satisfied by both).
- **Why:** This is a marketing-**consent** toggle and §4.1 requires unambiguous consent language. «Держите меня в курсе…» is a request addressed *to Doxa*; ticking a box that issues an instruction is not the same speech act as granting permission, and it reads as a calque of the English idiom. «Хочу получать новости от Doxa» is the standard Russian opt-in formula, unmistakably the user's own declaration, and reuses the file's settled «новости от Doxa» from approved `updatesFromDoxa`. `Doxa` stays Latin and bare. Shorter than current, so the checkbox slot is safe.

### F-RU-10 · Minor · C6 placeholder typography (§6.6)
- **Key:** `scanToPray` — *approved key, eligible under §6.6*
- **English:** "Scan to get the app and pray for the {name}"
- **Current:** `Отсканируйте QR-код, чтобы установить приложение, и помолитесь за {name}`
- **Proposed:** `Отсканируйте QR-код, чтобы установить приложение, и помолитесь за «{name}»`
- **Why:** **The plan's §6.6 table is wrong for `ru`.** It records `ru` as "guillemets throughout — new keys already consistent". True of the new keys but **not** of the file: `scanToPray` is the one name-like placeholder in `app_ru.arb` left bare. Every other one is guillemeted (`peopleGroupIntroTitle`, `shareMessage`, `switchPeopleGroupConfirm` ×2, `wizardConfirmPeopleGroupTitle`, `prayForPeopleGroupLabel`, `prayerReminderBody`) and every numeric/technical one bare — the convention is settled and this is the single gap. Guillemets only; deliberately *not* also adding «народ», because §6.6 licenses typography on approved strings and nothing else. Nothing is functionally broken; keep behind every Blocker.

### F-RU-11 · Note · out of scope
- **Key:** `appVersion` — *approved key, not in the 46*
- **English:** "Version {version}" · **Current:** `Версия{version}` · **Proposed:** `Версия {version}`
- **Why:** A real defect: the space before the placeholder was lost, so the settings footer renders «Версия1.2.3». Confirmed against `app_en.arb:702`, which has the space. Outside the 46-key scope and outside the seven §6.6 keys, so it needs an explicit C1 ruling before D5 may touch it.

### F-RU-12 · Note · out of scope
- **Key:** `prayerThankYouVerse` — *approved key, not in the 46*
- **Current:** `…непрестанно молитесь, за все благодарите; ибо такова воля Божья…` · **Proposed:** `…за всё благодарите…`
- **Why:** Raised only to confirm the `ё` convention. The file writes `ё`, and all new strings comply — no in-scope `ё` finding exists. The single lapse is here: «за все благодарите» is `всё` (*everything*), not `все` (*everyone*), and without the `ё` it is genuinely misreadable as "give thanks for everyone". Out of scope; also a Bible quotation, so C1 may prefer to leave the Synodal spelling.

### F-RU-13 · Note · out of scope
- **Key:** `updateRequiredBody` — *approved key, not in the 46*
- **Current:** `…чтобы продолжить пользоваться Doxa Prayer.` · **Proposed:** `…чтобы продолжить пользоваться приложением «Doxa Prayer».`
- **Why:** Raised only to report the `Doxa` check. All 46 new keys are correct: Latin script, untranslated, bare organisation form matching approved `updatesFromDoxa` / `notificationsHowToEnable` — nothing to fix in scope. The one inconsistency is that the *product* name is guillemeted in `shareMessage`, `wizardWelcomeTitle` and `updateAvailableBody` but bare here. Cosmetic.

### F-RU-14 · Note · out of scope (mechanical)
- **Key:** `@feedback` metadata block in `app_ru.arb`
- **Current:** `"description": "Button that opens the feedback page in the browser"` · **Proposed:** `"description": "Button that opens the in-app feedback panel"`
- **Why:** Stale copy of a superseded English description — `app_en.arb:618` now says "Button that opens the in-app feedback panel". Metadata only. For B1/D5's §6.2 sweep; a translator reading the ru file is currently told the wrong UI context.

## Answers to the specific questions asked

**`partial` — adverb or adjective? The adverb «Частично» is correct. Keep it.**

Evidence, `lib/components/cards/engagement_item.dart:50-69`:

```dart
final statusLabel = switch (status) {
  EngagementStatus.yes => l.yes,
  EngagementStatus.no => l.no,
  EngagementStatus.partial => l.partial,
};
…
Semantics(label: statusLabel, child: IconCircle(icon: icon, color: color)),
```

`partial` is uttered as its **own isolated `Semantics` node**, deliberately not composed with the marker label. The source comment states why: *"Kept separate from the label (rather than a single '{label}: {status}' node) so the status word is announced in isolation — a bare 'No' at the tail of a longer phrase was read by TTS as the abbreviation '№'."* So the word is never spoken next to any noun, and there is nothing for an adjective to agree with. Its two siblings in the same switch are `yes`/`no` = «Да»/«Нет» — an answer-word set, which Russian answers with the adverb: **Да / Нет / Частично**. An adjective would also be *impossible* to inflect correctly: the markers it must serve differ in gender and shape — `prayerStatus` «Статус молитвы» (m), `adoptionStatus` «Статус принятия» (m), `crossCulturalWorkersPresent` «Межкультурные служители присутствуют» (a clause), `workInLocalLanguageAndCulture` «Работа на родном языке и в местной культуре» (f). No single adjectival form covers those; the adverb covers all. The Romance locales' adjectives are not a reason to change Russian — §2 forbids that inference. Verdict **OK**, no finding.

**`engaged` = «Вовлечён» — keep the short form.**

Glossary §2 is «Вовлечение / вовлечённый (народ)», §1 «Невовлечённый народ ★» fixes the *вовлеч-* root as the precision term, and `ru.tsv` agrees (`engaged → вовлечённый`). The current string is on the right root and does **not** commit the error the English glossary warns against — nothing reads as «участие» or «контакт». On grammar: `lib/screens/people_group_details_screen.dart:162-166` shows `l.engaged` is passed as the marker **`label`** (visible caption under a tick) with `status` hard-coded to `EngagementStatus.yes`, replacing three markers when the group is engaged. The implied subject is the app's head noun **народ** (masculine, per §1 and `peopleGroup` = «Народ»), so the masculine short form agrees. Bare short-form status captions are already the file's approved pattern — `selected` = «Выбрано». The collapsed markers it stands in for include a full predicative clause («Межкультурные служители присутствуют»), so a predicative caption is in keeping. It also cannot be confused with the heading directly above it, `engagementStatus` = «Статус вовлечения», which the noun «Вовлечение» *would* have duplicated. Verdict **OK**. (Spoken order is status-then-label, so TalkBack says «Да. Вовлечён.» — coherent.)

**`emailVerified` / `emailUnverified` gender.** Masculine short forms. `lib/components/settings/signed_up_email_tile.dart:106-108` renders them on the line immediately below `Text(widget.email.value)` — below the address itself — so the implied subject is **адрес** (masculine) and the agreement is right. OK for both.

**`forwardLabel`.** `lib/components/buttons/arrow_button.dart:25-27` pairs it directly with `MaterialLocalizations.backButtonTooltip`, which is «Назад» in Russian. «Вперёд» is its exact counterpart, distinct from `nextDay` «Следующий день». §6.8's "renders as *next*" concern does not apply to Russian. OK.

**Case government on the placeholder strings.** Both `prayForPeopleGroupLabel` and `prayerReminderBody` are grammatically safe as written: «за» takes the accusative, the guillemeted insert is inert, and the accusative of an inanimate masculine noun equals its nominative, so an uninflected data string never clashes. The defect is the missing head noun, not the case — F-RU-04/05.

## Verdict table

| Key | Verdict | Finding |
|---|---|---|
| `accountSectionTitle` | OK | — |
| `allow` | OK | — |
| `allowExactAlarms` | OK | — |
| `clearSearchLabel` | OK | — |
| `dailyPrayerCoverage` | Blocker | F-RU-03 |
| `dismissReminderLabel` | OK | — |
| `emailUnverified` | OK | — |
| `emailVerified` | OK | — |
| `emailsLoadError` | Minor | F-RU-07 |
| `enableNotificationsButton` | Blocker | F-RU-01 |
| `enableNotificationsPromptBody` | Blocker | F-RU-02 |
| `engaged` | OK | — |
| `exactAlarmsDisabledStatus` | OK | — |
| `exactAlarmsPromptBody` | OK | — |
| `feedbackConsentLabel` | Minor | F-RU-09 |
| `feedbackError` | OK | — |
| `feedbackIntro` | OK | — |
| `feedbackMessageLabel` | OK | — |
| `feedbackMessageRequired` | OK | — |
| `feedbackNameLabel` | OK | — |
| `feedbackRateLimited` | OK | — |
| `feedbackSubmit` | OK | — |
| `feedbackSuccessBody` | OK | — |
| `feedbackSuccessTitle` | OK | — |
| `feedbackTypeCompliment` | OK | — |
| `feedbackTypeLabel` | OK | — |
| `feedbackTypeProblem` | OK | — |
| `feedbackTypeRequired` | OK | — |
| `feedbackTypeSuggestion` | OK | — |
| `forwardLabel` | OK | — |
| `newsSignupSuccessBody` | OK | — |
| `newsSignupSuccessTitle` | OK | — |
| `notNow` | OK | — |
| `partial` | OK | — |
| `pictureCreditLabel` | OK | — |
| `prayForPeopleGroupLabel` | Minor | F-RU-04 |
| `prayerRecordedAnnouncement` | OK | — |
| `prayerReminderBody` | Minor | F-RU-05 |
| `prayerReminderTitle` | Minor | F-RU-06 |
| `resendVerification` | Minor | F-RU-08 |
| `resendVerificationCooldown` | OK | — |
| `resendVerificationCountdown` | OK | — |
| `resendVerificationFailed` | OK | — |
| `resendVerificationSent` | OK | — |
| `signUp` | OK | — |
| `viewProfile` | OK | — |

**46 / 46 verdicted.** Out-of-scope keys additionally reported: `scanToPray` (F-RU-10, §6.6-eligible), `appVersion` (F-RU-11), `prayerThankYouVerse` (F-RU-12), `updateRequiredBody` (F-RU-13), `@feedback` metadata (F-RU-14).

### Notes on the OK verdicts that were close calls

- `signUp` «Зарегистрироваться» — matches glossary §9 «Зарегистрироваться» and `ru.tsv` `sign up → зарегистрироваться`. `newsSignupSuccessTitle` «Спасибо за регистрацию!» keeps the same root, so §4.1's consistency requirement is met. Approved `signUpForUpdates` «Подпишитесь на новости» uses the *подпис-* root, but the glossary explicitly allows both readings for this label and `newsSignupSuccessBody` translates the English's own "subscription" as «подписку», so the pair is coherent, not a clash.
- `feedback` cluster — one noun («отзыв», pl. «отзывы») and one verb across all 15 keys: «Отправить отзыв», «…много отзывов», «Какой тип отзыва?», «Ваш отзыв отправлен…», approved `feedback` «Отзывы». No «обратная связь» anywhere. The §4.3 risk did not materialise.
- `feedbackError` is byte-identical to approved `newsSignupError`, matching identical English. Correct, not a copy-paste error.
- `resendVerificationCooldown` / `resendVerificationCountdown` — «{seconds} с» with a space before the unit and no full stop is the correct Russian abbreviation for *секунда*; the English's tight `{seconds}s` must not be copied. Both correct.
- `exactAlarms*` cluster — «точные будильники» in all four keys, «напоминания о молитвах» for the reminders. See the glossary-silent table for why the Android settings-screen title was considered and not adopted.
- `prayerRecordedAnnouncement` «Молитва записана» — feminine agreement with «молитва» is right, and «записана» reads as *logged* in the context it fires (immediately after the Amen tap, `lib/components/prayer_content/prayer_session_view.dart:272-276`). The audio-recording reading is theoretically available but not live there.

## Decisions made where the glossary was silent

| Term | Chosen rendering | Glossary precedent applied |
|---|---|---|
| daily prayer coverage | **Ежедневный молитвенный охват** | §3 «24-часовой молитвенный охват» supplies the head noun **охват** and the constraint against the insurance/legal reading; §3 «Ежедневная молитва ★» supplies *ежедневный*. Composed per §6.4; the `.tsv`'s «покрытие» rejected under §2 authority order. |
| engaged (bare marker caption) | **Вовлечён** (short form, m. sg., agreeing with «народ») | §2 «Вовлечение / вовлечённый (народ)» fixes the *вовлеч-* root; §1 «Народ ★» supplies the masculine head noun it agrees with; approved `selected` «Выбрано» establishes bare short-form status captions. |
| partial (spoken status) | **Частично** (adverb, kept) | No glossary entry. Decided from the code: spoken in isolation beside `yes`/`no` = «Да»/«Нет», so it belongs to an answer-word set, and no adjective could agree with markers of differing gender and shape. |
| exact alarms | **точные будильники** (kept, all four keys) | §9's principle that UI labels take a transparent, consistently-used term. The Android RU settings screen is «Будильники и напоминания», which would aid discovery on `allowExactAlarms` — but *exactness* is load-bearing in `exactAlarmsDisabledStatus` and `exactAlarmsPromptBody`, and §4.3 requires one rendering across the cluster, so the descriptive term wins. Recorded so C1/B2 can overrule with a cross-language ruling. |
| feedback (feature + item) | **отзыв** / pl. **отзывы** | §9's one-settled-term principle; already used by approved `feedback` «Отзывы». Russian does not need the *отзыв* / *обратная связь* split the plan anticipated, so one noun serves all 15 keys. |
| verification email | **письмо для подтверждения** | §9 preference for a transparent descriptive phrase over a calque; already the noun in `resendVerificationSent` and `newsSignupSuccessBody`, so fixed as the cluster noun. Verb is «подтвердить»/«подтверждён» everywhere. |
| reminder | **напоминание** | Approved `reminders`, `newReminder`, `setReminder`, `reminderNotificationTitle`. Single noun across `dismissReminderLabel`, `prayerReminder*`, `exactAlarms*`. |
| notifications | **уведомления** | Approved `notifications`, `notificationsEnabledStatus`, `enableNotifications`. |
| push notifications | **push-уведомления** | Same, plus §7's «Пятидесятнический» principle — keep the widely-used loanword rather than invent a calque. Latin *push*, hyphenated. |
| profile | **профиль** | Approved `profile` «Профиль»; `viewProfile` «Открыть профиль» also mirrors approved `openSettings` «Открыть настройки», right because the button opens an external web page. |
| account | **аккаунт** | §7's «Пятидесятнический»/«Диаспора» principle — keep the established loanword the language already uses, rather than «учётная запись», heavier than a settings section header wants. |
| compliment (feedback type) | **Похвала** | §9's natural-local-equivalent-over-calque principle; fits the chip slot beside «Предложение» and «Проблема». |
| dismiss (banner) vs dismiss (reminder rule) | **Скрыть** vs **Отклонить** | Kept distinct deliberately: `dismissReminderLabel` only hides a home banner, while approved `dismissNextReminder` turns the reminder rule off. Different actions, so §4.3's one-noun rule applies to «напоминание» — which is uniform — not to the verbs. |

## What this audit could not determine

- Whether Android's Russian **Alarms & reminders** screen would be easier to find from a button reading «Разрешить будильники и напоминания» than from «Разрешить точные будильники». Resolved in favour of cluster consistency (see table) rather than verifying Android's exact RU string, which is not checkable from this repo. A discoverability trade-off, not a correctness question — no string left unresolved.
- Nothing else. All 46 keys have verdicts, and every finding carries a final Russian string ready to apply.
