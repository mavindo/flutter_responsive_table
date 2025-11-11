// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_table/responsive_table.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ResponsiveDatatable', () {
    testWidgets('should display headers correctly', (WidgetTester tester) async {
      final headers = [
        DatatableHeader(text: 'ID', value: 'id', show: true),
        DatatableHeader(text: 'Name', value: 'name', show: true),
      ];

      final source = [
        {'id': 1, 'name': 'John'},
        {'id': 2, 'name': 'Jane'},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveDatatable(
              headers: headers,
              source: source,
              reponseScreenSizes: [ScreenSize.lg], // Force desktop view
            ),
          ),
        ),
      );

      // Check if headers are displayed
      expect(find.text('ID'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);

      // Check if data is displayed
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Jane'), findsOneWidget);
    });

    testWidgets('should handle empty data gracefully', (WidgetTester tester) async {
      final headers = [
        DatatableHeader(text: 'ID', value: 'id', show: true),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveDatatable(
              headers: headers,
              source: null, // Empty data
              reponseScreenSizes: [ScreenSize.lg],
            ),
          ),
        ),
      );

      // Should not crash with null source
      expect(find.text('ID'), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (WidgetTester tester) async {
      final headers = [
        DatatableHeader(text: 'ID', value: 'id', show: true),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveDatatable(
              headers: headers,
              source: [],
              isLoading: true,
              reponseScreenSizes: [ScreenSize.lg],
            ),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle selection correctly', (WidgetTester tester) async {
      final headers = [
        DatatableHeader(text: 'ID', value: 'id', show: true),
      ];

      final source = [
        {'id': 1, 'name': 'John'},
      ];

      List<Map<String, dynamic>> selectedItems = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveDatatable(
              headers: headers,
              source: source,
              selecteds: selectedItems,
              showSelect: true,
              reponseScreenSizes: [ScreenSize.lg],
            ),
          ),
        ),
      );

      // Should show checkbox
      expect(find.byType(Checkbox), findsWidgets);
    });
  });

  group('DatatableHeader', () {
    test('should create header with required parameters', () {
      final header = DatatableHeader(
        text: 'Test Header',
        value: 'test_value',
      );

      expect(header.text, 'Test Header');
      expect(header.value, 'test_value');
      expect(header.show, true); // default value
      expect(header.sortable, false); // default value
    });

    test('should handle toMap and fromMap correctly', () {
      final header = DatatableHeader(
        text: 'Test Header',
        value: 'test_value',
        sortable: true,
        show: false,
      );

      final map = header.toMap();
      final reconstructed = DatatableHeader.fromMap(map);

      expect(reconstructed.text, header.text);
      expect(reconstructed.value, header.value);
      expect(reconstructed.sortable, header.sortable);
      expect(reconstructed.show, header.show);
    });
  });

  group('TextEditableWidget', () {
    testWidgets('should display initial text correctly', (WidgetTester tester) async {
      final data = {'name': 'John Doe'};
      final header = DatatableHeader(text: 'Name', value: 'name', editable: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextEditableWidget(
              data: data,
              header: header,
            ),
          ),
        ),
      );

      // Should display initial text
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should update data when text changes', (WidgetTester tester) async {
      final data = {'name': 'John'};
      final header = DatatableHeader(text: 'Name', value: 'name', editable: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextEditableWidget(
              data: data,
              header: header,
            ),
          ),
        ),
      );

      // Find the TextField and enter new text
      await tester.enterText(find.byType(TextField), 'Jane');

      // Data should be updated
      expect(data['name'], 'Jane');
    });
  });
}