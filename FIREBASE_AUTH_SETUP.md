# Firebase Authentication Setup Guide

This guide walks you through setting up Firebase Authentication with Email/Password and Google Sign-In for SmartChef AI.

## Prerequisites

- Firebase project created (see main FIREBASE_SETUP.md)
- Firebase SDK initialized in your Flutter app
- `firebase_auth` and `google_sign_in` packages added to pubspec.yaml

## Table of Contents

1. [Enable Authentication Methods](#enable-authentication-methods)
2. [Configure Google Sign-In](#configure-google-sign-in)
   - [Android Configuration](#android-configuration)
   - [iOS Configuration](#ios-configuration)
   - [Web Configuration](#web-configuration)
3. [Testing Authentication](#testing-authentication)
4. [Troubleshooting](#troubleshooting)

## Enable Authentication Methods

### 1. Enable Email/Password Authentication

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Authentication** → **Sign-in method**
4. Click on **Email/Password**
5. Enable the **Email/Password** provider
6. Optionally enable **Email link (passwordless sign-in)**
7. Click **Save**

### 2. Enable Google Sign-In

1. In **Authentication** → **Sign-in method**
2. Click on **Google**
3. Enable the Google provider
4. Enter your project support email
5. Click **Save**

## Configure Google Sign-In

### Android Configuration

#### Step 1: Get SHA-1 and SHA-256 Certificates

You need to add your app's SHA-1 and SHA-256 fingerprints to Firebase.

**For Debug Build:**

```bash
# Windows (PowerShell)
cd android
./gradlew signingReport

# Look for SHA-1 and SHA-256 under "Variant: debug"
```

**For Release Build:**

If you have a release keystore:

```bash
keytool -list -v -keystore path/to/your/keystore.jks -alias your-alias
```

#### Step 2: Add SHA Certificates to Firebase

1. Go to Firebase Console → Project Settings
2. Under **Your apps**, find your Android app
3. Click on the app
4. Scroll to **SHA certificate fingerprints**
5. Click **Add fingerprint**
6. Add both SHA-1 and SHA-256 fingerprints
7. Download the updated `google-services.json`
8. Replace the old file in `android/app/google-services.json`

#### Step 3: Verify android/build.gradle

Ensure you have Google services plugin:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

#### Step 4: Verify android/app/build.gradle

Ensure the plugin is applied at the bottom:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### iOS Configuration

#### Step 1: Download GoogleService-Info.plist

1. Go to Firebase Console → Project Settings
2. Under **Your apps**, find your iOS app
3. Download `GoogleService-Info.plist`
4. Open Xcode: `open ios/Runner.xcworkspace`
5. Drag `GoogleService-Info.plist` into the `Runner` folder in Xcode
6. Make sure **Copy items if needed** is checked
7. Make sure **Runner** target is selected

#### Step 2: Get iOS OAuth Client ID

1. Open `GoogleService-Info.plist` (you can use any text editor)
2. Find and copy the value for `CLIENT_ID`
3. Also note the `REVERSED_CLIENT_ID`

#### Step 3: Add URL Scheme

The `REVERSED_CLIENT_ID` should already be in your `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Copy from REVERSED_CLIENT_ID in GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

#### Step 4: Add Required Permissions

Make sure `Info.plist` has keychain access:

```xml
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)com.yourcompany.smartchefai</string>
</array>
```

### Web Configuration

#### Step 1: Get Web Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** → **Credentials**
4. Find the Web client (auto-created by Firebase)
5. Copy the **Client ID** (ends with `.apps.googleusercontent.com`)

#### Step 2: Update index.html

Add the Google Sign-In meta tag in `web/index.html`:

```html
<head>
  <!-- Other meta tags -->
  
  <!-- Google Sign-In -->
  <meta name="google-signin-client_id" 
        content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com">
</head>
```

#### Step 3: Configure Authorized Domains

1. In Firebase Console → Authentication → Settings
2. Under **Authorized domains**, add:
   - `localhost` (for local testing)
   - Your production domain

## Testing Authentication

### Test Email/Password

1. Run the app: `flutter run`
2. Navigate to Sign Up screen
3. Enter name, email, and password
4. Verify account is created in Firebase Console → Authentication → Users

### Test Google Sign-In

#### Android

1. Make sure you've added SHA-1 and SHA-256
2. Run: `flutter run`
3. Click "Continue with Google"
4. Select a Google account
5. Verify sign-in is successful

#### iOS

1. Make sure GoogleService-Info.plist is in Xcode
2. Make sure URL scheme is configured
3. Run: `flutter run`
4. Click "Continue with Google"
5. Select a Google account
6. Verify sign-in is successful

#### Web

1. Make sure Web Client ID is in index.html
2. Run: `flutter run -d chrome`
3. Click "Continue with Google"
4. Complete OAuth flow in popup
5. Verify sign-in is successful

## Troubleshooting

### Common Issues

#### Android: "Error 10" or "Developer Error"

**Solution:**
- Verify SHA-1 and SHA-256 are correctly added to Firebase
- Make sure you're using the correct keystore
- Download and replace `google-services.json`
- Clean and rebuild: `flutter clean && flutter run`

#### iOS: "No valid keychain entries found"

**Solution:**
- Verify `GoogleService-Info.plist` is in Xcode project
- Check that keychain-access-groups is in Info.plist
- Make sure URL scheme matches REVERSED_CLIENT_ID

#### Web: "idpiframe_initialization_failed"

**Solution:**
- Check that Web Client ID is correct in index.html
- Verify domain is authorized in Firebase Console
- Clear browser cache and cookies
- Check browser console for detailed errors

#### General: "PlatformException(sign_in_failed)"

**Solution:**
- Check Firebase Authentication is enabled for Google provider
- Verify OAuth client is configured in Google Cloud Console
- Make sure support email is set in Firebase Console
- Check that all platform-specific configurations are correct

### Debug Steps

1. **Check Firebase Console:**
   - Authentication → Users (verify users can be created)
   - Authentication → Sign-in method (verify providers are enabled)

2. **Check Platform Configuration:**
   - Android: SHA certificates and google-services.json
   - iOS: GoogleService-Info.plist and URL schemes
   - Web: Client ID in index.html

3. **Check Logs:**
   ```bash
   flutter run --verbose
   ```
   Look for authentication-related errors

4. **Test with Firebase Console:**
   - Try creating a test user manually
   - Verify email/password authentication works independently

### Getting Help

If you encounter issues:

1. Check [Firebase Documentation](https://firebase.google.com/docs/auth)
2. Check [Google Sign-In Documentation](https://pub.dev/packages/google_sign_in)
3. Search [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase-authentication)
4. Check [FlutterFire GitHub Issues](https://github.com/firebase/flutterfire/issues)

## Security Best Practices

1. **Never commit sensitive files:**
   - `google-services.json`
   - `GoogleService-Info.plist`
   - Add them to `.gitignore`

2. **Use different Firebase projects:**
   - Development
   - Staging
   - Production

3. **Configure password requirements:**
   - In Firebase Console → Authentication → Settings
   - Enable email enumeration protection
   - Configure password policy

4. **Enable App Check:**
   - Protect your backend from abuse
   - Configure in Firebase Console → App Check

5. **Monitor authentication:**
   - Check Firebase Console → Authentication → Usage
   - Set up alerts for suspicious activity

## Next Steps

After completing authentication setup:

1. ✅ Test all authentication flows
2. ✅ Verify users appear in Firebase Console
3. ✅ Test password reset functionality
4. ✅ Configure additional security settings
5. ✅ Set up user profile management in Firestore

## Resources

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [FlutterFire Auth Plugin](https://firebase.flutter.dev/docs/auth/overview)
- [Google Sign-In Package](https://pub.dev/packages/google_sign_in)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
