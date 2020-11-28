import 'package:flutter/material.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/screens/client_home_screen.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
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
  String _formError;
  bool _fetching = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onLogin(LoginService loginService, ContactService contactService) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _fetching = true;
      _formError = null;
    });

    try {
      RoleType type = await loginService.login(_username, _password);

      if (type == RoleType.Candidate) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CandidateHomeScreen(),
          ),
        );
      } else if (type == RoleType.Client) {
        List<Role> roles = await contactService.getRoles();
        roles[0].active = true;
        loginService.user.roles = roles;

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
    ContactService contactService = Provider.of<ContactService>(context);

    loginService.getUser().then((RoleType role) {
      if (role == RoleType.Candidate) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CandidateHomeScreen(),
          ),
        );
      } else if (role == RoleType.Client) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientHomeScreen(),
          ),
        );
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Field(
              label: 'Email Address',
              type: TextInputType.emailAddress,
              validator: emailValidator,
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
            FormMessage(type: MessageType.Error, message: _formError),
            SizedBox(
              height: 16,
            ),
            FormSubmitButton(
              disabled: _fetching,
              onPressed: () => _onLogin(loginService, contactService),
              label: 'Login',
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
