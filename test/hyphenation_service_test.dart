import 'package:doxa_prayer_mobile_app/services/hyphenation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:hyphenatorx/languages/language_en_us.dart';
import 'package:hyphenatorx/languages/language_es.dart';
import 'package:hyphenatorx/languages/language_fr.dart';
import 'package:hyphenatorx/languages/language_pt.dart';
import 'package:hyphenatorx/languages/language_ru.dart';

/// The test font (Ahem) renders every glyph [fontSize] wide, so widths are
/// predictable: a 36px style at 288px of width fits exactly 8 characters.
const TextStyle style = TextStyle(fontSize: 36);
const double maxWidth = 288;

double lineWidth(String text) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

String wrap(
  String text,
  Hyphenator hyphenator, {
  String locale = 'en',
  double width = maxWidth,
}) => hyphenateForWidth(
  text: text,
  style: style,
  maxWidth: width,
  hyphenator: hyphenator,
  localeCode: locale,
);

/// Every produced line fits, and nothing was lost: stripping the inserted
/// hyphens and newlines gives back the original words.
void expectWraps(String original, String result, {double width = maxWidth}) {
  for (final line in result.split('\n')) {
    expect(
      lineWidth(line),
      lessThanOrEqualTo(width),
      reason: 'line "$line" overflows $width',
    );
  }
  expect(
    result.replaceAll('-\n', '').replaceAll('\n', ' '),
    original,
    reason: 'text was altered beyond hyphens and line breaks',
  );
}

void main() {
  late Hyphenator en;
  late Hyphenator ru;

  setUpAll(() {
    en = Hyphenator(Language_en_us());
    ru = Hyphenator(Language_ru());
  });

  tearDown(resetHyphenationForTest);

  group('leaves text alone when it can', () {
    test('short text is untouched', () {
      expect(wrap('Settings', en), 'Settings');
    });

    test('a sentence whose words all fit is untouched', () {
      // Wider than the line, but Flutter can wrap it at spaces itself.
      const text = 'Pray for the people of the world today';
      expect(wrap(text, en), text);
    });

    test('empty and whitespace input is untouched', () {
      expect(wrap('', en), '');
      expect(wrap('   ', en), '   ');
    });

    test('unbounded or zero width is untouched', () {
      expect(
        wrap('Congregationalism', en, width: double.infinity),
        'Congregationalism',
      );
      expect(wrap('Congregationalism', en, width: 0), 'Congregationalism');
    });
  });

  group('hyphenates words that do not fit', () {
    test('a long English word breaks with visible hyphens', () {
      const word = 'Congregationalism';
      final result = wrap(word, en);
      expect(result, contains('-\n'));
      expectWraps(word, result);
    });

    test('a long Russian word breaks with visible hyphens', () {
      const word = 'Зарегистрироваться';
      final result = wrap(word, ru, locale: 'ru');
      expect(result, contains('-\n'));
      expectWraps(word, result);
    });

    test('a word needing three lines keeps breaking', () {
      const word = 'Зарегистрироваться';
      final result = wrap(word, ru, locale: 'ru', width: 216);
      expect(result.split('\n').length, greaterThanOrEqualTo(3));
      expectWraps(word, result, width: 216);
    });

    test('a word whose first syllable cannot fit is left to the engine', () {
      // 'Зарегистрироваться' breaks first after 'Заре', so 'Заре-' (5 glyphs)
      // is the narrowest possible first line. Below that there is no break to
      // make, and the word is passed through for Flutter to break mid-character
      // rather than mangled.
      const word = 'Зарегистрироваться';
      expect(wrap(word, ru, locale: 'ru', width: 144), word);
    });

    test('preceding words stay on the line before the break', () {
      const text = 'and Congregationalism';
      final result = wrap(text, en);
      expect(result.split('\n').first, startsWith('and '));
      expectWraps(text, result);
    });

    test('explicit newlines are preserved', () {
      const text = 'Settings\nCongregationalism\nDone';
      final result = wrap(text, en);
      final lines = result.split('\n');
      expect(lines.first, 'Settings');
      expect(lines.last, 'Done');
      expect(result, contains('-\n'));
    });
  });

  group('degrades safely', () {
    test('an unhyphenatable token is left for the engine to break', () {
      const url = 'https://pray.doxa.life/app/kalanga-people';
      // No crash, no invented characters.
      final result = wrap(url, en);
      expect(result.replaceAll('-\n', '').replaceAll('\n', ' '), url);
    });

    test('repeated calls return the same result (cache)', () {
      const word = 'Congregationalism';
      expect(wrap(word, en), wrap(word, en));
    });
  });

  group('every hyphenated app locale has usable patterns', () {
    test('fr and pt hyphenate their long words', () {
      final cases = <String, (Hyphenator, String)>{
        'fr': (Hyphenator(Language_fr()), 'Thessaloniciens'),
        'pt': (Hyphenator(Language_pt()), 'Tessalonicenses'),
      };
      cases.forEach((locale, testCase) {
        final (hyphenator, word) = testCase;
        final result = wrap(word, hyphenator, locale: locale);
        expect(result, contains('-\n'), reason: '$locale did not hyphenate');
        expectWraps(word, result);
      });
    });

    test('spanish patterns are sparse — documented, not a regression', () {
      // hyphenatorx's `es` pattern set is much thinner than its en/fr/pt/ru
      // ones: 'Notificaciones' offers a single break point ('Notifica-') and
      // 'transculturales' offers none at all. Spanish therefore hyphenates only
      // when the line is wide enough for that one break, and otherwise falls
      // back to the pre-existing mid-word break. Replacing the pattern data
      // with hyph-es from hyph-utf8 would fix it.
      final es = Hyphenator(Language_es());
      expect(
        wrap('Notificaciones', es, locale: 'es', width: 360),
        'Notifica-\nciones',
      );
      expect(wrap('Notificaciones', es, locale: 'es'), 'Notificaciones');
      expect(wrap('transculturales', es, locale: 'es'), 'transculturales');
    });

    test('arabic is not a hyphenated locale', () {
      expect(localeSupportsHyphenation(const Locale('ar')), isFalse);
      expect(hyphenatorFor(const Locale('ar')), isNull);
    });
  });
}
