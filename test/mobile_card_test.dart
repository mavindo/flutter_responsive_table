// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_table/responsive_table.dart';

void main() {
  testWidgets('mobile card shows value with ellipsis and maxLines=1',
      (WidgetTester tester) async {
    final headers = [
      DatatableHeader(text: 'LongField', value: 'long', show: true),
    ];

    final longString = List.filled(1, 'very_long_value_').join() +
        List.generate(50, (i) => 'x').join();

    final source = [
      {'long': longString},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          // provide a small size so adaptivex reports a small screen size
          data: const MediaQueryData(size: Size(360, 800)),
          child: Scaffold(
            body: ResponsiveDatatable(
              headers: headers,
              source: source,
              reponseScreenSizes: [ScreenSize.xs], // force mobile view
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final finder = find.text(longString);
    expect(finder, findsOneWidget);

    final Text textWidget = tester.widget<Text>(finder);
    expect(textWidget.maxLines, 1);
    expect(textWidget.overflow, TextOverflow.ellipsis);
  });
}
