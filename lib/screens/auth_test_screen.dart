import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

enum AuthMode { signUp, logIn, reset }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();

}


class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  FocusNode _passwordNode;
  FocusNode _emailNode;
  FocusNode _confirmPasswordNode;

  AuthMode authMode = AuthMode.signUp;

  String _password = '';
  String _email = '';
  String _confirmPassword = '';
  String _userName = '';

  @override
  void initState() {
    _passwordNode = FocusNode();
    _emailNode = FocusNode();
    _confirmPasswordNode = FocusNode();
    super.initState();
  }

   @override
  void dispose() {
    _passwordNode.dispose();
    _emailNode.dispose();
    _confirmPasswordNode.dispose();
    super.dispose();
  }


  Future<void> _saveForm(BuildContext context) async {
    try {
      _password = _password.trim();
      _email = _email.trim();
      _email = _email.toLowerCase();
      _confirmPassword = _confirmPassword.trim();
      _userName = _userName.trim();
      bool isValid = _formKey.currentState.validate();
      print(_email + _userName + _password);
      if (!isValid) {
        return;
      }
      _formKey.currentState.save();
      print(authMode);
      if (authMode == AuthMode.signUp) {
        print(authMode);
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(email: _email, password: _password, userName: _userName);
      }
      if (authMode == AuthMode.logIn) {
        await Provider.of<AuthProvider>(context, listen: false)
            .logIn(email: _email, password: _password);
      }
    } catch (errorMessage) {
      print(errorMessage);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                padding: EdgeInsets.all(5),
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
            content: Text(errorMessage.toString()),
          );
        },
      );
    }finally{
      _switchAuthMode(AuthMode.logIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Test Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(
        ),
        child: Column(
          children: [
            if (authMode == AuthMode.logIn) _label('Sign Up', size, theme),
            if (authMode == AuthMode.signUp) _label('Sign Up', size, theme),
            if (authMode == AuthMode.reset) _label('Remake', size, theme),
            SizedBox(height: 40),
            Center(
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.primaryColorDark),
                    borderRadius: BorderRadius.circular(8)),
                height: size.height * 0.6,
                width: size.width * 0.4,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      if (authMode == AuthMode.signUp)
                        TextFormField(
                          initialValue: 'scrutycs',
                          decoration: decoration('Username', theme),
                          cursorColor: theme.primaryColorDark,
                          style: theme.primaryTextTheme.bodyText1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a price';
                            }

                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_emailNode);
                          },
                          onSaved: (value) {
                            _userName = value;
                          },
                        ),
                      SizedBox(height: 13),
                      TextFormField(
                        initialValue: 'jan.albrecht2000@gmail.com',
                        focusNode: _emailNode,
                        decoration: decoration('Email', theme),
                        cursorColor: theme.primaryColorDark,
                          style: theme.primaryTextTheme.bodyText1,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a price';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordNode);
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(height: 13),
                      TextFormField(
                        initialValue: 'dont4getme',
                        focusNode: _passwordNode,
                        decoration: decoration('Password', theme),
                        cursorColor: theme.primaryColorDark,
                          style: theme.primaryTextTheme.bodyText1,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a price';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          authMode == AuthMode.signUp
                              ? FocusScope.of(context)
                                  .requestFocus(_confirmPasswordNode)
                              : _saveForm(context);
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                      SizedBox(height: 13),
                      if (authMode == AuthMode.signUp ||
                          authMode == AuthMode.reset)
                        TextFormField(
                          initialValue: 'dont4getme',
                          focusNode: _confirmPasswordNode,
                          decoration: decoration('Confirm Password', theme),
                          textInputAction: TextInputAction.done,
                          cursorColor: theme.primaryColorDark,
                          style: theme.primaryTextTheme.bodyText1,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a price';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            _saveForm(context);
                          },
                          onSaved: (value) {
                            _confirmPassword = value;
                          },
                        ),
                      SizedBox(height: 13),
                      Container(
                        height: 40,
                        width: 60,
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: FlatButton(
                          child: Text(
                            'Submitt',
                            style: theme.primaryTextTheme.bodyText1,
                          ),
                          onPressed: () => _saveForm(context),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      if (authMode != AuthMode.reset)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 60, vertical: 3),
                          height: 40,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: FlatButton(
                            height: 40,
                            child: Text(
                              authMode == AuthMode.logIn ? 'Sign Up' : 'Log In',
                              style: theme.primaryTextTheme.bodyText1,
                            ),
                            onPressed: () => _switchAuthMode(
                                authMode == AuthMode.logIn
                                    ? AuthMode.signUp
                                    : AuthMode.logIn),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _switchAuthMode(AuthMode mode) {
    setState(() {
      authMode = mode;
    });
  }
}

InputDecoration decoration(String text, theme) {
  return InputDecoration(
    hoverColor: theme.primaryColor,
    focusColor: theme.focusColor,
    counterStyle: theme.primaryTextTheme.bodyText1,
    errorStyle: theme.primaryTextTheme.bodyText1,
    helperStyle:theme.primaryTextTheme.bodyText1,
    hintStyle: theme.primaryTextTheme.bodyText1,
    labelStyle: theme.primaryTextTheme.bodyText1,
    prefixStyle: theme.primaryTextTheme.bodyText1,
    suffixStyle: theme.primaryTextTheme.bodyText1,
    labelText: text,
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(style: BorderStyle.solid, color: theme.errorColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(style: BorderStyle.solid, color: theme.errorColor , width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(style: BorderStyle.solid, color: theme.primaryColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(style: BorderStyle.solid, color: theme.primaryColor, width: 0.7),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(style: BorderStyle.solid, color: theme.focusColor, width: 2),
    ),
  );
}

Widget _label(String text, Size size, ThemeData theme) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: size.width * 0.05,
      horizontal: size.width * 0.2,
    ),
    margin: EdgeInsets.all(30),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: theme.primaryColorDark,
    ),
    child: Text(
      text,
      style: theme.primaryTextTheme.headline1,
      textAlign: TextAlign.center,
    ),
  );
}
