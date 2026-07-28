# Findings — review-ar

**Agent:** review-ar (A1)
**Scope:** 46 keys, Arabic (+ the §6.6 placeholder-guillemet keys)
**Glossary consulted:** ../translation/translated-glossaries/glossary.ar.md (source of truth);
../translation/glossary.md (concepts); ../translation/deepl-glossaries/ar.tsv (index, subordinate)
**Keys verdicted:** 46 / 46
**Severity counts:** 2 Blocker · 2 Major · 10 Minor (in-scope keys) + 1 Minor (§6.6 approved key) · 1 Note · 32 OK

**House style established from the approved strings before judging** (`app_ar.arb`):

- Register: MSA, second person **masculine singular** in the dominant/newer strings
  (`حسابك`, `هل تريد…`, `اختر`, `اضغط`, `تحقق`). A few older strings use the plural
  (`ابدؤوا الآن`, `شكرًا لكم على صلواتكم`) — the singular is the live convention.
- Buttons/labels: **verbal noun (مصدر)** dominates — `حفظ`, `حذف`, `مشاركة`, `تحديث`,
  `فتح الإعدادات`, `تمكين الإشعارات`, `السماح`, `تعيين تذكير`, `إعادة المحاولة`.
  Body copy and instructions use the plain imperative (`انقر أدناه…`, `اسمح لتطبيق Doxa…`).
- Diacritics: sparse and inconsistent — shadda/tanwīn only where it disambiguates
  (`صلّ`, `شكرًا`, `مُبشَّر`, `مُنخرَط`); the same word appears both with and without it
  (`تعذر` / `تعذّر`, `يرجى` / `يُرجى`). No key is wrong because of this; see Note F-AR-13.
- Placeholders: `«{name}»` **French guillemets, no inner spaces**, on name-like
  placeholders; bare on numeric/technical ones (`{time}`, `{seconds}`, `{email}`,
  `{version}`, `{count}`). One approved key breaks it — F-AR-12.
- `Doxa` appears in **Latin script** in all three in-scope strings that mention it
  (`exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`, `feedbackConsentLabel`) ✔.
  Several *approved* keys transliterate it (`«دوكسا»`) — out of scope, recorded in F-AR-13.

---

## Findings

### F-AR-01 · Blocker · C2 missing string
- **Key:** `enableNotificationsButton`
- **English:** "Enable notifications"
- **Current:** *absent from `app_ar.arb`* — falls back to English at runtime
- **Proposed:** `تمكين الإشعارات`
- **Glossary ref:** not a glossaried term. Precedent: the existing approved key
  `enableNotifications` = `تمكين الإشعارات` (identical English), plus the file's
  masdar button style.
- **Why:** `app_en.arb` carries two separate keys with the identical string
  "Enable notifications" (`enableNotifications`, used by the settings route, and
  `enableNotificationsButton`, used by `lib/components/notifications/enable_notifications_prompt.dart:89`).
  Arabic has only the first. The prompt's button therefore renders English inside an
  otherwise Arabic dialog. Same wording as the approved sibling keeps one verb for
  "enable" across the app. Needs its `@enableNotificationsButton` description block too.

### F-AR-02 · Blocker · C2 missing string
- **Key:** `enableNotificationsPromptBody`
- **English:** "Enable notifications to also receive updates in push notifications."
- **Current:** *absent from `app_ar.arb`*
- **Proposed:** `قم بتمكين الإشعارات لتصلك آخر المستجدات عبر الإشعارات الفورية أيضًا.`
- **Glossary ref:** not glossaried. Precedents inside the file: `آخر المستجدات` is the
  file's settled rendering of "updates" (`updatesFromDoxa`, `signUpForUpdates`,
  `wizardNewsSignupBody`); `قم بـ + مصدر` for an instruction is precedented by
  `notificationsHowToEnable` ("…ثم قم بالسماح بتلقي الإشعارات من Doxa"); `تمكين` is the
  file's verb for "enable".
- **Why:** Untranslated body copy in the post-signup prompt
  (`enable_notifications_prompt.dart:83`). "in push notifications" is rendered
  `عبر الإشعارات الفورية` — `الإشعارات الفورية` is the standard Arabic for *push
  notifications* and keeps the plain `الإشعارات` of the rest of the app for the OS
  permission itself. `أيضًا` carries the English "also" (email updates are already
  subscribed; this adds push). Needs its `@key` description block.

### F-AR-03 · Major · C1 glossary fidelity + C5 agreement
- **Key:** `engaged`
- **English:** "Engaged" — marker label shown when a people group is engaged
- **Current:** `مُنخرَط`
- **Proposed:** `مُنخرَطة`
- **Glossary ref:** glossary.ar.md §2 "الانخراط / **المجموعة الشعبية المنخرطة**"
  (heading, ~line 132) — the engaged-people-group attribute is rendered with the
  feminine `منخرطة`, agreeing with `المجموعة الشعبية`. Corroborated by ar.tsv line 5
  (`unengaged people group` → `جماعة عرقية غير مُنخرَطة`, feminine) against line 14
  (`engaged` → `مُنخرَط`, the uninflected dictionary form).
- **Why:** The word itself is the correct glossary term (`انخراط` family, **not**
  `مشاركة`/`اتصال`/`التزام`, which glossary.ar.md §2 explicitly warns against —
  "الترجمة المبهمة كـ'مشاركة' أو 'اتصال' تجرّد المعنى الجوهري"). What is wrong is the
  inflection. The chip is a bare standalone marker label
  (`lib/screens/people_group_details_screen.dart:164`) that collapses the three
  engagement markers for the group being viewed, sitting under the header
  `حالة الانخراط`; its referent is `المجموعة الشعبية`, which is feminine. The masculine
  `مُنخرَط` reads as describing a male person, not the group. Keep the tsv's diacritics
  exactly and change only the agreement.

### F-AR-04 · Major · C2 meaning + C5 grammar
- **Key:** `prayerReminderTitle`
- **English:** "Ready for today's prayer?"
- **Current:** `حان وقت الصلاة اليوم؟`
- **Proposed:** `هل أنت مستعد لصلاة اليوم؟`
- **Glossary ref:** glossary.ar.md §3 "الصلاة اليومية ★" — the banner must read as the
  *daily commitment* being kept today, not a generic clock alarm.
- **Why:** Two defects. (1) Meaning: the English asks the *user's readiness*; the Arabic
  asserts that *the time has arrived* — and it does so with the exact wording of a
  different key, `reminderNotificationTitle` = `حان وقت الصلاة`, so the home banner and
  the OS notification say the same thing while the English deliberately differs.
  (2) Grammar: a written Arabic yes/no question needs `هل` (or `أ`); `حان وقت الصلاة اليوم؟`
  is a declarative sentence with a question mark bolted on, and `اليوم` there reads as an
  adverb ("today the prayer time has come") rather than as the possessor in "today's
  prayer". `صلاة اليوم` restores "today's prayer", and `هل أنت مستعد` restores the
  readiness question in the file's masculine-singular register (cf. `هل تريد…`).

### F-AR-05 · Minor · C4 cluster consistency / platform wording
- **Keys:** `allowExactAlarms`, `exactAlarmsDisabledStatus`, `exactAlarmsPromptBody`
- **English:** "Allow exact alarms" / "Exact alarms aren't allowed for Doxa, so your
  prayer reminders may arrive several minutes late." / "For your prayer reminders to
  arrive right on time, allow Doxa to use exact alarms."
- **Current:**
  - `allowExactAlarms`: `السماح بالتنبيهات الدقيقة`
  - `exactAlarmsDisabledStatus`: `التنبيهات الدقيقة غير مسموح بها لتطبيق Doxa، لذا قد تصل تذكيرات الصلاة متأخرة بعدة دقائق.`
  - `exactAlarmsPromptBody`: `لكي تصل تذكيرات الصلاة في وقتها تمامًا، اسمح لتطبيق Doxa باستخدام التنبيهات الدقيقة.`
- **Proposed:**
  - `allowExactAlarms`: `السماح بالمنبّهات الدقيقة`
  - `exactAlarmsDisabledStatus`: `المنبّهات الدقيقة غير مسموح بها لتطبيق Doxa، لذا قد تصل تذكيرات الصلاة متأخرة بعدة دقائق.`
  - `exactAlarmsPromptBody`: `لكي تصل تذكيرات الصلاة في وقتها تمامًا، اسمح لتطبيق Doxa باستخدام المنبّهات الدقيقة.`
- **Glossary ref:** un-glossaried platform vocabulary; §4.3 of the plan requires the
  wording to match the Android system settings screen so the user can find it. Android's
  Arabic special-app-access screen is **"المنبّهات والتذكيرات"** (alarms & reminders).
- **Why:** `تنبيه` is Arabic for *alert/notification*, and this app already owns
  `الإشعارات` for notifications and shows a notifications-permission page right next to
  the alarms one. A user told `التنبيهات الدقيقة غير مسموح بها` will go hunting in the
  notification settings, which is the wrong screen. `المنبّهات` is the clock-alarm word
  and is what the Android screen they are being sent to is actually called. The three
  strings must move together; everything else in them (including `تذكيرات` as the single
  noun for "reminder", and Latin-script `Doxa`) is correct and unchanged. B2's canonical
  table arbitrates if it lands on a different form.

### F-AR-06 · Minor · C3 standalone sense
- **Key:** `feedbackTypeCompliment`
- **English:** "Compliment" — feedback type option for positive feedback
- **Current:** `إطراء`
- **Proposed:** `إشادة`
- **Glossary ref:** un-glossaried. Nearest precedent: glossary.ar.md §9's instruction that
  UI action labels use the established local wording for usability
  ("الاتساق في الترجمة أمر بالغ الأهمية للقابلية الاستخدامية").
- **Why:** `إطراء` carries the sense of *flattery / excessive praise*, so the chip invites
  the user to classify their own message as flattery. `إشادة` is the neutral
  "commendation" and is the standard third member of the Arabic feedback triad used across
  Arabic service portals — `شكوى/مشكلة · اقتراح · إشادة` — which is exactly this chooser's
  set (`مشكلة`, `اقتراح`, + this key). `مشكلة` and `اقتراح` need no change.

### F-AR-07 · Minor · C5 naturalness
- **Key:** `resendVerificationSent`
- **English:** "Verification email sent. Check your inbox."
- **Current:** `تم إرسال رسالة التحقق. تحقق من صندوق الوارد.`
- **Proposed:** `تم إرسال رسالة التحقق. تفقَّد صندوق الوارد.`
- **Glossary ref:** un-glossaried; `رسالة التحقق` is the file's settled noun for the
  verification email and is kept.
- **Why:** `التحقق … تحقق` in one breath is clumsy, and worse, it reuses the *verification*
  verb for the unrelated instruction "check your inbox" — a screen-reader user or a hurried
  reader can parse `تحقق من صندوق الوارد` as "verify your inbox". `تفقَّد` is the ordinary
  Arabic verb for checking/looking at something and removes the collision.

### F-AR-08 · Minor · C2 omission + C4 register
- **Key:** `resendVerificationFailed`
- **English:** "Couldn't send the email. Please try again."
- **Current:** `تعذّر إرسال الرسالة. حاول مرة أخرى.`
- **Proposed:** `تعذّر إرسال الرسالة. يرجى المحاولة مرة أخرى.`
- **Glossary ref:** n/a. Precedent: `feedbackError`, `newsSignupError`,
  `feedbackRateLimited` all use `يرجى المحاولة مرة أخرى`.
- **Why:** "Please" is dropped, leaving a bare imperative that is blunter than every other
  error message in the file. The proposal matches the three sibling error strings exactly.

### F-AR-09 · Minor · C5 naturalness
- **Key:** `feedbackIntro`
- **English:** "We'd love to hear from you. Tell us what you think of the app."
- **Current:** `يسعدنا أن نسمع رأيك. أخبرنا برأيك في التطبيق.`
- **Proposed:** `يسعدنا أن نسمع منك. أخبرنا برأيك في التطبيق.`
- **Glossary ref:** n/a.
- **Why:** `رأيك` twice in two short sentences; the English does not repeat, and the first
  clause is "hear *from you*", not "hear your opinion". `نسمع منك` is the idiomatic
  rendering and leaves the second sentence to carry `رأيك`.

### F-AR-10 · Minor · C5 naturalness
- **Key:** `feedbackSuccessBody`
- **English:** "Your feedback was sent as {email}. If that isn't the right address, send it
  again with the correct one."
- **Current:** `تم إرسال تعليقاتك باسم {email}. إذا لم يكن هذا هو العنوان الصحيح، فأعد إرسالها بالعنوان الصحيح.`
- **Proposed:** `تم إرسال تعليقاتك من العنوان {email}. إذا لم يكن هذا هو العنوان الصحيح، فأعد إرسالها بالعنوان الصحيح.`
- **Glossary ref:** n/a. `{email}` is a technical placeholder → stays bare per §6.6 ✔.
- **Why:** `باسم {email}` means "in the name of <address>", which reads as a personal name
  and makes the following sentence's `العنوان` come out of nowhere. `من العنوان {email}`
  states what the English means — which address the feedback was attributed to — and sets
  up the correction sentence. Placeholder name and position unchanged.

### F-AR-11 · Minor · C5 number agreement
- **Keys:** `resendVerificationCooldown`, `resendVerificationCountdown`
- **English:** "Please wait {seconds}s before requesting another email." / "Resend in {seconds}s"
- **Current:**
  - `يُرجى الانتظار {seconds} ثانية قبل طلب رسالة أخرى.`
  - `إعادة الإرسال خلال {seconds} ثانية`
- **Proposed:**
  - `resendVerificationCooldown`:
    `{seconds, plural, zero{يُرجى الانتظار قليلًا قبل طلب رسالة أخرى.} one{يُرجى الانتظار ثانية واحدة قبل طلب رسالة أخرى.} two{يُرجى الانتظار ثانيتين قبل طلب رسالة أخرى.} few{يُرجى الانتظار {seconds} ثوانٍ قبل طلب رسالة أخرى.} many{يُرجى الانتظار {seconds} ثانية قبل طلب رسالة أخرى.} other{يُرجى الانتظار {seconds} ثانية قبل طلب رسالة أخرى.}}`
  - `resendVerificationCountdown`:
    `{seconds, plural, one{إعادة الإرسال خلال ثانية} two{إعادة الإرسال خلال ثانيتين} few{إعادة الإرسال خلال {seconds} ثوانٍ} many{إعادة الإرسال خلال {seconds} ثانية} other{إعادة الإرسال خلال {seconds} ثانية}}`
- **Glossary ref:** n/a — Arabic CLDR plural categories (`zero/one/two/few/many/other`).
- **Why:** the countdown really does run down to single digits —
  `lib/components/settings/signed_up_email_tile.dart:41-53` ticks `_cooldownRemaining`
  from 60 to 0 every second and rebuilds the button label — so Arabic users see
  `إعادة الإرسال خلال 3 ثانية`, which is ungrammatical (3–10 takes the plural `ثوانٍ`).
  The server-supplied `retryAfterSeconds` in the cooldown SnackBar can be small too.
  `@resendVerification{Cooldown,Countdown}` already declare `seconds` as `int` in
  `app_ar.arb`, so an `ar`-only ICU plural is well-formed even though the English template
  is flat. **Fallback if the implementer will not ship an ICU plural in a translation
  file:** leave both strings exactly as they are today — the flat `ثانية` form is the
  common pragmatic compromise and is not a Blocker. Flag to B1: this is a case of an
  English key that should arguably have been authored as a plural.

### F-AR-12 · Minor · C6 placeholder typography (§6.6)
- **Key:** `switchPeopleGroupConfirm` *(approved key — permitted by §6.6)*
- **English:** "Do you want to stop praying for {currentName} and start praying for {newName}?"
- **Current:** `هل تريد التوقف عن الدعاء من أجل {currentName} والبدء في الدعاء من أجل {newName}؟`
- **Proposed:** `هل تريد التوقف عن الدعاء من أجل «{currentName}» والبدء في الدعاء من أجل «{newName}»؟`
- **Glossary ref:** n/a — plan §6.6.
- **Why:** §6.6's table records `ar` as "guillemets throughout"; that is not accurate.
  Six of the seven eligible keys carry `«…»` (`peopleGroupIntroTitle`, `scanToPray`,
  `shareMessage`, `wizardConfirmPeopleGroupTitle`, `prayForPeopleGroupLabel`,
  `prayerReminderBody`), and this one has both name placeholders bare. Two people-group
  names run unquoted into surrounding Arabic prose here, which is exactly the case the
  convention exists for. Guillemets only — I am deliberately **not** touching this
  string's `الدعاء`, even though the rest of the file says `الصلاة`; see F-AR-13.

### F-AR-13 · Note · out-of-scope observations (no Phase 3 action)
Found while establishing house style. All are in **approved** keys outside the §4 scope
and outside the §6.6 exception, so no change is proposed here — recorded so C1 can decide
whether a follow-up pass is warranted.

1. `nextReminderToday` = `اليوم على موقع {time}` ("today **on the site** {time}"),
   `nextReminderTomorrow` = `غدًا على موقع {time}`, `nextReminderOn` = `{weekday} على الرابط {time}`
   ("**on the link** {time}"). `على موقع` / `على الرابط` are machine-translation garbage for
   "at <time>"; the correct form is `اليوم في الساعة {time}` etc. This is the most serious
   defect I saw in the file and it is user-facing on the home card.
2. `appVersion` = `الإصدار{version}` — missing space before the placeholder.
3. `reminderNotificationBody` = `افتح كتاب «دوكسا» لبدء صلاة اليوم.` — `كتاب` ("the **book**
   Doxa") is wrong; and see 4.
4. `Doxa` is transliterated as `«دوكسا»` in `appName`, `reminderNotificationBody`,
   `wizardWelcomeBody` while the in-scope strings correctly keep Latin `Doxa`
   (glossary.ar.md §7 "DOXA": "احتفظ به كاسم علم … لكن لا تترجمه"). B1 owns this rule.
5. `nameLabel` = `الإسم` — misspelling of `الاسم`. The new `feedbackNameLabel` spells it
   correctly, so the two labels differ.
6. `search` = `إبحث` — should be `ابحث` (no hamza on the imperative of a form-I verb).
7. `switchPeopleGroupConfirm` uses `الدعاء` where the whole rest of the file uses
   `الصلاة` for prayer.
8. `dismissNextReminder` uses `إغلاق` for "dismiss" while the in-scope
   `dismissReminderLabel` uses `تجاهل`. Both are defensible in isolation (see the
   `dismissReminderLabel` verdict); one verb should be picked eventually.
9. Diacritics vary within the file for the same word (`تعذر`/`تعذّر`, `يرجى`/`يُرجى`).
   Both spellings are correct Arabic and the variance is invisible in practice; not worth
   a diff, and I did not normalise it in any proposed string.
10. Non-translation observation for the engineers, not for Phase 3:
    `lib/components/buttons/arrow_button.dart:22-24` draws the "forward" arrow as
    `TriangleDirection.right` unconditionally, so in RTL Arabic the forward arrow points
    the wrong way regardless of its label.

---

## Verdict table

| Key | Verdict | Finding |
|---|---|---|
| `accountSectionTitle` | OK | — |
| `allow` | OK | — |
| `allowExactAlarms` | Minor | F-AR-05 |
| `clearSearchLabel` | OK | — |
| `dailyPrayerCoverage` | OK | — |
| `dismissReminderLabel` | OK | — |
| `emailUnverified` | OK | — |
| `emailVerified` | OK | — |
| `emailsLoadError` | OK | — |
| `enableNotificationsButton` | **Blocker** | F-AR-01 |
| `enableNotificationsPromptBody` | **Blocker** | F-AR-02 |
| `engaged` | **Major** | F-AR-03 |
| `exactAlarmsDisabledStatus` | Minor | F-AR-05 |
| `exactAlarmsPromptBody` | Minor | F-AR-05 |
| `feedbackConsentLabel` | OK | — |
| `feedbackError` | OK | — |
| `feedbackIntro` | Minor | F-AR-09 |
| `feedbackMessageLabel` | OK | — |
| `feedbackMessageRequired` | OK | — |
| `feedbackNameLabel` | OK | — |
| `feedbackRateLimited` | OK | — |
| `feedbackSubmit` | OK | — |
| `feedbackSuccessBody` | Minor | F-AR-10 |
| `feedbackSuccessTitle` | OK | — |
| `feedbackTypeCompliment` | Minor | F-AR-06 |
| `feedbackTypeLabel` | OK | — |
| `feedbackTypeProblem` | OK | — |
| `feedbackTypeRequired` | OK | — |
| `feedbackTypeSuggestion` | OK | — |
| `forwardLabel` | OK | — (refutes §6.8 for `ar`) |
| `newsSignupSuccessBody` | OK | — |
| `newsSignupSuccessTitle` | OK | — |
| `notNow` | OK | — |
| `partial` | OK | — (refutes §6.7 concern for `ar`) |
| `pictureCreditLabel` | OK | — |
| `prayForPeopleGroupLabel` | OK | — |
| `prayerRecordedAnnouncement` | OK | — |
| `prayerReminderBody` | OK | — |
| `prayerReminderTitle` | **Major** | F-AR-04 |
| `resendVerification` | OK | — |
| `resendVerificationCooldown` | Minor | F-AR-11 |
| `resendVerificationCountdown` | Minor | F-AR-11 |
| `resendVerificationFailed` | Minor | F-AR-08 |
| `resendVerificationSent` | Minor | F-AR-07 |
| `signUp` | OK | — |
| `viewProfile` | OK | — |
| *(§6.6)* `switchPeopleGroupConfirm` | Minor | F-AR-12 |

### Why the `OK`s are OK (one line each, in table order)

- `accountSectionTitle` `حسابك` — correct 2nd-person-masc-singular section header, matches the file's register.
- `allow` `السماح` — masdar button style; also the wording of Android's own Arabic permission dialog.
- `clearSearchLabel` `مسح البحث` — accurate, natural spoken Arabic for a clear-field control.
- `dailyPrayerCoverage` `تغطية الصلاة اليومية` — `الصلاة اليومية` is the glossaried ★ term (glossary.ar.md §3) and `تغطية` is the glossary's own word for prayer coverage (§3, 24-hour entry); with `الصلاة` as its genitive it cannot be read as insurance cover, which is the §3 warning. Works as the progress-bar caption and as its screen-reader label (spoken with the value `12/144`). See the decisions table.
- `dismissReminderLabel` `تجاهل التذكير` — `تجاهل` is the established Arabic rendering of "dismiss" for reminders/alerts, and `التذكير` is the file's single noun for "reminder"; reads correctly as speech. (Sibling `dismissNextReminder` uses `إغلاق` — out of scope, F-AR-13.)
- `emailUnverified` `لم يتم التحقق` / `emailVerified` `تم التحقق` — the verbal construction sidesteps the gender-agreement trap the plan flags (nothing has to agree with `العنوان`), both are standard Arabic status wording, and both are short enough for the tile.
- `emailsLoadError` `تعذّر تحميل عناوين بريدك الإلكتروني.` — "your email addresses" is exactly what the failing list contains; matches the file's `تعذر تحميل…` error pattern.
- `feedbackConsentLabel` `أبقِني على اطّلاع بآخر أخبار Doxa` — unambiguous opt-in consent, `Doxa` in Latin, and it reuses the file's `آخر…` updates vocabulary.
- `feedbackError` `حدث خطأ ما. يرجى التحقق من اتصالك ومحاولة الإجراء مرة أخرى.` — English is identical to the approved `newsSignupError`, and so is the Arabic; deliberately left byte-identical.
- `feedbackMessageLabel` `الرسالة` / `feedbackMessageRequired` `يرجى إدخال رسالة.` / `feedbackNameLabel` `الاسم (اختياري)` — accurate, and the validation string matches the `يرجى إدخال…` pattern of `nameRequired`/`emailInvalid`.
- `feedbackRateLimited` / `feedbackSubmit` / `feedbackTypeLabel` / `feedbackTypeRequired` — the whole feedback cluster settles on one root, `تعليق/التعليقات`, matching the approved `feedback` = `التعليقات`: `إرسال التعليقات`, `الكثير من التعليقات`, `ما نوع التعليق؟`, `نوع التعليق`. No synonym drift; §4.3 satisfied.
- `feedbackSuccessTitle` `شكرًا لك!` — correct, singular register.
- `feedbackTypeProblem` `مشكلة` / `feedbackTypeSuggestion` `اقتراح` — exact, chip-length.
- `forwardLabel` `التالي` — **§6.8 refuted for Arabic.** The paired back control takes its label from `MaterialLocalizations.backButtonTooltip` (`رجوع`), not from this file, and Arabic UI convention labels a forward/right arrow `التالي`. A literal `إلى الأمام` would be worse as speech. No change.
- `newsSignupSuccessBody` — `رسالة تحقق` matches the cluster's noun, `{email}` bare per §6.6, and the instruction to open the inbox and tap the link is complete.
- `newsSignupSuccessTitle` `شكرًا لتسجيلك!` — same `تسجيل` root as `signUp`; consistent.
- `notNow` `ليس الآن` — identical to the approved `updateDismiss`, correct for a decline button.
- `partial` `جزئي` — **§6.7 addressed for Arabic.** `engagement_item.dart:66` speaks the status as its *own* semantics node, before the marker label, so it never forms a phrase with the feminine `الحالة` and needs no agreement; the bare adjective matches its siblings `نعم`/`لا`, and it describes how far the marker is met, never the people's zeal (glossary.ar.md §1's `ضعيفة الانخراط` warning).
- `pictureCreditLabel` `حقوق الصورة` — the established Arabic caption for an image credit line; correct for an attribution info button.
- `prayForPeopleGroupLabel` `الصلاة من أجل «{peopleGroup}»` — glossaried `الصلاة من أجل` (§3/§9), guillemets per the `ar` convention, masdar suits a whole-banner a11y label.
- `prayerRecordedAnnouncement` `تم تسجيل الصلاة` — natural spoken confirmation; `الصلاة` keeps the intercession sense of §3.
- `prayerReminderBody` `اضغط للصلاة من أجل «{peopleGroup}».` — imperative + glossaried `الصلاة من أجل`, guillemets present, placeholder intact.
- `resendVerification` `إعادة إرسال رسالة التحقق` — one noun (`رسالة التحقق`) and one verb (`التحقق`) for the whole verification cluster; masdar button style; fits the tile's text button.
- `signUp` `التسجيل` — ar.tsv line 85 (`sign up` → `التسجيل`) used verbatim; see the decisions table for why the masdar is kept over glossary §9's imperative `سجّل`.
- `viewProfile` `عرض الملف الشخصي` — reuses the approved `profile` = `الملف الشخصي`; masdar button style.

---

## Decisions made where the glossary was silent

| Term | Chosen rendering | Glossary precedent applied |
|---|---|---|
| daily prayer coverage (`dailyPrayerCoverage`; glossary has only the superseded 24-hour form) | `تغطية الصلاة اليومية` — **keep as is** | glossary.ar.md §3 "الصلاة اليومية ★" supplies the head term; §3 "تغطية الصلاة على مدار ٢٤ ساعة" supplies `تغطية` as the sanctioned word for coverage together with the constraint that it must mean *صلاة متواصلة طوال اليوم* and never insurance/legal cover. Composing the two gives `تغطية` + `الصلاة اليومية`; because `الصلاة` is its genitive, the insurance reading (which needs `تأمينية`) is unavailable. No glossary edit proposed. |
| `engaged` used as a bare chip on a people group | `مُنخرَطة` (feminine) | glossary.ar.md §2 heading `المجموعة الشعبية المنخرطة`; ar.tsv line 5 inflects the same participle feminine for `جماعة … غير مُنخرَطة`. Inflection only — the lexical choice stays the glossary's `انخراط` family. |
| `partial` (spoken engagement status) | `جزئي` | glossary.ar.md §1 `ضعيفة الانخراط`: partial-progress vocabulary must describe insufficiency of the *work*, not indifference of the *people*. `جزئي` predicates degree of fulfilment on the marker, and is spoken as an isolated node so needs no agreement. |
| `feedback` (feature noun and the thing sent) | `التعليقات` / `التعليق` | Not glossaried; the approved key `feedback` = `التعليقات` already fixed it, and glossary.ar.md §9 requires one consistent rendering per UI label for usability. All 15 `feedback*` keys now use this single root. |
| `exact alarms` | `المنبّهات الدقيقة` (F-AR-05) | Un-glossaried platform term; plan §4.3 mandates matching the OS settings screen, which in Arabic is `المنبّهات والتذكيرات`. Keeps `الإشعارات` free for notifications. |
| `verification email` / to verify | `رسالة التحقق` / `التحقق` | Un-glossaried; the file had already settled on it across `resendVerification*` and `newsSignupSuccessBody`, so it was adopted rather than re-invented. Only the *instruction* verb "check" moves off this root (F-AR-07). |
| `reminder` | `التذكير` / `تذكيرات` | Un-glossaried; already uniform across `reminders`, `setReminder`, `prayerReminder*`, `dismissReminderLabel`, `exactAlarms*`. Kept. |
| `notifications` / `push notifications` | `الإشعارات` / `الإشعارات الفورية` | Un-glossaried; `الإشعارات` is the file's settled term, and `الإشعارات الفورية` is the standard Arabic for the *push* channel — needed to translate `enableNotificationsPromptBody` without saying `الإشعارات` twice in the same sense. |
| `enable` (notifications) | `تمكين` / `قم بتمكين` | Un-glossaried; taken from the approved `enableNotifications` = `تمكين الإشعارات` and `notifications_enabled` = `تم تمكين الإشعارات`, and the `قم بـ` instruction pattern of `notificationsHowToEnable`. One verb for one action. |
| `compliment` | `إشادة` (F-AR-06) | Un-glossaried; glossary.ar.md §9's usability principle plus the conventional Arabic feedback triad `مشكلة/شكوى · اقتراح · إشادة`. |
| `profile` | `الملف الشخصي` | Un-glossaried; approved key `profile` reused verbatim in `viewProfile`. |
| `sign up` (button) | `التسجيل` (masdar), not glossary §9's imperative `سجّل` | ar.tsv line 85 gives `sign up` → `التسجيل`, and glossary.ar.md §9's own note for that row glosses it as `الاشتراك/التسجيل` — the imperative `سجّل` there is the website's CTA voice. This app's button house style is the masdar (`حفظ`, `مشاركة`, `تمكين الإشعارات`), and `newsSignupSuccessTitle` = `شكرًا لتسجيلك` already depends on this root. Recorded because it is the one place I preferred the tsv's form over the glossary's headword. |
| Arabic plural categories for `{seconds}` | ICU `zero/one/two/few/many/other` (F-AR-11) | Not a glossary matter; CLDR. Flat fallback stated in the finding. |
