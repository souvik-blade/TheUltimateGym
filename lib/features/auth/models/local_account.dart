import '../../diet/models/user_profile.dart';

/// Display-unit preference. Purely a display-layer conversion — the stored
/// body metrics and BmrCalculator stay metric internally regardless of this.
enum Units { metric, imperial }

/// A local, on-device "account" — no server, no real session. Composes the
/// diet feature's [UserProfile] instead of duplicating its fields, so the
/// pure, already-tested BMR/TDEE calculator never has to know accounts
/// exist.
class LocalAccount {
  const LocalAccount({
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.bodyMetrics,
    this.units = Units.metric,
    this.onboardingComplete = false,
  });

  final String name;
  final String email;
  final String passwordHash;
  final UserProfile bodyMetrics;
  final Units units;
  final bool onboardingComplete;

  LocalAccount copyWith({
    String? name,
    String? email,
    String? passwordHash,
    UserProfile? bodyMetrics,
    Units? units,
    bool? onboardingComplete,
  }) {
    return LocalAccount(
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      bodyMetrics: bodyMetrics ?? this.bodyMetrics,
      units: units ?? this.units,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
