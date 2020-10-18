import 'package:flutter/material.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/screens/client_home_screen.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final Function onRegister;

  LoginForm({this.onRegister});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _username;
  String _password;
  String _formError = '';
  bool _fetching = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onLogin(LoginService loginService) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _fetching = true;
    });

    try {
      Role type = await loginService.login(_username, _password);

      if (type == Role.Candidate) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CandidateHomeScreen(),
          ),
        );
      } else if (type == Role.Client) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientHomeScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _formError = e;
      });
    } finally {
      setState(() {
        _fetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Field(
              label: 'Username / Email Address',
              type: TextInputType.emailAddress,
              validator: (String value) {
                if (isEmail(value)) {
                  return null;
                }
                return 'Please enter a valid email!';
              },
              onSaved: (String value) {
                _username = value;
              },
            ),
            Field(
              label: 'Password',
              obscureText: true,
              onSaved: (String value) {
                _password = value;
              },
            ),
            Container(
              child: Text(
                _formError,
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.blue[200],
              disabledTextColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: _fetching
                  ? null
                  : () {
                      _onLogin(loginService);
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
                style: TextStyle(color: Colors.blue),
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
