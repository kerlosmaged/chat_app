import 'dart:io';

import 'package:chat_app/widgets/images/user_image_pickers.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      File image, bool isLogin, BuildContext context) submitFunction;

  final bool isLoading;

  const AuthForm(
    this.submitFunction,
    this.isLoading, {
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';
  File? _userImageFile;

  void _pickedImage(File? pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submit(BuildContext ctx) {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (_userImageFile == null&&_isLogin==false ) {
      Scaffold.of(context).showBottomSheet(
        (context) {
          return SnackBarAction(
            label: 'please enter your photo',
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.white,
            textColor: Colors.pink,
          );
        },
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFunction(
        _email.trim(),
        _username,
        _password.trim(),
        _userImageFile!,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading == true
        ? const Center(child: CircularProgressIndicator.adaptive())
        : Center(
            child: Card(
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!_isLogin)
                        UserImagePicker(imagePickfun: _pickedImage),
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _email = value!;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(labelText: 'Email Address'),
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Please enter at least 4 characters';
                            }
                            return null;
                          },
                          onSaved: (value) => _username = value!,
                          decoration:
                              const InputDecoration(labelText: 'username'),
                        ),
                      TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'password must be at least 7 charctest';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _password = newValue!,
                        keyboardType: TextInputType.visiblePassword,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submit(context);
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.pink)),
                        child: Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: const Text(
                          'I already have an account',
                          style: TextStyle(color: Colors.pink),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
