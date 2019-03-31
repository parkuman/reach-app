import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';
import '../models/auth.dart';

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
    'name': null,
    'email': null,
    'password': null,
    'accept': false,
  };

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
      image: AssetImage('assets/event.jpg'),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'name', filled: true, fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Name';
        }
      },
      onSaved: (String value) {
        _formData['name'] = value;
      },
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
      title: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info, color: Colors.black54),
            onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('HERE ARE THE TERMS'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    );
                  },
                ),
          ),
          Text(
            'I Agree to the Terms & Conditions',
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
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

  void _submitForm(Function authenticate) async {
    Map<String, dynamic> response;

    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_authMode == AuthMode.Signup && !_formData['accept']) {
      return;
    }

    _formKey.currentState.save();

    response = await authenticate(
      _formData['name'],
      _formData['email'].toLowerCase(),
      _formData['password'],
      _authMode,
    );

    if (response['success']) {
      // no longer need since we are updating this using RXdart's listener thingsy
      // Navigator.pushReplacementNamed(context, '/default');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(response['message']),
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
                  //ONLY RENDER NAME TEXTFIELD IF WE ARE IN SIGN UP MODE
                  (_authMode == AuthMode.Signup)
                      ? _buildNameTextField()
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
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
                  (_authMode == AuthMode.Signup)
                      ? _buildSwitchTile()
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildSignInUpBlock(),
                  SizedBox(
                    height: 10.0,
                  ),
                  ScopedModelDescendant(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return model.isLoading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              child: Text((_authMode == AuthMode.Login
                                  ? 'Login'
                                  : 'Sign Up')),
                              color: Theme.of(context).accentColor,
                              onPressed: () => _submitForm(model.authenticate),
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
