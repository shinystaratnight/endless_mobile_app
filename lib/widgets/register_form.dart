import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/widgets/form_field.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  DateTime _birthday;

  bool _isTrue(dynamic v) {
    return v != null ? true : false;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: Field(label: 'Title')),
                Expanded(flex: 2, child: Field(label: 'First name')),
                Expanded(flex: 2, child: Field(label: 'Last name'))
              ],
            ),
            Field(
              label: 'Email',
            ),
            Field(
              label: 'Mobile number',
            ),
            Field(
              label: 'Birthday',
              initialValue: _isTrue(_birthday)
                  ? DateFormat('dd/MM/yyyy').format(_birthday)
                  : '',
              onFocus: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now())
                    .then((date) {
                  setState(() {
                    _birthday = date;
                  });
                });
              },
            ),
            Field(
              label: 'Industries',
            ),
            Field(
              label: 'Skills',
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
                    builder: (context) => CandidateHomeScreen(),
                  ),
                );
              },
              child: Text(
                'Register',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
