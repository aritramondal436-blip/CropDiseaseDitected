import 'package:shared_preferences/shared_preferences.dart';

/// Raised when authentication fails or the request cannot be completed.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Email remembered for the next login attempt.
class RememberedLogin {
  const RememberedLogin({required this.email});

  final String email;
}

/// Demo authentication layer for AgroVision.
///
/// No backend is configured yet, so [login] simulates a short network round
/// trip and accepts any valid form input. The public surface is intentionally
/// small so it can be swapped for a real REST implementation later without
/// touching the login UI.
class AuthService {
  const AuthService({this.delay = const Duration(milliseconds: 1200)});

  final Duration delay;

  static const String _rememberKey = 'agrovision.remember_me';
  static const String _emailKey = 'agrovision.remembered_email';

  Future<void> login({required String email, required String password}) async {
    await Future<void>.delayed(delay);
    if (email.trim().isEmpty || password.isEmpty) {
      throw const AuthException('Please enter your email and password.');
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    await Future<void>.delayed(delay);
    if (email.trim().isEmpty) {
      throw const AuthException('Please enter your email address.');
    }
  }

  Future<RememberedLogin?> loadRememberedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_rememberKey) ?? false)) return null;
    final email = prefs.getString(_emailKey);
    if (email == null || email.isEmpty) return null;
    return RememberedLogin(email: email);
  }

  Future<void> saveRememberedLogin({required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberKey, true);
    await prefs.setString(_emailKey, email);
  }

  Future<void> clearRememberedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberKey, false);
    await prefs.remove(_emailKey);
  }
}
