
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  /// Email/Password Sign-Up & Sign-In
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (_) {
      throw const AuthException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (_) {
      throw const AuthException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e, stackTrace) {
      print('=== GOOGLE SIGN-IN FirebaseAuthException ===');
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      print('StackTrace: $stackTrace');
      throw _mapFirebaseException(e);
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      print('=== GOOGLE SIGN-IN ERROR ===');
      print('Type: ${e.runtimeType}');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      throw AuthException('Google sign-in failed: $e');
    }
  }

  /// Sign-Out

  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (_) {
      throw const AuthException('Failed to sign out. Please try again.');
    }
  }

  /// Password Reset

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (_) {
      throw const AuthException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Exception Mapping

  AuthException _mapFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      // ── Sign-up errors ──
      case 'weak-password':
        return const AuthException(
          'Password is too weak. Use at least 6 characters.',
        );
      case 'email-already-in-use':
        return const AuthException(
          'An account already exists with this email.',
        );

      // ── Sign-in errors ──
      case 'user-not-found':
        return const AuthException('No account found with this email.');
      case 'wrong-password':
        return const AuthException('Incorrect password. Please try again.');
      case 'invalid-credential':
        return const AuthException('Invalid email or password.');
      case 'invalid-email':
        return const AuthException('The email address is not valid.');
      case 'user-disabled':
        return const AuthException(
          'This account has been disabled. Contact support.',
        );

      // ── Token / session errors ──
      case 'expired-action-code':
        return const AuthException(
          'This link has expired. Please request a new one.',
        );
      case 'invalid-action-code':
        return const AuthException(
          'This link is invalid or has already been used.',
        );
      case 'user-token-expired':
        return const AuthException(
          'Your session has expired. Please sign in again.',
        );
      case 'invalid-user-token':
        return const AuthException('Invalid session. Please sign in again.');
      case 'user-mismatch':
        return const AuthException(
          'Credentials do not match the current user.',
        );

      // ── Re-authentication errors ──
      case 'requires-recent-login':
        return const AuthException(
          'Please sign in again to complete this action.',
        );

      // ── Network errors ──
      case 'network-request-failed':
        return const AuthException(
          'Network error. Check your internet connection.',
        );
      default:
        return AuthException(
          e.message ?? 'Authentication failed. Please try again.',
        );
    }
  }
}

/// Custom auth exception
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
