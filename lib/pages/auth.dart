import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';

// defines the mode of the login screen
enum AuthMode {
  Signup,
  Login,
}

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  AuthMode _authMode = AuthMode.Login;
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'accept': false,
  };

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
      image: AssetImage('assets/event.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'e-mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Invalid E-mail';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Password';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'confirm password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match';
        }
      },
    );
  }


  Widget _buildSwitchTile() {
    return SwitchListTile(
      value: _formData['accept'],
      onChanged: (bool value) {
        setState(() {
          _formData['accept'] = value;
        });
      },
      title: Text('I Agree'),
    );
  }

  Widget _buildSignInUpBlock() {
    return Column(
      children: <Widget>[
        Text(
            '${(_authMode == AuthMode.Login) ? 'Need an account?' : 'Already have an account?'}'),
        FlatButton(
          child: Text(
            '${(_authMode == AuthMode.Login) ? 'Sign Up' : 'Sign In'}',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            setState(() {
              _authMode = (_authMode == AuthMode.Login)
                  ? AuthMode.Signup
                  : AuthMode.Login;
            });
          },
        ),
      ],
    );
  }



  void _submitForm(Function login, Function signup) async {
    if (!_formKey.currentState.validate() || !_formData['accept']) {
      return;
    }
    _formKey.currentState.save();

    if (_authMode == AuthMode.Login) {
      login(_formData['email'], _formData['password']);
    } else {
      final Map<String, dynamic> reponse =
          await signup(_formData['email'], _formData['password']);
      if (reponse['success']) {
        Navigator.pushReplacementNamed(context, '/default');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(reponse['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildEmailTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  //ONLY RENDER CONFIRM PASSWORD IF WE ARE IN SIGNUP MODE
                  (_authMode == AuthMode.Signup)
                      ? _buildPasswordConfirmTextField()
                      : Container(),
                  _buildSwitchTile(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildSignInUpBlock(),
                  SizedBox(
                    height: 10.0,
                  ),
                  // FIX THIS SHIT BIG BOI
                  ScopedModelDescendant(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return RaisedButton(
                        child: Text('login'),
                        color: Theme.of(context).accentColor,
                        onPressed: () => _submitForm(model.login, model.signup),
                      );
                    },
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
