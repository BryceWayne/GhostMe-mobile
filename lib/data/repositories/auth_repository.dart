import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Returns the current user or null if ghost mode
  User? get currentUser => _firebaseAuth.currentUser;

  /// Summons the Identity (Google Sign In)
  /// Returns the ID Token string needed for the WebSocket connection
  Future<String?> signInWithGoogle() async {
    try {
      // 1. Trigger the native Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the séance

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with that credential
      final UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(credential);

      // 5. Get the specific ID Token to send to our Go Backend
      final String? idToken = await userCredential.user?.getIdToken();
      
      return idToken;
    } catch (e) {
      // In a real app, we would log this to Crashlytics
      print("Summoning Failed: $e");
      rethrow;
    }
  }

  /// Banishes the Identity (Sign Out)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}