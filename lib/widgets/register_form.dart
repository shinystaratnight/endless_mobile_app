import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/models/industry_model.dart';
import 'package:piiprent/models/settings_model.dart';
import 'package:piiprent/models/skill_model.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/industry_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_select.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RegisterForm extends StatefulWidget {
  final IndustryService industryService = IndustryService();
  final Settings settings;

  RegisterForm({
    this.settings,
  });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String _title;
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _birthday;
  String _industry;
  List<dynamic> _skills;
  CountryCode _phoneCountryCode;

  StreamController _industryStream = StreamController();
  StreamController _fetchingStream = StreamController();
  StreamController _errorStream = StreamController();

  List<Map<String, dynamic>> titleOptions = [
    {'value': 'Mr.', 'label': 'Mr.'},
    {'value': 'Ms.', 'label': 'Ms.'},
    {'value': 'Mrs.', 'label': 'Mrs.'},
    {'value': 'Dr.', 'label': 'Dr.'},
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  _register(ContactService contactService) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _fetchingStream.add(true);
    _errorStream.add(null);

    try {
      await contactService.register(
        birthday: _birthday,
        email: _email,
        firstName: _firstName,
        lastName: _lastName,
        industry: _industry,
        phone: _phone,
        skills: _skills,
        title: _title,
      );
    } catch (e) {
      _errorStream.add(e.toString());
    } finally {
      _fetchingStream.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    IndustryService industryService = Provider.of<IndustryService>(context);
    ContactService contactService = Provider.of<ContactService>(context);

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
                    title: translate('field.title'),
                    columns: 4,
                    options: titleOptions,
                    multiple: false,
                    onChanged: (String title) {
                      _title = title;
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Field(
                    label: translate('field.first_name'),
                    onSaved: (String value) {
                      _firstName = value;
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Field(
                    label: translate('field.last_name'),
                    onSaved: (String value) {
                      _lastName = value;
                    },
                  ),
                )
              ],
            ),
            Field(
              label: translate('field.email'),
              validator: emailValidator,
              onSaved: (String value) {
                _email = value;
              },
            ),
            Field(
              label: translate('field.phone'),
              initialValue: '',
              onSaved: (String value) {
                _phone = '$_phoneCountryCode$value';
              },
              leading: widget.settings != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CountryCodePicker(
                        onInit: (prefix) => _phoneCountryCode = prefix,
                        onChanged: (prefix) =>
                            setState(() => _phoneCountryCode = prefix),
                        initialSelection: widget.settings.countryCode,
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                    )
                  : SizedBox(),
            ),
            Field(
              label: translate('field.birthday'),
              datepicker: true,
              onSaved: (String value) {
                _birthday = value;
              },
            ),
            FutureBuilder(
              future: industryService.getIndustries(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Industry> data = snapshot.data;

                  return FormSelect(
                    multiple: false,
                    title: translate('field.industries'),
                    columns: 1,
                    onChanged: (String id) {
                      _industry = id;
                      _industryStream.add(id);
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
            StreamBuilder(
              stream: _industryStream.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                String industry = snapshot.data;

                return FutureBuilder(
                  future: industryService.getSkills(
                    industry,
                    widget.settings.company,
                  ),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData) {
                      List<Skill> data = snapshot.data;
                      return FormSelect(
                        multiple: true,
                        title: translate('field.skills'),
                        columns: 1,
                        onChanged: (List<dynamic> ids) {
                          _skills = ids;
                        },
                        options: data.map((Skill el) {
                          return {'value': el.id, 'label': el.name};
                        }).toList(),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
            StreamBuilder(
              stream: _errorStream.stream,
              builder: (context, snapshot) {
                return FormMessage(
                  type: MessageType.Error,
                  message: snapshot.data,
                );
              },
            ),
            StreamBuilder(
              stream: _fetchingStream.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormSubmitButton(
                    disabled: snapshot.hasData && snapshot.data,
                    onPressed: () => _register(contactService),
                    label: translate('button.register'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
