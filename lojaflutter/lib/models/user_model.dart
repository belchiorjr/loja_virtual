import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Model {
  // Usuario atual
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    try {
      _auth
          .createUserWithEmailAndPassword(
              email: userData['email'], password: pass)
          .then((user) async {
        firebaseUser = user.user;
        await _saveUserData(userData);
        onSuccess();
        isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    if (firebaseUser.uid != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .set(this.userData);
    }
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    try {
      _auth
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((user) async {
        firebaseUser = user.user;
        await _loadCurrentUser();

        onSuccess();
        isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser;

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get();
        userData = docUser.data();
      }
    }

    this.userData = userData;

    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .set(this.userData);
    }
  }
}
