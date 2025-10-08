import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  group('Date Formatting Tests', () {
    setUpAll(() async {
      // Initialize locale data for testing
      await initializeDateFormatting('tr_TR', null);
      await initializeDateFormatting('en_US', null);
    });

    test('should format date in Turkish locale without errors', () {
      final testDate = DateTime(2024, 12, 25, 14, 30);
      
      // Test Turkish date formatting (as used in add_task_page.dart)
      expect(() {
        final formattedDate = DateFormat('dd MMMM yyyy, EEEE', 'tr_TR').format(testDate);
        expect(formattedDate, isNotEmpty);
      }, returnsNormally);
      
      // Test time formatting
      expect(() {
        final formattedTime = DateFormat('HH:mm').format(testDate);
        expect(formattedTime, equals('14:30'));
      }, returnsNormally);
    });

    test('should format date in English locale without errors', () {
      final testDate = DateTime(2024, 12, 25, 14, 30);
      
      // Test English date formatting (as used in other pages)
      expect(() {
        final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(testDate);
        expect(formattedDate, isNotEmpty);
      }, returnsNormally);
      
      // Test shorter format
      expect(() {
        final formattedDate = DateFormat('dd MMM, HH:mm').format(testDate);
        expect(formattedDate, isNotEmpty);
      }, returnsNormally);
    });

    test('should handle different date formats correctly', () {
      final testDate = DateTime(2024, 3, 15, 9, 45);
      
      // Test various formats used in the app
      final formats = [
        'dd MMMM yyyy, EEEE',
        'HH:mm',
        'dd MMM yyyy, HH:mm',
        'dd MMM, HH:mm',
      ];
      
      for (final format in formats) {
        expect(() {
          final formatted = DateFormat(format, 'tr_TR').format(testDate);
          expect(formatted, isNotEmpty);
        }, returnsNormally);
      }
    });
  });
}