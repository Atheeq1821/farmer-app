// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTmVODJ-ZJ26Fmq6PbEB0UWnt_uVmG_QY',
    appId: '1:1063266749253:android:2fe7e8aa2c0640677b8c2c',
    messagingSenderId: '1063266749253',
    projectId: 'svastha-f2785',
    databaseURL: 'https://svastha-f2785-default-rtdb.firebaseio.com',
    storageBucket: 'svastha-f2785.firebasestorage.app',
  );
}
