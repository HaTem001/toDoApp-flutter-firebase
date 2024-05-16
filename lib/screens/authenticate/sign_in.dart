import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[900], // Dark background color from Home
      appBar: AppBar(
        backgroundColor: Colors.grey[850], // Dark AppBar color from Home
        elevation: 0.0,
        title: const Text('Sign in', style: TextStyle(color: Colors.white)), // White text color from Home
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white), // White icon color from Home
            label: Text('Register', style: TextStyle(color: Colors.white)), // White text color from Home
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: 'password'),
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Color that stands out in dark mode from Home
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white), // White text color from Home
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                          loading = false;
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }
                  }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}