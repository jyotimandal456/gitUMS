import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  AuthProvider() {
    initializeGoogle();
  }

  Future<void> initializeGoogle() async {
    await googleSignIn.initialize(
      serverClientId: dotenv.env['WEB_CLIENT'],
      clientId: Platform.isAndroid
          ? dotenv.env['ANDROID_CLIENT']
          : dotenv.env['IOS_CLIENT'],
    );
  }

  Future<String?> login(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await supabase.auth.signUp(email: email, password: password);

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<bool> continueWithGoogle() async {
    try {
      final account = await googleSignIn.authenticate();

      if (account == null) {
        return false;
      }

      final idToken = account.authentication.idToken;

      if (idToken == null) {
        return false;
      }

      final authorization = await account.authorizationClient
          .authorizationForScopes(['email', 'profile']);

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,

        idToken: idToken,

        accessToken: authorization?.accessToken,
      );

      return true;
    } catch (e) {
      debugPrint("Google Sign In Error: $e");

      return false;
    }
  }
}
