import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatwala/feature/auth/data/auth_repository.dart';
import 'package:chatwala/feature/auth/logic/auth_state.dart';
import 'package:chatwala/feature/chat/data/chatservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final ChatService _chatService = ChatService();
  StreamSubscription<User?>? _authSubscription;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    _listenToAuthChanges();
  }
/// Listen to Firebase Auth state changes and update AuthState accordingly
  void _listenToAuthChanges() {
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        // Save/update user profile in Firestore
        _chatService.saveUserProfile(
          uid: user.uid,
          name: user.displayName ?? user.email?.split('@').first ?? 'User',
          email: user.email,
          photoUrl: user.photoURL,
        );

        emit(
          AuthState(
            status: AuthStatus.authenticated,
            userId: user.uid,
            email: user.email ?? '',
            displayName: user.displayName,
            photoUrl: user.photoURL,
            phoneNumber: user.phoneNumber,
            emailVerified: user.emailVerified,
            creationTime: user.metadata.creationTime,
            lastSignInTime: user.metadata.lastSignInTime,
          ),
        );
      } else {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
    });
  }
  /// Sign up with email and password
  Future<void> signUp({required String email, required String password}) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _authRepository.signUp(email: email, password: password);
    } on AuthException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
/// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _authRepository.signIn(email: email, password: password);
    } on AuthException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
/// Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _authRepository.signInWithGoogle();
    } on AuthException catch (e) {
      print('=== AuthCubit Google sign-in AuthException: ${e.message}');
      emit(AuthState(status: AuthStatus.error, errorMessage: e.message));
    } catch (e, stackTrace) {
      print('=== AuthCubit Google sign-in unexpected error: $e');
      print('StackTrace: $stackTrace');
      emit(
        AuthState(
          status: AuthStatus.error,
          errorMessage: 'Google sign-in failed: $e',
        ),
      );
    }
  }
/// Sign 0ut the current user
  Future<void> signOut() async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      // Set user offline before signing out
      final uid = state.userId;
      if (uid != null) {
        await _chatService.setOffline(uid);
      }
      await _authRepository.signOut();
    } on AuthException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Failed to sign out.',
        ),
      );
    }
  }
/// Reset password for the given email
  Future<void> resetPassword({required String email}) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _authRepository.resetPassword(email: email);
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } on AuthException catch (e) {
      emit(AuthState(status: AuthStatus.error, errorMessage: e.message));
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.error,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }

  /// Update user profile
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoUrl);
        await user.reload();

        // Sync to Firestore
        await _chatService.saveUserProfile(
          uid: user.uid,
          name: displayName ?? state.displayName ?? 'User',
          email: user.email,
          photoUrl: photoUrl ?? state.photoUrl,
        );

        // Emit updated state
        emit(
          state.copyWith(
            displayName: displayName ?? state.displayName,
            photoUrl: photoUrl ?? state.photoUrl,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to update profile: $e',
        ),
      );
    }
  }

  /// Upload profile image to Firebase Storage and update profile
  Future<void> uploadProfileImage(String filePath) async {
    try {
      final user = _authRepository.currentUser;
      if (user == null) return;

      final file = File(filePath);
      if (!await file.exists()) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Selected image file not found.',
          ),
        );
        return;
      }

      // Detect content type from file extension
      final ext = filePath.split('.').last.toLowerCase();
      final contentType = ext == 'png' ? 'image/png' : 'image/jpeg';
      final fileName = '${user.uid}.$ext';

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      // Upload file and wait for completion
      final snapshot = await ref.putFile(
        file,
        SettableMetadata(contentType: contentType),
      );

      // Verify upload succeeded
      if (snapshot.state != TaskState.success) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Image upload did not complete successfully.',
          ),
        );
        return;
      }

      // Get download URL from the completed upload snapshot
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firebase Auth profile
      await user.updatePhotoURL(downloadUrl);
      await user.reload();

      // Also save locally for fast access
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_photo_${user.uid}', downloadUrl);

      emit(state.copyWith(photoUrl: downloadUrl));
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Storage error: ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to upload image: $e',
        ),
      );
    }
  }

  /// Update user bio and store in SharedPreferences
  Future<void> updateBio(String bio) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = state.userId;
      if (userId != null) {
        await prefs.setString('user_bio_$userId', bio);
        emit(state.copyWith(bio: bio));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to update bio: $e',
        ),
      );
    }
  }

  /// Load user bio from SharedPreferences
  Future<void> loadBio() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = state.userId;
      if (userId != null) {
        final bio = prefs.getString('user_bio_$userId') ?? '';
        emit(state.copyWith(bio: bio));
      }
    } catch (e) {
      print('Error loading bio: $e');
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
