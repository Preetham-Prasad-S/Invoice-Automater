import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_prototype/app/theme/app_colors.dart';
import 'package:app_prototype/features/splash/presentation/widgets/splash_progress_bar.dart';

void main() {
  testWidgets('applies the splash design tokens', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 200, child: SplashProgressBar(progress: 0.5)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final bar = tester.widget<SplashProgressBar>(find.byType(SplashProgressBar));
    expect(bar.progress, 0.5);

    final fill = tester.widget<Container>(
      find.descendant(
        of: find.byType(SplashProgressBar),
        matching: find.byKey(const Key('app_progress_bar_fill')),
      ),
    );
    expect(fill.color!.toARGB32(), AppColors.primary.toARGB32());
  });
}
