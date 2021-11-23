import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/models/application_form_model.dart';
import 'package:piiprent/models/country_model.dart';
import 'package:piiprent/models/industry_model.dart';
import 'package:piiprent/models/settings_model.dart';
import 'package:piiprent/models/skill_model.dart';
import 'package:piiprent/models/tag_model.dart';
import 'package:piiprent/services/company_service.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/country_service.dart';
import 'package:piiprent/services/industry_service.dart';
import 'package:piiprent/services/tag_service.dart';
import 'package:piiprent/widgets/address_field.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_select.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:provider/provider.dart';

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
  String _gender;
  String _residency;
  String _nationality;
  String _transport;
  String _height;
  String _weight;
  String _bankAccountName;
  String _bankName;
  String _iban;
  List<dynamic> _tags;
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _birthday;
  String _industry;
  List<dynamic> _skills;
  CountryCode _phoneCountryCode;
  Map<String, dynamic> _address;

  final StreamController _industryStream = StreamController();
  final StreamController _fetchingStream = StreamController();
  final StreamController _errorStream = StreamController();

  List<Map<String, dynamic>> titleOptions = [
    {'value': 'Mr.', 'label': 'Mr.'},
    {'value': 'Ms.', 'label': 'Ms.'},
    {'value': 'Mrs.', 'label': 'Mrs.'},
    {'value': 'Dr.', 'label': 'Dr.'},
  ];

  List<Map<String, dynamic>> genderOptions = [
    {'value': 'male', 'label': 'Male'},
    {'value': 'female', 'label': 'Female'},
  ];

  List<Map<String, dynamic>> residencyOptions = [
    {'value': "0", 'label': "Unknown"},
    {'value': "1", 'label': "Citizen"},
    {'value': "2", 'label': "Permanent Resident"},
    {'value': "3", 'label': "Temporary Resident"}
  ];

  List<Map<String, dynamic>> transportationOptions = [
    {'value': "1", 'label': "Own Car"},
    {'value': "2", 'label': "Public Transportation"}
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
        gender: _gender,
        residency: _residency,
        nationality: _nationality,
        transport: _transport,
        height: _height,
        weight: _weight,
        bankAccountName: _bankAccountName,
        bankName: _bankName,
        iban: _iban,
        tags: _tags,
        address: _address,
      );
    } catch (e) {
      _errorStream.add(e.toString());
    } finally {
      _fetchingStream.add(false);
    }
  }

  Widget _buildTitleField(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FormSelect(
            title: translate('field.gender'),
            columns: 2,
            options: genderOptions,
            multiple: false,
            onChanged: (String gender) {
              _gender = gender;
            },
          ),
        )
      ],
    );
  }

  Widget _buildFirstNameField(BuildContext context, [Function validator]) {
    return Expanded(
      flex: 2,
      child: Field(
        label: translate('field.first_name'),
        validator: validator,
        onSaved: (String value) {
          _firstName = value;
        },
      ),
    );
  }

  Widget _buildLastNameField(BuildContext context, [Function validator]) {
    return Expanded(
      flex: 2,
      child: Field(
        label: translate('field.last_name'),
        validator: validator,
        onSaved: (String value) {
          _lastName = value;
        },
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, [Function validator]) {
    return Field(
      label: translate('field.email'),
      validator: validator,
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPhoneNumberField(BuildContext context, [Function validator]) {
    return Field(
      label: translate('field.phone'),
      initialValue: '',
      onSaved: (String value) {
        _phone = '$_phoneCountryCode$value';
      },
      validator: validator,
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
    );
  }

  Widget _buildBirthdayField(BuildContext context, [Function validator]) {
    return Field(
      label: translate('field.birthday'),
      datepicker: true,
      validator: validator,
      onSaved: (String value) {
        _birthday = value;
      },
    );
  }

  Widget _buildNationalityField(BuildContext context) {
    CountryService countryService = Provider.of<CountryService>(context);

    return FutureBuilder(
      future: countryService.getCountries(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Country> data = snapshot.data;

          return FormSelect(
            multiple: false,
            title: translate('field.nationality'),
            columns: 1,
            onChanged: (String id) {
              _nationality = id;
            },
            options: data.map((Country el) {
              return {'value': el.id, 'label': el.str};
            }).toList(),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildResidencyField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FormSelect(
            title: translate('field.residency'),
            columns: 1,
            options: residencyOptions,
            multiple: false,
            onChanged: (String residency) {
              _residency = residency;
            },
          ),
        )
      ],
    );
  }

  Widget _transportationToWorkField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FormSelect(
            title: translate('field.transport'),
            columns: 1,
            options: transportationOptions,
            multiple: false,
            onChanged: (String transport) {
              _transport = transport;
            },
          ),
        )
      ],
    );
  }

  Widget _buildHeightField(BuildContext context, [Function validator]) {
    return Expanded(
      flex: 2,
      child: Field(
        label: translate('field.height'),
        validator: validator,
        onSaved: (String height) {
          _height = height;
        },
      ),
    );
  }

  Widget _buildWeightField(BuildContext context, [Function validator]) {
    return Expanded(
      flex: 2,
      child: Field(
        label: translate('field.weight'),
        validator: validator,
        onSaved: (String weight) {
          _weight = weight;
        },
      ),
    );
  }

  Widget _buildBankAccountNameField(BuildContext context,
      [Function validator]) {
    return Field(
      label: translate('field.account_holders_name'),
      validator: validator,
      onSaved: (String value) {
        _bankAccountName = value;
      },
    );
  }

  Widget _buildBankNameField(BuildContext context, [Function validator]) {
    return Field(
      label: translate('field.bank_name'),
      validator: validator,
      onSaved: (String value) {
        _bankName = value;
      },
    );
  }

  Widget _buildIbanField(BuildContext context, [Function validator]) {
    return Field(
      label: translate('field.iban'),
      validator: validator,
      onSaved: (String value) {
        _iban = value;
      },
    );
  }

  Widget _buildIndustryField(BuildContext context) {
    IndustryService industryService = Provider.of<IndustryService>(context);

    return FutureBuilder(
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
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return AddressField(onSaved: (Map<String, dynamic> address) {
      setState(() {
        _address = address;
      });
    });
  }

  Widget _buildSkillField(BuildContext context) {
    IndustryService industryService = Provider.of<IndustryService>(context);

    return StreamBuilder(
      stream: _industryStream.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        String industry = snapshot.data;

        print(snapshot.data);

        return FutureBuilder(
          future: industryService.getSkills(
            industry,
            widget.settings.company,
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var progress = const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

            if (snapshot.connectionState == ConnectionState.waiting) {
              return progress;
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

            return progress;
          },
        );
      },
    );
  }

  Widget _buildTagField(BuildContext context) {
    TagService tagService = Provider.of<TagService>(context);

    return FutureBuilder(
      future: tagService.getAllTags(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Tag> data = snapshot.data;

          return FormSelect(
            multiple: true,
            title: translate('field.tags'),
            columns: 1,
            onChanged: (List<dynamic> ids) {
              _tags = ids;
            },
            options: data.map((Tag el) {
              return {
                'value': el.id,
                'label': el.name,
              };
            }).toList(),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);
    CompanyService companyService = Provider.of<CompanyService>(context);

    return FutureBuilder(
      future: companyService.getApplicationFormSettings(widget.settings.formId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          ApplicationForm form = snapshot.data;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 14.0,
                  ),
                  if (form.isExist(['contact.title']))
                    _buildTitleField(context),
                  if (form.isExist(['contact.first_name', 'contact.last_name']))
                    Row(
                      children: [
                        if (form.isExist(['contact.first_name']))
                          _buildFirstNameField(context),
                        if (form.isExist(['contact.last_name']))
                          _buildLastNameField(context)
                      ],
                    ),
                  if (form.isExist(['contact.gender']))
                    _buildGenderField(context),
                  if (form.isExist(['contact.email']))
                    _buildEmailField(context),
                  if (form.isExist(['contact.phone_mobile']))
                    _buildPhoneNumberField(context),
                  if (form.isExist(['contact.birthday']))
                    _buildBirthdayField(context),
                  if (form.isExist(['contact.address.street_address']))
                    _buildAddressField(context),
                  if (form.isExist(['nationality']))
                    _buildNationalityField(context),
                  if (form.isExist(['residency']))
                    _buildResidencyField(context),
                  if (form.isExist(['transportation_to_work']))
                    _transportationToWorkField(context),
                  if (form.isExist(['height', 'weight']))
                    Row(
                      children: [
                        if (form.isExist(['height']))
                          _buildHeightField(context),
                        if (form.isExist(['weight'])) _buildWeightField(context)
                      ],
                    ),
                  if (form
                      .isExist(['contact.bank_accounts.AccountholdersName']))
                    _buildBankAccountNameField(context),
                  if (form.isExist(['contact.bank_accounts.bank_name']))
                    _buildBankNameField(context),
                  if (form.isExist(['contact.bank_accounts.IBAN']))
                    _buildIbanField(context),
                  if (form.isExist(['skill'])) _buildIndustryField(context),
                  if (form.isExist(['skill'])) _buildSkillField(context),
                  if (form.isExist(['tag'])) _buildTagField(context),
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

        return Center(
          child: Padding(
            child: CircularProgressIndicator(),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        );
      },
    );
  }
}
