import 'package:chat_app/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Function to sign up and return user

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Account Successfully Created");
      await user.updateDisplayName(name);
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": name,
        "email": email,
        "status": "Unavailable",
      });
      return user;
    } else {
      print("Account Creation Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

//Function to sign in and return user

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      await user.updateDisplayName(snapshot.data()!['name']);
      print("Login Successful");
      return user;
    } else {
      print("Login Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

//Function to logout

Future lgoOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    await _auth.signOut().then((value) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen())));
  } catch (e) {
    print("Error");
  }
}
