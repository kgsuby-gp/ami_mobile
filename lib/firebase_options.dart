// Generated manually to bypass CLI authentication issues
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not configured');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBo-NRGJ0uZLerKSBHWX0pjQQLONEP0wM0',
    appId: '1:1070104521096:android:3e07918b7763bb8800723d',
    messagingSenderId: '1070104521096',
    projectId: 'my-ami-hub-app',
    storageBucket: 'my-ami-hub-app.firebasestorage.app',
  );
}
