import 'package:doxa_prayer_mobile_app/components/nav/details_nav_bar.dart';
import 'package:doxa_prayer_mobile_app/components/nav/nav_bar_title.dart';
import 'package:doxa_prayer_mobile_app/services/hyphenation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:hyphenatorx/languages/language_en_us.dart';

/// Wider than the title slot at 1x in the test font, so it has to wrap.
const String longTitle = 'Sign up for newsletter updates';

Widget host(String title, {double scale = 1.0}) => MaterialApp(
  locale: const Locale('en'),
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: DetailsNavBar(context: context, title: title, onBack: () {}),
          body: const SizedBox.shrink(),
        ),
      ),
    ),
  ),
);

Rect titleRect(WidgetTester tester) => tester.getRect(find.byType(NavBarTitle));

Rect barRect(WidgetTester tester) => tester.getRect(find.byType(AppBar));

void main() {
  setUp(() {
    registerHyphenatorForTest('en', Hyphenator(Language_en_us()));
  });
  tearDown(resetHyphenationForTest);

  testWidgets('a long title wraps rather than being cut to one line', (
    tester,
  ) async {
    await tester.pumpWidget(host(longTitle));

    expect(tester.takeException(), isNull);
    // More than one line: the title is taller than the single-line title is.
    await tester.pumpWidget(host('Settings'));
    final oneLine = titleRect(tester).height;
    await tester.pumpWidget(host(longTitle));
    expect(titleRect(tester).height, greaterThan(oneLine));
  });

  testWidgets('the bar grows so the wrapped title is never clipped', (
    tester,
  ) async {
    for (final scale in [1.0, 2.0, 3.0]) {
      await tester.pumpWidget(host(longTitle, scale: scale));

      expect(tester.takeException(), isNull, reason: 'at ${scale}x');
      final title = titleRect(tester);
      final bar = barRect(tester);
      expect(
        title.bottom,
        lessThanOrEqualTo(bar.bottom),
        reason: 'title overflows the bar at ${scale}x',
      );
      expect(
        title.top,
        greaterThanOrEqualTo(bar.top),
        reason: 'title overflows the top of the bar at ${scale}x',
      );
    }
  });

  testWidgets('a short title leaves the bar at the standard height', (
    tester,
  ) async {
    await tester.pumpWidget(host('Settings'));

    expect(barRect(tester).height, kToolbarHeight);
  });

  testWidgets('the title is capped so it cannot eat the viewport', (
    tester,
  ) async {
    await tester.pumpWidget(host(longTitle, scale: 3.0));

    final lineHeight = NavBarTitle.styleFor(const Color(0xFF000000)).fontSize!;
    expect(
      titleRect(tester).height,
      lessThanOrEqualTo(NavBarTitle.maxLines * lineHeight * 3.0 + 1),
    );
  });

  testWidgets('a title with no back button gets the wider slot', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: DetailsNavBar(context: context, title: longTitle),
            body: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final withoutLeading = titleRect(tester).width;
    await tester.pumpWidget(host(longTitle));
    expect(withoutLeading, greaterThan(titleRect(tester).width));
  });
}
