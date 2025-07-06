// lib/auth_provider.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'models.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  UserModel? _user;
  UserModel? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
    } else {
      _user = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? 'Tidak ada email',
        name: firebaseUser.displayName ?? 'Pengguna Baru',
        avatar: firebaseUser.photoURL,
        provider: firebaseUser.providerData.first.providerId,
      );
      notifyListeners();

      try {
        final userProfile = await _fetchUserProfile(firebaseUser.uid);
        if (userProfile == null &&
            (_user?.provider == 'google.com' || _user?.provider == 'google')) {
          await _createGoogleUserInFirestore(firebaseUser);
          _user = await _fetchUserProfile(firebaseUser.uid);
        } else if (userProfile != null) {
          _user = userProfile;
        }
      } catch (e) {
        debugPrint("Tidak dapat mengambil profil dari Firestore: $e");
      }
    }
    notifyListeners();
  }

  Future<UserModel?> _fetchUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateProfile(
      String newName, String newEmail, Uint8List? imageBytes) async {
    if (_user == null) throw Exception("User tidak ditemukan");

    try {
      String? newAvatarUrl = _user!.avatar;

      if (imageBytes != null) {
        final ref = _storage.ref().child('avatars').child(_user!.id);
        await ref.putData(imageBytes);
        newAvatarUrl = await ref.getDownloadURL();
      }

      Map<String, dynamic> dataToUpdate = {
        'name': newName,
        'email': newEmail,
        'avatar': newAvatarUrl,
        'provider': _user!.provider,
        'id': _user!.id,
      };

      await _firestore
          .collection('users')
          .doc(_user!.id)
          .set(dataToUpdate, SetOptions(merge: true));

      if (_auth.currentUser?.email != newEmail) {
        await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
      }

      _user = UserModel.fromMap(dataToUpdate);
      notifyListeners();
    } catch (e) {
      debugPrint("Error update profil: $e");
      throw Exception('Gagal memperbarui profil.');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Email atau password tidak valid');
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        UserModel newUser = UserModel(
          id: firebaseUser.uid,
          email: email,
          name: name,
          provider: 'password',
        );
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Gagal melakukan pendaftaran');
    }
  }

  Future<void> logout() async {
    final userProvider = _auth.currentUser?.providerData.first.providerId;
    if (userProvider == 'google.com') {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Error Google Sign-In: $e");
      throw Exception('Gagal login dengan Google. Pastikan konfigurasi benar.');
    }
  }

  Future<void> _createGoogleUserInFirestore(User firebaseUser) async {
    UserModel newUser = UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? "no-email@google.com",
      name: firebaseUser.displayName ?? "Google User",
      avatar: firebaseUser.photoURL,
      provider: 'google.com',
    );
    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(newUser.toMap());
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    if (_user == null || _auth.currentUser == null) {
      throw Exception("User tidak ditemukan");
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: oldPassword,
      );
      await _auth.currentUser!.reauthenticateWithCredential(cred);
      await _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Gagal mengganti password.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Tidak ada pengguna yang terdaftar dengan email ini.');
      } else {
        throw Exception('Gagal mengirim email reset password. Coba lagi.');
      }
    }
  }
}
