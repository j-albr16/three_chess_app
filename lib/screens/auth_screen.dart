import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../helpers/constants.dart';
import '../widgets/basic/text_field.dart';
import '../widgets/basic/sorrounding_cart.dart';

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

  String get labelText {
    switch (authMode) {
      case AuthMode.logIn:
        return 'Login';
        break;
      case AuthMode.reset:
        return 'Reset Password';
        break;
      case AuthMode.signUp:
        return 'Sign Up';
        break;
    }
   return 'None';
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
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _label(labelText, labelSize, theme),
                Divider(thickness: 2),
                form(theme),
                submitBar(theme, Size(size.width * 0.9, size.height * 0.1))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form(ThemeData theme) {
    return SurroundingCard(
      // padding: EdgeInsets.all(morePadding),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            if (authMode == AuthMode.signUp)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // initialValue: 'scrutycs',
                  cursorColor: theme.primaryColorDark,
                  decoration: ChessTextField.inputDecoration(
                    labelText: 'username',
                    prefixIcon: Icon(Icons.person),
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
              ),
            SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // initialValue: 'jan.albrecht2000@gmail.com',
                focusNode: _emailNode,
                cursorColor: theme.primaryColorDark,
                decoration: ChessTextField.inputDecoration(
                  labelText: 'email',
                  theme: theme,
                  prefixIcon: Icon(Icons.email),
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
            ),
            SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // initialValue: 'dont4getme',
                focusNode: _passwordNode,
                cursorColor: theme.primaryColorDark,
                decoration: ChessTextField.inputDecoration(
                  labelText: 'password',
                  prefixIcon: Icon(Icons.security),
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
                      ? FocusScope.of(context)
                          .requestFocus(_confirmPasswordNode)
                      : _saveForm(context);
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
            ),
            SizedBox(height: 13),
            if (authMode == AuthMode.signUp || authMode == AuthMode.reset)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // initialValue: 'dont4getme',
                  focusNode: _confirmPasswordNode,
                  textInputAction: TextInputAction.done,
                  cursorColor: theme.primaryColorDark,
                  decoration: ChessTextField.inputDecoration(
                    labelText: 'confirm password',
                    prefixIcon: Icon(Icons.security),
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
              ),
          ],
        ),
      ),
    );
  }

  Widget authModeSwitchBar(ThemeData theme, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        authButton(
            callback: () => _switchAuthMode(AuthMode.logIn),
            size: Size(size.width * 0.4, size.height * 0.9),
            color: authMode == AuthMode.logIn
                ? theme.colorScheme.secondaryVariant
                : theme.colorScheme.secondary,
            theme: theme,
            text: 'Log In'),
        authButton(
            callback: () => _switchAuthMode(AuthMode.signUp),
            size: Size(size.width * 0.4, size.height * 0.9),
            color: authMode == AuthMode.signUp
                ? theme.colorScheme.secondaryVariant
                : theme.colorScheme.secondary,
            theme: theme,
            text: 'Sign Up'),
      ],
    );
  }

  static Widget authButton(
      {Color color,
      String text,
      Function callback,
      Size size,
      ThemeData theme}) {
    return FlatButton(
      height: size.height,
      minWidth: size.width,
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius)),
      child: Text(
        text,
        style: theme.primaryTextTheme.bodyText1,
      ),
      onPressed: callback,
    );
  }

  Widget submitBar(ThemeData theme, Size size) {
    return SurroundingCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          authModeSwitchBar(theme, Size(size.width , size.height * 0.5)),
          authButton(
            callback: () => _saveForm(context),
            color: theme.colorScheme.secondaryVariant,
            size:  Size(size.width * 0.9, size.height * 0.5),
            text: 'Submit',
            theme: theme,
          ),
        ],
      ),
    );
  }

  _switchAuthMode(AuthMode mode) {
    setState(() {
      authMode = mode;
    });
    FocusScope.of(context).unfocus();
  }
}

Widget _label(String text, Size size, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: theme.textTheme.headline1,
      textAlign: TextAlign.center,
    ),
  );
}
