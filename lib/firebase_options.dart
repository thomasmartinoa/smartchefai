// ignore_for_file: dangling_library_doc_comments

/// Firebase configuration options
/// 
/// ⚠️ IMPORTANT: This is a placeholder file!
/// 
/// To generate the actual configuration, run:
/// ```
/// flutterfire configure --project=YOUR_PROJECT_ID
/// ```
/// 
/// This will create the proper firebase_options.dart with your project's
/// actual configuration values.
/// 
/// See FIREBASE_SETUP.md for detailed instructions.

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
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ⚠️ PLACEHOLDER VALUES - Replace with your actual Firebase config
  // Run: flutterfire configure --project=YOUR_PROJECT_ID

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCVlaM6qdTU6G0cZkGe1Dc7c3mr2uvkk1E',
    appId: '1:363654315902:web:f4277ec6cabb731b37fd2f',
    messagingSenderId: '363654315902',
    projectId: 'smartchefai-344c5',
    authDomain: 'smartchefai-344c5.firebaseapp.com',
    storageBucket: 'smartchefai-344c5.firebasestorage.app',
    measurementId: 'G-Q75R5P80JN',
  );

  

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfSksNPgjVi_hAhU2hzP9TjG2RqxaDzM8',
    appId: '1:363654315902:android:cd6584fce56de1ad37fd2f',
    messagingSenderId: '363654315902',
    projectId: 'smartchefai-344c5',
    storageBucket: 'smartchefai-344c5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.smartchef.smartchefai',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.smartchef.smartchefai',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}