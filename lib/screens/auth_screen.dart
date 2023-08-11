import 'dart:io';

import 'package:chat_app/widgets/auth/auth_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext context,
  ) async {
    // this is user credential vaiable
    UserCredential userCredential;

    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('image')
            .child('${userCredential.user!.uid}.jpg');

        await ref.putFile(image);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'email': email,
            'password': password,
            'username': username,
            'image_url': url
          },
        );
      }
    } on FirebaseAuthException catch (error) {
      Scaffold.of(context).showBottomSheet(
        (context) {
          if (error.code == 'weak-password') {
            return customeSnackBar(context, 'weak password');
          } else if (error.code == 'email-already-in-use') {
            return customeSnackBar(context, 'email already exist');
          } else if (error.code == 'user-not-found') {
            return customeSnackBar(context, 'not found user');
          } else if (error.code == 'wrong-password') {
            return customeSnackBar(context, 'wrong password');
          } else if (error.code == 'invalid-email') {
            return customeSnackBar(context, 'invalid Email');
          } else {
            return customeSnackBar(context, 'Error Try again later');
          }
        },
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(0, 255, 255, 255),
          // statusBarBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: Colors.pink,
      body: AuthForm(
        _submitAuthForm,
        isLoading,
      ),
    );
  }

  SnackBarAction customeSnackBar(context, String message) {
    return SnackBarAction(
      label: message,
      onPressed: () => Navigator.of(context).pop(),
      backgroundColor: Colors.white,
      textColor: Colors.pink,
    );
  }
}
