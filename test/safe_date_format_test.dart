import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/utils/safe_date_format.dart';

void main() {
  group('SafeDateFormat Tests', () {
    test('should format Turkish date without errors', () {
      final testDate = DateTime(2024, 12, 25, 14, 30);
      
      expect(() {
        final result = SafeDateFormat.formatTurkishDate(testDate);
        expect(result, isNotEmpty);
        expect(result, contains('2024'));
      }, returnsNormally);
    });

    test('should format time without errors', () {
      final testDate = DateTime(2024, 12, 25, 14, 30);
      
      final result = SafeDateFormat.formatTime(testDate);
      expect(result, equals('14:30'));
    });

    test('should format English date time without errors', () {
      final testDate = DateTime(2024, 3, 15, 9, 45);
      
      expect(() {
        final result = SafeDateFormat.formatEnglishDateTime(testDate);
        expect(result, isNotEmpty);
        expect(result, contains('Mar'));
        expect(result, contains('2024'));
        expect(result, contains('09:45'));
      }, returnsNormally);
    });

    test('should format short date time without errors', () {
      final testDate = DateTime(2024, 6, 10, 16, 20);
      
      expect(() {
        final result = SafeDateFormat.formatShortDateTime(testDate);
        expect(result, isNotEmpty);
        expect(result, contains('Jun'));
        expect(result, contains('16:20'));
      }, returnsNormally);
    });

    test('should handle edge cases gracefully', () {
      // Test with very early and late dates
      final earlyDate = DateTime(1900, 1, 1, 0, 0);
      final lateDate = DateTime(2100, 12, 31, 23, 59);
      
      expect(() {
        SafeDateFormat.formatTime(earlyDate);
        SafeDateFormat.formatTime(lateDate);
        SafeDateFormat.formatTurkishDate(earlyDate);
        SafeDateFormat.formatTurkishDate(lateDate);
      }, returnsNormally);
    });

    test('should initialize without errors', () async {
      expect(() async {
        await SafeDateFormat.initialize();
      }, returnsNormally);
    });
  });
}