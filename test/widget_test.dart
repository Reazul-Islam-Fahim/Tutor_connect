import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tutor_connect/app.dart';

void main() {
  testWidgets('App boots and shows the splash screen title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TutorConnectApp()),
    );

    // Splash screen is shown first.
    expect(find.text('TutorConnect'), findsOneWidget);
    expect(find.text('Learn better with the right tutor.'), findsOneWidget);
  });
}
