import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Step 1: Create user in Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Step 2: Update user profile with username FIRST
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(username);
        await userCredential.user!.reload();
      }

      // Step 3: Add user to Firestore
      if (userCredential.user != null) {
        try {
          var data = {
            'uid': userCredential.user!.uid,
            'username': username,
            'username_lowercase': username.toLowerCase(),
            'email': email,
            'created_at': DateTime.now(),
          };
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(data);
          print('✅ User data saved to Firestore successfully!');
        } catch (firestoreError) {
          // Throw Firestore error so we can see what's happening
          print('❌ Firestore write error: $firestoreError');
          throw Exception('Failed to save user data: $firestoreError');
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is invalid.');
      } else {
        throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is invalid.');
      } else {
        throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign in with Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await _facebookAuth.login();

      if (loginResult.status == LoginStatus.cancelled) {
        throw Exception('Facebook Sign In was cancelled');
      }

      if (loginResult.status == LoginStatus.failed) {
        throw Exception('Facebook Sign In failed: ${loginResult.message}');
      }

      // Get the access token
      final AccessToken? accessToken = loginResult.accessToken;

      if (accessToken == null) {
        throw Exception('Failed to get Facebook access token');
      }

      // Create credential for Firebase
      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      // Sign in to Firebase
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      // Save user data to Firestore if new user
      if (userCredential.user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid);

        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // New user - save their data
          try {
            var data = {
              'uid': userCredential.user!.uid,
              'username': userCredential.user!.displayName ?? 'Facebook User',
              'username_lowercase':
                  (userCredential.user!.displayName ?? 'Facebook User')
                      .toLowerCase(),
              'email': userCredential.user!.email ?? '',
              'created_at': DateTime.now(),
            };
            await userDoc.set(data);
            print('✅ Facebook user data saved to Firestore successfully!');
          } catch (firestoreError) {
            print('❌ Firestore write error: $firestoreError');
          }
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase Auth Error: ${e.message}');
    } catch (e) {
      throw Exception('Facebook Sign In failed: $e');
    }
  }

  // Sign up with Facebook (same as sign in for social auth)
  Future<UserCredential?> signUpWithFacebook() async {
    return signInWithFacebook();
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _facebookAuth.logOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
