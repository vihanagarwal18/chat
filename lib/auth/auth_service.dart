import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{

  //instance of auth
  final FirebaseAuth _auth=FirebaseAuth.instance;
  //sign in
  Future<UserCredential> signInWithEmailPassword(String email,password) async{
    try{
      print(2);
      UserCredential usercredential=await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return usercredential;
    } on FirebaseAuthException catch (e){
      print(6);
      throw Exception(e.code);
    }
  }

  //sign up

  Future<UserCredential> signUpWithEmailPassword(String email,password)async{
    try{
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    print(1);
    return await _auth.signOut();
  }

  //errors
}