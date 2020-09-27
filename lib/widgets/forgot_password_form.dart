import 'package:flutter/material.dart';
import 'package:piiprent/screens/login_screen.dart';
import 'package:piiprent/widgets/form_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String _email;

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
                label: 'Email',
              ),
              RaisedButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                color: Colors.blueAccent,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Text(
                  'Back to login',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ));
  }
}
