import 'package:flutter/material.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/screens/client_home_screen.dart';
import 'package:piiprent/widgets/form_field.dart';

class LoginForm extends StatefulWidget {
  final Function onRegister;

  LoginForm({this.onRegister});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _userName;
  String _password;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Field(
              label: 'Username / Email Address',
            ),
            Field(
              label: 'Password',
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              color: Colors.blueAccent,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClientHomeScreen(),
                  ),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/forgot_password'),
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account,",
                    style: TextStyle(color: Colors.grey[700])),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: widget.onRegister,
                  child: Text(
                    'Register here!',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
