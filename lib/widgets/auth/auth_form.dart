import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String userName, String passWord,
      File pickedImage, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLogin = false;
  File _pickedImage;

  void _pickedUserImg(File image) {
    _pickedImage = image;
  }

  void _trySubmit() {
    var isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Text('You havn\'t Pick an Image.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).accentColor,
        ),
      );
      return;
    }

    if (isValid) {
      formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _pickedImage,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedUserImg),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'please enter a valid email.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: true,
                      key: ValueKey('username'),
                      decoration: InputDecoration(
                        labelText: 'username',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'username must be at least 4 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(
                      labelText: 'password',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.length < 7 || value.isEmpty) {
                        return 'password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 20),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Colors.deepPurple,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create new Account'
                            : 'I already have an account',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
