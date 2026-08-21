import 'package:flutter/foundation.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../diet/models/user_profile.dart';
import '../models/local_account.dart';
import '../password_hasher.dart';

/// Shared app-wide auth/profile state. "Signed in" is an in-memory-only
/// flag — logging out never deletes the stored account, it just hides the
/// app behind the login screen again until the password is re-entered.
class ProfileController extends ChangeNotifier {
  ProfileController({ProfileRepository? repository})
    : _repository = repository ?? ProfileRepository();

  final ProfileRepository _repository;

  LocalAccount? _account;
  bool _isInitialized = false;
  bool _isSignedIn = false;

  LocalAccount? get account => _account;
  bool get isInitialized => _isInitialized;
  bool get isSignedIn => _isSignedIn;
  bool get hasAccount => _account != null;

  /// Loads any existing local account. Called once at app startup.
  Future<void> initialize() async {
    _account = await _repository.getAccount();
    _isSignedIn = _account != null;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserProfile bodyMetrics,
  }) async {
    final account = LocalAccount(
      name: name,
      email: email,
      passwordHash: PasswordHasher.hash(password),
      bodyMetrics: bodyMetrics,
      onboardingComplete: true,
    );
    await _repository.saveAccount(account);
    _account = account;
    _isSignedIn = true;
    notifyListeners();
  }

  /// Returns false without side effects if the email/password don't match
  /// the stored account — callers show a validation error, nothing crashes.
  Future<bool> login({required String email, required String password}) async {
    final account = _account;
    if (account == null) return false;
    final emailMatches = account.email.toLowerCase() == email.toLowerCase();
    final passwordMatches = PasswordHasher.verify(password, account.passwordHash);
    if (!emailMatches || !passwordMatches) return false;
    _isSignedIn = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isSignedIn = false;
    notifyListeners();
  }

  Future<void> updateBodyMetrics(UserProfile metrics) async {
    final account = _account;
    if (account == null) return;
    final updated = account.copyWith(bodyMetrics: metrics);
    await _repository.saveAccount(updated);
    _account = updated;
    notifyListeners();
  }

  Future<void> updateSettings({String? name, Units? units}) async {
    final account = _account;
    if (account == null) return;
    final updated = account.copyWith(name: name, units: units);
    await _repository.saveAccount(updated);
    _account = updated;
    notifyListeners();
  }

  /// Full wipe — distinct from [logout]: this deletes the on-device profile
  /// entirely, sending the app back to the Welcome/Register flow.
  Future<void> resetAppData() async {
    await _repository.clear();
    _account = null;
    _isSignedIn = false;
    notifyListeners();
  }
}
