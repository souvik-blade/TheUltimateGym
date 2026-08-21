import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Turns a password into a storable hash and back-checks it at login.
///
/// This is NOT real account security — there's no per-user salt, no server,
/// no rate limiting. It exists only so the local-only login/register flow
/// behaves like a real form (wrong password actually fails) instead of
/// accepting any input. See REQUIREMENTS.md: auth is an on-device profile,
/// not a real backend.
class PasswordHasher {
  const PasswordHasher._();

  static String hash(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static bool verify(String password, String hash) {
    return PasswordHasher.hash(password) == hash;
  }
}
