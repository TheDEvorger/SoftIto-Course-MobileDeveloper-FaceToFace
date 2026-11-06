import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopmentTesting12345',
    appId: '1:306480492094:android:0a1b2c3d4e5f6g7h8i9j',
    messagingSenderId: '306480492094',
    projectId: 'bearaeit',
    storageBucket: 'bearaeit.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopmentTesting12345',
    appId: '1:306480492094:web:0a1b2c3d4e5f6g7h8i9j',
    messagingSenderId: '306480492094',
    projectId: 'bearaeit',
    authDomain: 'bearaeit.firebaseapp.com',
    storageBucket: 'bearaeit.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopmentTesting12345',
    appId: '1:306480492094:ios:0a1b2c3d4e5f6g7h8i9j',
    messagingSenderId: '306480492094',
    projectId: 'bearaeit',
    storageBucket: 'bearaeit.appspot.com',
    iosBundleId: 'com.example.bearaeit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopmentTesting12345',
    appId: '1:306480492094:ios:0a1b2c3d4e5f6g7h8i9j',
    messagingSenderId: '306480492094',
    projectId: 'bearaeit',
    storageBucket: 'bearaeit.appspot.com',
    iosBundleId: 'com.example.bearaeit',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopmentTesting12345',
    appId: '1:306480492094:web:0a1b2c3d4e5f6g7h8i9j',
    messagingSenderId: '306480492094',
    projectId: 'bearaeit',
    authDomain: 'bearaeit.firebaseapp.com',
    storageBucket: 'bearaeit.appspot.com',
  );
}

