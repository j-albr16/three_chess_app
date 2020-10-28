import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

enum AuthMode { signIn, logIn, reset }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  FocusNode _passwordNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _confirmPasswordNode = FocusNode();

  final authMode = AuthMode.logIn;

  String _password = '';
  String _email = '';
  String _confirmPassword = '';
  String _userName = '';

  Future<void> _saveForm(BuildContext context) async {
    bool isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    if (authMode == AuthMode.signIn) {
     await Provider.of<AuthProvider>(context, listen: false)
          .signUp(email: _email, password: _password);
        _switchAuthMode(AuthMode.logIn);
    }
    if (authMode == AuthMode.logIn) {
      Provider.of<AuthProvider>(context, listen: false)
          .logIn(email: _email, password: _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Test Screen'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            if (authMode == AuthMode.signIn)
              TextFormField(
                // initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Username'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please provide a valid number';
                  }
                  if (double.tryParse(value) <= 0) {
                    return 'Please provide a number greater then 0';
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
            TextFormField(
              // initialValue: _initValues['price'],
              focusNode: _emailNode,
              decoration: InputDecoration(labelText: 'Email'),
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
            TextFormField(
              // initialValue: _initValues['price'],
              focusNode: _passwordNode,
              decoration: InputDecoration(labelText: 'Password'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a price';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                authMode == AuthMode.signIn
                    ? FocusScope.of(context).requestFocus(_confirmPasswordNode)
                    : _saveForm(context);
              },
              onSaved: (value) {
                _password = value;
              },
            ),
            if (authMode == AuthMode.signIn || authMode == AuthMode.reset)
              TextFormField(
                // initialValue: _initValues['price'],
                focusNode: _confirmPasswordNode,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
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
            FlatButton(
              child: Text('Submitt'),
              onPressed: () => _saveForm(context),
            ),
            if (authMode != AuthMode.reset)
              FlatButton(
                child: Text(authMode == AuthMode.logIn ? 'Sign Up' : 'Log In'),
                onPressed: _switchAuthMode(authMode == AuthMode.logIn
                    ? AuthMode.signIn
                    : AuthMode.logIn),
              ),
          ],
        ),
      ),
    );
  }

  _switchAuthMode(AuthMode authMode) {
    setState(() {
      authMode = authMode;
    });
  }
}
