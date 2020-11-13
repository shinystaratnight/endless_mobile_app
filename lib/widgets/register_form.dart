import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:piiprent/models/industry_model.dart';
import 'package:piiprent/models/skill_model.dart';
import 'package:piiprent/screens/candidate_home_screen.dart';
import 'package:piiprent/services/industry_service.dart';
// import 'package:piiprent/services/login_service.dart';
// import 'package:piiprent/widgets/dynamic_dropdown.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_select.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  // final LoginService loginService = LoginService();
  final IndustryService industryService = IndustryService();

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  DateTime _birthday;
  String _industry;

  List<Map<String, dynamic>> titleOptions = [
    {'value': 'Mr.', 'label': 'Mr.'},
    {'value': 'Ms.', 'label': 'Ms.'},
    {'value': 'Mrs.', 'label': 'Mrs.'},
    {'value': 'Dr.', 'label': 'Dr.'},
  ];

  bool _isTrue(dynamic v) {
    return v != null ? true : false;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    // _birthday = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IndustryService industryService = Provider.of<IndustryService>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 14.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FormSelect(
                    title: 'Title',
                    columns: 4,
                    options: titleOptions,
                    multiple: false,
                  ),
                )
              ],
            ),
            Row(
              children: [
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
              datepicker: true,
            ),
            FutureBuilder(
              future: industryService.getIndustries(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Industry> data = snapshot.data;

                  return FormSelect(
                    multiple: false,
                    title: 'Industries',
                    columns: 1,
                    onChanged: (String id) {
                      setState(() {
                        _industry = id;
                      });
                    },
                    options: data.map((Industry el) {
                      return {'value': el.id, 'label': el.name};
                    }).toList(),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            _industry != null
                ? FutureBuilder(
                    future: industryService.getSkills(_industry),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print('here');

                      if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasData) {
                        List<Skill> data = snapshot.data;
                        print(data);

                        return FormSelect(
                          multiple: true,
                          title: 'Skills',
                          columns: 2,
                          options: data.map((Skill el) {
                            return {'value': el.id, 'label': el.name};
                          }).toList(),
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                : SizedBox(),
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
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
