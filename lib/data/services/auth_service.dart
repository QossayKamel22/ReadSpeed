import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../repositories/user_repository.dart';

/// Wraps FirebaseAuth for the rest of the app. Registered once, permanently,
/// in main() so auth state is available from the very first frame.
class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;
  final _userRepository = UserRepository();

  final Rxn<User> firebaseUser = Rxn<User>();
  final RxBool isReady = false.obs; // true once the first auth state arrives

  bool get isSignedIn => firebaseUser.value != null;
  String? get uid => firebaseUser.value?.uid;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    // Only marks readiness here — profile creation is handled explicitly by
    // signUp()/signIn() below. Auto-ensuring on every auth-state emission
    // would race the signUp() call (which sets the real display name) since
    // authStateChanges() can fire before updateDisplayName() resolves,
    // letting a fallback "email prefix" name win the race and stick.
    ever<User?>(firebaseUser, (_) => isReady.value = true);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      if (displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
      }
      await _userRepository.ensureProfile(user, displayName: displayName.trim());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final credential =
        await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    // Safety net for accounts that somehow lack a Firestore profile
    // (e.g. created directly in the Firebase console) — creates it only
    // if missing, so this never overwrites an existing profile's settings.
    final user = credential.user;
    if (user != null) {
      await _userRepository.ensureProfile(user);
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// Maps FirebaseAuthException codes to short, user-facing copy.
  static String friendlyError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'That email address looks invalid.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
          return 'No account found with that email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'An account already exists with that email.';
        case 'weak-password':
          return 'Please use a stronger password (6+ characters).';
        case 'network-request-failed':
          return 'Network error. Check your connection and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
