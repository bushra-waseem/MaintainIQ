import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn(

  );
  final _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      await result.user!.updateDisplayName(name);
      
      await _db.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'emailVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password': return 'Password must be atleast 6 characters';
        case 'email-already-in-use': return 'Email already registered';
        case 'invalid-email': return 'Invalid email forma';
        default: return e.message ?? 'Something went wrong';
      }
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
      
      await _db.collection('users').doc(result.user!.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
        'emailVerified': true,
      });
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found': return 'User not found';
        case 'wrong-password': return 'Wrong Password';
        case 'invalid-credential': return 'Invalid credential';
        case 'too-many-requests': return 'Too many requests';
        default: return e.message ?? 'Login failed';
      }
    }
  }

 Future<String?> signInWithGoogle() async {
  try {
    await _google.signOut(); // Pehle sign out karo
    final googleUser = await _google.signIn();
    if (googleUser == null) return 'Login cancel kiya';
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    await _db.collection('users').doc(result.user!.uid).set({
      'name': result.user!.displayName,
      'email': result.user!.email,
      'photo': result.user!.photoURL,
      'emailVerified': true,
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return null;
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}
  Future<String?> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _google.signOut();
    await _auth.signOut();
  }
}