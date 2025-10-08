## Görev Bildirim Sistemi

Bu uygulama artık görevler için otomatik bildirimler gönderebiliyor! 🔔

### Özellikler

- **Üç aşamalı bildirim sistemi:**
  - 📅 **1 gün önce**: "Görev Hatırlatması - 1 Gün Kaldı"
  - ⏰ **1 saat önce**: "Görev Hatırlatması - 1 Saat Kaldı" 
  - ⚠️ **30 dakika önce**: "Görev Hatırlatması - 30 Dakika Kaldı"

- **Platform desteği:**
  - ✅ Android (API 21+)
  - ✅ iOS (10.0+)

### Nasıl Çalışır

1. **Görev Oluşturma**: Yeni bir görev oluştururken son tarih belirtildiğinde, sistem otomatik olarak üç farklı bildirim zamanlar.

2. **Görev Güncelleme**: Bir görevin son tarihi değiştirildiğinde, eski bildirimler iptal edilir ve yeni bildirimler programlanır.

3. **Görev Silme**: Bir görev silindiğinde, o görevle ilgili tüm bildirimler iptal edilir.

### Teknik Detaylar

#### Kullanılan Paketler
- `flutter_local_notifications`: Yerel bildirimler için
- `timezone`: Zaman dilimi yönetimi için
- `permission_handler`: İzin yönetimi için

#### Önemli Notlar

**Android İçin:**
- `SCHEDULE_EXACT_ALARM` izni eklendi (Android 12+)
- `WAKE_LOCK`, `VIBRATE`, `RECEIVE_BOOT_COMPLETED` izinleri eklendi
- Boot receiver eklendi (cihaz yeniden başlatıldığında bildirimler korunur)

**iOS İçin:**
- Bildirim izinleri otomatik olarak istenir
- Background modes eklendi
- UserNotifications framework entegrasyonu

### Kullanım Örnekleri

```dart
// Yeni görev için bildirim programlama
await NotificationService.scheduleTaskNotifications(
  'task_123',
  'Proje teslimi',
  DateTime(2024, 12, 25, 14, 30),
);

// Görev bildirimlerini iptal etme
await NotificationService.cancelTaskNotifications('task_123');

// Tüm bildirimleri iptal etme
await NotificationService.cancelAllNotifications();
```

### Test Etme

1. **Uygulama çalıştır**: `flutter run`
2. **Yeni görev ekle**: Son tarih olarak gelecekteki bir zaman seç
3. **Bildirimleri kontrol et**: Sistem ayarlarından bildirim izinlerini kontrol et
4. **Test bildirimi**: Birkaç dakika sonrası için görev oluştur ve bildirimi bekle

### Sorun Giderme

**Bildirimler gelmiyor:**
- Uygulama izinlerini kontrol et
- Sistem bildirim ayarlarını kontrol et
- Android'de "Optimize edilmemiş uygulamalar" listesine ekle

**iOS'ta bildirimler çalışmıyor:**
- Ayarlar > Bildirimler > To Do List'i kontrol et
- "Bildirimlere İzin Ver" aktif olmalı

**LocaleDataException Hatası:**
- ✅ **ÇÖZÜLDÜ!** `SafeDateFormat` utility sınıfı eklendi
- Türkçe ve İngilizce tarih formatları güvenli bir şekilde destekleniyor
- Hata durumunda otomatik fallback mekanizması devreye giriyor
- `main.dart` dosyasında `SafeDateFormat.initialize()` çağrısı eklendi

### Güvenlik

- Tüm bildirimler yerel olarak cihazda işlenir
- Hiçbir bildirim verisi sunucuya gönderilmez
- Kullanıcı istediği zaman tüm bildirimleri iptal edebilir