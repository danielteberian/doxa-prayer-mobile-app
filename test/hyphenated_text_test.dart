import 'package:doxa_prayer_mobile_app/components/misc/hyphenated_text.dart';
import 'package:doxa_prayer_mobile_app/layouts/fill_viewport_scroll_view.dart';
import 'package:doxa_prayer_mobile_app/services/hyphenation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:hyphenatorx/languages/language_en_us.dart';

const String longWord = 'Congregationalism';

/// The test font renders every glyph at the font size, so a 17-character word at
/// 18px is 306px wide, and 612px at 2x text scale.
Widget host({
  required double width,
  double scale = 1.0,
  double fontSize = 18,
  String text = longWord,
}) => MaterialApp(
  locale: const Locale('en'),
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: Center(
        child: SizedBox(
          width: width,
          child: HyphenatedText(text, style: TextStyle(fontSize: fontSize)),
        ),
      ),
    ),
  ),
);

Text rendered(WidgetTester tester) => tester.widget<Text>(
  find.descendant(of: find.byType(HyphenatedText), matching: find.byType(Text)),
);

void main() {
  setUp(() {
    registerHyphenatorForTest('en', Hyphenator(Language_en_us()));
  });
  tearDown(resetHyphenationForTest);

  testWidgets('hyphenates a word too wide for its line', (tester) async {
    await tester.pumpWidget(host(width: 300, scale: 2.0));

    expect(rendered(tester).data, contains('-\n'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('leaves text that fits untouched', (tester) async {
    await tester.pumpWidget(host(width: 300, fontSize: 12));

    expect(rendered(tester).data, longWord);
  });

  testWidgets('screen readers get the unbroken word', (tester) async {
    await tester.pumpWidget(host(width: 300, scale: 2.0));

    final text = rendered(tester);
    expect(text.data, isNot(longWord));
    expect(text.semanticsLabel, longWord);
  });

  testWidgets('re-wraps when the text scale changes', (tester) async {
    await tester.pumpWidget(host(width: 300, fontSize: 12));
    expect(rendered(tester).data, longWord);

    await tester.pumpWidget(host(width: 300, fontSize: 12, scale: 3.0));
    expect(rendered(tester).data, contains('-\n'));
  });

  testWidgets('falls back to plain text with no patterns loaded', (
    tester,
  ) async {
    resetHyphenationForTest();

    await tester.pumpWidget(host(width: 300, scale: 2.0));

    expect(rendered(tester).data, longWord);
  });

  testWidgets('falls back to plain text at unbounded width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HyphenatedText(longWord, style: const TextStyle(fontSize: 36)),
        ),
      ),
    );

    expect(rendered(tester).data, longWord);
    expect(tester.takeException(), isNull);
  });

  group('survives widgets that measure their own children', () {
    // A chip and a dropdown both size themselves from their label, so they are
    // the likeliest places for the widget's LayoutBuilder to be asked for
    // something it cannot give.
    Widget scaled(Widget child) => MaterialApp(
      locale: const Locale('en'),
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(3.0)),
          child: Scaffold(
            body: Center(child: SizedBox(width: 300, child: child)),
          ),
        ),
      ),
    );

    testWidgets('IntrinsicHeight and IntrinsicWidth', (tester) async {
      await tester.pumpWidget(
        scaled(
          IntrinsicHeight(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [HyphenatedText(longWord)],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(rendered(tester).data, contains('-\n'));
    });

    testWidgets('ChoiceChip label', (tester) async {
      await tester.pumpWidget(
        scaled(
          Wrap(
            children: [
              ChoiceChip(
                label: const HyphenatedText(longWord),
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('DropdownButtonFormField label and items', (tester) async {
      await tester.pumpWidget(
        scaled(
          DropdownButtonFormField<int>(
            initialValue: 1,
            // Without isExpanded a dropdown lays its item out unbounded, so a
            // long word overflows whether or not it is hyphenated — that is
            // stock DropdownButton behaviour, not this widget's.
            isExpanded: true,
            decoration: const InputDecoration(label: HyphenatedText(longWord)),
            items: const [
              DropdownMenuItem<int>(value: 1, child: HyphenatedText(longWord)),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('works inside FillViewportScrollView at 3x scale', (
    tester,
  ) async {
    // The layout this lives in must not measure intrinsics, or the widget's
    // LayoutBuilder throws.
    tester.view.physicalSize = const Size(360, 690);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(3.0)),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: FillViewportScrollView(
                builder: (context, maxWidth) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    HyphenatedText(longWord, style: TextStyle(fontSize: 18)),
                    SizedBox(key: Key('footer'), height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(rendered(tester).data, contains('-\n'));
  });
}
