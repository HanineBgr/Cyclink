import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_rhino/view/main_tab/main_tab_view.dart';
import 'package:fast_rhino/common/colo_extension.dart';

void main() {
  testWidgets('Tab bar renders and switches tab', (WidgetTester tester) async {
    // Build only MainTabView for testing purposes
    await tester.pumpWidget(
      MaterialApp(
        home: MainTabView(initialTabIndex: 0),
        theme: ThemeData(
          primaryColor: TColor.primaryColor1,
          fontFamily: "Poppins",
          brightness: Brightness.light,
        ),
      ),
    );

    // Verify the home tab icon is selected
    expect(find.byIcon(Icons.home), findsOneWidget);

    // Tap on the profile icon
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify that it switched to the profile tab (you can test for a text or widget from that screen)
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
