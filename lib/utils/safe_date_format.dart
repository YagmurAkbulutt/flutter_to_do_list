import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SafeDateFormat {
  static bool _isInitialized = false;
  
  /// Ensures locale data is initialized before formatting
  static Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initializeDateFormatting('tr_TR', null);
      await initializeDateFormatting('en_US', null);
      _isInitialized = true;
    }
  }
  
  /// Safe Turkish date formatting with fallback
  static String formatTurkishDate(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy, EEEE', 'tr_TR').format(date);
    } catch (e) {
      // Fallback to manual Turkish format
      const monthNames = [
        'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
        'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
      ];
      const dayNames = [
        'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
      ];
      return '${date.day} ${monthNames[date.month - 1]} ${date.year}, ${dayNames[date.weekday - 1]}';
    }
  }
  
  /// Safe Turkish short date formatting
  static String formatTurkishShortDate(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy', 'tr_TR').format(date);
    } catch (e) {
      // Fallback to manual Turkish format
      const monthNames = [
        'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
        'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
      ];
      return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
    }
  }
  
  /// Safe Turkish date and time formatting
  static String formatTurkishDateTime(DateTime date) {
    return '${formatTurkishShortDate(date)}, ${formatTime(date)}';
  }
  
  /// Safe time formatting
  static String formatTime(DateTime date) {
    try {
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      // Fallback to simple time format
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
  
  /// Safe English date and time formatting
  static String formatEnglishDateTime(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      // Fallback to manual formatting
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}, ${formatTime(date)}';
    }
  }
  
  /// Safe short English date and time formatting
  static String formatShortDateTime(DateTime date) {
    try {
      return DateFormat('dd MMM, HH:mm').format(date);
    } catch (e) {
      // Fallback to manual formatting
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${formatTime(date)}';
    }
  }
  
  /// Initialize locale data - call this in main()
  static Future<void> initialize() async {
    await _ensureInitialized();
  }
  
  /// Check if a date is overdue
  static bool isOverdue(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }
  
  /// Get relative time description in Turkish
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.isNegative) {
      final pastDiff = now.difference(date);
      if (pastDiff.inDays > 0) {
        return '${pastDiff.inDays} gün gecikti';
      } else if (pastDiff.inHours > 0) {
        return '${pastDiff.inHours} saat gecikti';
      } else {
        return '${pastDiff.inMinutes} dakika gecikti';
      }
    } else {
      if (difference.inDays > 0) {
        return '${difference.inDays} gün kaldı';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} saat kaldı';
      } else {
        return '${difference.inMinutes} dakika kaldı';
      }
    }
  }
}