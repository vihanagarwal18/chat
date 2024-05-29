import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      print(2);
      //sign user in
      UserCredential usercredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
      //save user info if it doesnt already exist
      _firestore.collection("Users").doc(usercredential.user!.uid).set(
        {
          'uid':usercredential.user!.uid,
          'email':email,
        },
      );

      return usercredential;
    } on FirebaseAuthException catch (e) {
      print(6);
      throw Exception(e.code);
    }
  }

  //sign up

  Future<User> signUpWithEmailPassword(String email, password) async {
    try {
      //create user
      UserCredential usercredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info in seprate doc
      _firestore.collection("Users").doc(usercredential.user!.uid).set(
        {
          'uid':usercredential.user!.uid,
          'email':email,
        },
      );
      final user = FirebaseAuth.instance.currentUser;
      return user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //errors
}
