import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/helper/local_storage.dart';
import 'package:project/modal/account.dart';

//All authentication and firebase stuffs are going into this class
class Authentication {
  String uid;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('accounts');
  LocalStorage localStorage = LocalStorage();

  createUserInFirebase(String email, String password) async {
    UserCredential newUser;
    try {
      newUser = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      uid = auth.currentUser.uid;
      if (newUser != null) {
        if (localStorage.prefs == null) {
          await localStorage.init();
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return newUser;
  }

  saveDataInFirebase(Account account) async {
    await firestore.doc(uid).set(account.toJson());
  }

  saveDataInLocalStorage(Account account, String password) async {
    await localStorage.setAccount(account);
    await localStorage.prefs.setString('key', password);
  }

  loginUser(String email, String password) async {
    var user;
    try {
      user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        uid = auth.currentUser.uid;
        if (localStorage.prefs == null) {
          await localStorage.init();
        }
        await localStorage.prefs.setString('key', password);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return user;
  }

  logoutUser() async {
    await auth.signOut();
    if (localStorage.prefs == null) {
      await localStorage.init();
    }
    await localStorage.prefs.clear();
  }
}
