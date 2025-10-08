import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Firebase is not configured for web.');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('Firebase is not configured for macOS.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJt3FER_YRgjYZHCch3laIvfOR3ZWBRRQ',
    appId: '1:1096624047205:android:8195bff297586be33eb28c',
    messagingSenderId: '1096624047205',
    projectId: 'todolist-15a6c',
    storageBucket: 'todolist-15a6c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZybwnjFCSEaICImMX_R6FmOuOQATSGoM',
    appId: '1:1096624047205:ios:b2169d4d1ea14b913eb28c',
    messagingSenderId: '1096624047205',
    projectId: 'todolist-15a6c',
    storageBucket: 'todolist-15a6c.firebasestorage.app',
    iosBundleId: 'com.example.toDoList',
  );

}
