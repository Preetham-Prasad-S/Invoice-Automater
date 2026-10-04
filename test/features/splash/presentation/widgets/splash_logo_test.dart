import 'package:app_prototype/features/splash/presentation/widgets/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Paints the splash logo and flushes image decoding so asset errors surface.
  Future<void> pumpLogo(WidgetTester tester, {double size = 144}) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: SplashLogo(size: size))),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders without errors', (tester) async {
    await pumpLogo(tester);

    expect(find.byType(SplashLogo), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('uses the shipped app icon asset', (tester) async {
    await pumpLogo(tester);

    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/icon.png');
  });

  testWidgets('resolves the asset without throwing', (tester) async {
    // Guards the "file exists but is not declared under pubspec assets" trap
    // that silently breaks dotenv and image loading at runtime.
    await pumpLogo(tester);

    await expectLater(
      precacheImage(
        const AssetImage(SplashLogo.assetPath),
        tester.element(find.byType(SplashLogo)),
      ),
      completes,
    );
  });

  testWidgets('honours the requested size', (tester) async {
    await pumpLogo(tester, size: 200);

    final box = tester.getSize(find.byType(SplashLogo));
    expect(box.width, 200);
    expect(box.height, 200);
  });

  testWidgets('renders as a single layer with no glow', (tester) async {
    // The logo is just the artwork: no stacked backdrop, no box shadow.
    // Scoped to descendants because MaterialApp itself contains a Stack.
    await pumpLogo(tester);

    final logo = find.byType(SplashLogo);
    expect(
      find.descendant(of: logo, matching: find.byType(Stack)),
      findsNothing,
    );
    expect(
      find.descendant(
        of: logo,
        matching: find.byWidgetPredicate((widget) {
          if (widget is! Container) return false;
          final decoration = widget.decoration;
          return decoration is BoxDecoration && decoration.boxShadow != null;
        }),
      ),
      findsNothing,
    );
  });
}