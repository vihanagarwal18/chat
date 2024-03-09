import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{

  //instance of auth
  final FirebaseAuth _auth=FirebaseAuth.instance;
  //sign in
  Future<UserCredential> signInWithEmailPassword(String email,password) async{
    try{
      UserCredential usercredential=await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return usercredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  //sign up

  //sign out

  //errors
}