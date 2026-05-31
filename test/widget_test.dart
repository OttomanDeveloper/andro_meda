// Smoke tests for Chronos.
//
// These are intentionally network-free (no font fetching, no full-app pump) so
// they run fast and deterministically in CI. They cover the responsive
// breakpoint logic and the integrity of the timeline data.

import 'package:flutter_test/flutter_test.dart';
import 'package:safeandromeda/core/hooks/hooks.dart';

void main() {
  group('Responsive breakpoints', () {
    Future<void> pumpAtWidth(
      WidgetTester tester,
      double width,
      void Function(BuildContext context) check,
    ) {
      return tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(
            builder: (BuildContext context) {
              check(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    }

    testWidgets('a phone width is mobile and touch', (
      WidgetTester tester,
    ) async {
      await pumpAtWidth(tester, 400, (BuildContext c) {
        expect(Responsive.isMobile(c), isTrue);
        expect(Responsive.isTablet(c), isFalse);
        expect(Responsive.isDesktop(c), isFalse);
        expect(Responsive.isTouch(c), isTrue);
      });
    });

    testWidgets('a tablet width is tablet and touch', (
      WidgetTester tester,
    ) async {
      await pumpAtWidth(tester, 820, (BuildContext c) {
        expect(Responsive.isMobile(c), isFalse);
        expect(Responsive.isTablet(c), isTrue);
        expect(Responsive.isDesktop(c), isFalse);
        expect(Responsive.isTouch(c), isTrue);
      });
    });

    testWidgets('a wide width is desktop and not touch', (
      WidgetTester tester,
    ) async {
      await pumpAtWidth(tester, 1440, (BuildContext c) {
        expect(Responsive.isDesktop(c), isTrue);
        expect(Responsive.isTouch(c), isFalse);
      });
    });
  });

  test('the timeline exposes nine eras with matching text', () {
    expect(AppSettings.eraCount, 9);
    expect(AppText.eraNames.length, AppSettings.eraCount);
    expect(AppText.eraHeadlines.length, AppSettings.eraCount);
    expect(AppText.eraTimestamps.length, AppSettings.eraCount);
    expect(AppText.eraDescriptions.length, AppSettings.eraCount);
  });
}
