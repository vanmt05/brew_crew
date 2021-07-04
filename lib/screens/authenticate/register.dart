import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: signUpAppBar(),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Container(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        emailField(),
                        SizedBox(
                          height: 20.0,
                        ),
                        passwordField(),
                        SizedBox(
                          height: 20.0,
                        ),
                        registerButton(),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(error,
                            style:
                                TextStyle(color: Colors.red, fontSize: 15.0)),
                      ],
                    )),
              ),
            ),
          );
  }

  // Form fields
  AppBar signUpAppBar() {
    return AppBar(
      backgroundColor: Colors.brown[400],
      title: Text('Sign up to Brew Crew'),
      actions: [
        TextButton.icon(
            onPressed: () => widget.toggleView!(),
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: Text(
              'Sign In',
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }

  TextFormField emailField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Email'),
      validator: (val) => val!.isEmpty ? 'Enter an email.' : null,
      onChanged: (val) {
        setState(() => email = val);
      },
    );
  }

  TextFormField passwordField() {
    return TextFormField(
        obscureText: true,
        decoration: textInputDecoration.copyWith(hintText: 'Password'),
        validator: (val) =>
            val!.length < 6 ? 'Enter a password with 6+ char long' : null,
        onChanged: (val) {
          setState(() => password = val);
        });
  }

  ElevatedButton registerButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() => loading = true);

          dynamic result =
              await _auth.registerWithEmailAndPassword(email, password);
          if (result == null) {
            setState(() {
              error = 'Please enter a valid email or password.';
              loading = false;
            });
          }
        }
      },
      child: Text(
        'Register',
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.pink[400])),
    );
  }
}
