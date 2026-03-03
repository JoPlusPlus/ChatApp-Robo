enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool? emailVerified;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
  final String? bio;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.emailVerified,
    this.creationTime,
    this.lastSignInTime,
    this.bio,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? emailVerified,
    DateTime? creationTime,
    DateTime? lastSignInTime,
    String? bio,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      bio: bio ?? this.bio,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          userId == other.userId &&
          email == other.email &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          phoneNumber == other.phoneNumber &&
          emailVerified == other.emailVerified &&
          bio == other.bio &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
    status,
    userId,
    email,
    displayName,
    photoUrl,
    phoneNumber,
    emailVerified,
    bio,
    errorMessage,
  );

  @override
  String toString() =>
      'AuthState(status: $status, userId: $userId, email: $email, displayName: $displayName, error: $errorMessage)';
}
