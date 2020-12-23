import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../helpers/constants.dart';
import '../widgets/text_field.dart';

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
    } finally {
      _switchAuthMode(AuthMode.logIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    Size labelSize = Size(size.width * 0.7, size.height * 0.15);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
        appBar: AppBar(
          title: Text('Authentification'),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(),
            child: SingleChildScrollView(
                        child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (authMode == AuthMode.logIn)
                    _label('LogIn', labelSize, theme),
                  if (authMode == AuthMode.signUp)
                    _label('Sign Up', labelSize, theme),
                  if (authMode == AuthMode.reset)
                    _label('Remake', labelSize, theme),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(cornerRadius)),
                    height: size.height * 0.4,
                    width: size.width * 0.6,
                    child: form(theme),
                  ),
                  submitBar(theme, Size(size.width * 0.9, size.height * 0.1))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form form(ThemeData theme) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          if (authMode == AuthMode.signUp)
            TextFormField(
              // initialValue: 'scrutycs',
              cursorColor: theme.primaryColorDark,
              decoration: ChessTextField.inputDecoration(
                labelText: 'username',
                theme: theme,
              ),
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
            // initialValue: 'jan.albrecht2000@gmail.com',
            focusNode: _emailNode,
            cursorColor: theme.primaryColorDark,
            decoration: ChessTextField.inputDecoration(
              labelText: 'email',
              theme: theme,
            ),
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
            // initialValue: 'dont4getme',
            focusNode: _passwordNode,
            cursorColor: theme.primaryColorDark,
            decoration: ChessTextField.inputDecoration(
              labelText: 'password',
              theme: theme,
            ),
            style: theme.textTheme.bodyText1,
            obscureText: true,
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
                  ? FocusScope.of(context).requestFocus(_confirmPasswordNode)
                  : _saveForm(context);
            },
            onSaved: (value) {
              _password = value;
            },
          ),
          SizedBox(height: 13),
          if (authMode == AuthMode.signUp || authMode == AuthMode.reset)
            TextFormField(
              // initialValue: 'dont4getme',
              focusNode: _confirmPasswordNode,
              textInputAction: TextInputAction.done,
              cursorColor: theme.primaryColorDark,
              decoration: ChessTextField.inputDecoration(
                labelText: 'confirm password',
                theme: theme,
              ),
              style: theme.textTheme.bodyText1,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
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
        ],
      ),
    );
  }

  Widget submitBar(ThemeData theme, Size size) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlatButton(
            height: size.height * 0.5,
            minWidth: size.width * 0.4,
              color: theme.colorScheme.secondaryVariant.withOpacity(0.8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cornerRadius)),
            child: Text(
              'Submitt',
              style: theme.primaryTextTheme.bodyText1,
            ),
            onPressed: () => _saveForm(context),
          ),
          if (authMode != AuthMode.reset)
            FlatButton(
              height: size.height * 0.5,
              minWidth: size.width * 0.4,
              color: theme.colorScheme.secondaryVariant.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cornerRadius)),
              child: Text(
                authMode == AuthMode.logIn ? 'Sign Up' : 'Log In',
                style: theme.primaryTextTheme.bodyText1,
              ),
              onPressed: () => _switchAuthMode(authMode == AuthMode.logIn
                  ? AuthMode.signUp
                  : AuthMode.logIn),
            ),
        ],
      ),
    );
  }

  _switchAuthMode(AuthMode mode) {
    setState(() {
      authMode = mode;
    });
  }
}

Widget _label(String text, Size size, ThemeData theme) {
  return Container(
    width: size.width,
    height: size.height,
    padding: EdgeInsets.symmetric(
      vertical: size.width * 0.05,
      horizontal: size.width * 0.2,
    ),
    margin: EdgeInsets.all(30),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: RadialGradient(
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.secondaryVariant.withOpacity(0.8),
          ],
          focalRadius: 600,
          center: Alignment.bottomLeft,
          stops: [0,  300]),
      color: theme.colorScheme.secondary,
      boxShadow: [
        BoxShadow(offset: Offset(5, 3), color: Colors.black26, blurRadius: 2)
      ],
    ),
    child: Text(
      text,
      style: theme.textTheme.headline1.copyWith(color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );
}
