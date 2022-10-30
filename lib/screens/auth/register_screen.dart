import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/application_form_model.dart';
import 'package:piiprent/models/industry_model.dart';
import 'package:piiprent/models/skill_model.dart';
import 'package:piiprent/screens/auth/widgets.dart';
import 'package:piiprent/screens/widgets/custom_text_field_with_label.dart';
import 'package:piiprent/screens/widgets/perimart_outline_button.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:piiprent/services/company_service.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/country_service.dart';
import 'package:piiprent/services/industry_service.dart';
import 'package:piiprent/widgets/form_select.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  static final String name = '/Registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
  bool _birthdayIsEmpty = false;
  bool _numberisEmpty = false;
  String _industry;
  String _personalId;
  String _picture;
  List<Map<String, dynamic>> _skills;
  CountryCode _phoneCountryCode;
  Map<String, dynamic> _address;
  bool _registered = false;

  final StreamController _fetchingStream = StreamController();
  final StreamController _errorStream = StreamController();

  List<Option> titleOptions = [
    const Option(value: 'Mr.', title: 'Mr.'),
    const Option(value: 'Ms.', title: 'Ms.'),
    const Option(value: 'Mrs.', title: 'Mrs.'),
    const Option(value: 'Dr.', title: 'Dr.'),
  ];

  List<Option> genderOptions = [
    const Option(
      value: 'male',
      title: 'Male',
      translateKey: 'gender.male',
    ),
    const Option(
      value: 'female',
      title: 'Female',
      translateKey: 'gender.female',
    ),
  ];

  List<Option> residencyOptions = [
    const Option(
      value: 0,
      title: 'Unknown',
      translateKey: 'residency.unknown',
    ),
    const Option(
      value: '1',
      title: 'Citizen',
      translateKey: 'residency.citizen',
    ),
    const Option(
      value: '2',
      title: 'Permanent Resident',
      translateKey: 'residency.permanent_resident',
    ),
    const Option(
      value: '3',
      title: "Temporary Resident",
      translateKey: 'residency.temporary_resident',
    ),
  ];

  List<Widget> _fields = [];

  List<Option> transportationOptions = [
    const Option(
      value: "1",
      title: "Own Car",
      translateKey: 'transport.own_car',
    ),
    const Option(
      value: "2",
      title: "Public Transportation",
      translateKey: 'transport.public',
    )
  ];

  //formKeys
  GlobalKey<FormState> generalPageKey = GlobalKey<FormState>();
  GlobalKey<FormState> additionalPageKey = GlobalKey<FormState>();
  GlobalKey<FormState> financaialPageKey = GlobalKey<FormState>();
  GlobalKey<FormState> insdustrialPageKey = GlobalKey<FormState>();

  //provier instance
  CompanyService companyService;
  CountryService countryService;
  IndustryService industryService;

  //loading form setting and default values
  Future _loadFormSettings() async {
    try {
      _title = titleOptions[0].value;
      _gender = genderOptions[0].value;
      _transport = transportationOptions[0].value;
      form = await this
          .companyService
          .getApplicationFormSettings(companyService.settings.formId);
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }

  bool keyboardsHOWN = false;
  @override
  void initState() {
    super.initState();
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     keyboardsHOWN = visible;
    //   },
    // );
    this.companyService = Provider.of<CompanyService>(
      context,
      listen: false,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      this.countryService = Provider.of<CountryService>(
        context,
        listen: false,
      );
      this.industryService = Provider.of<IndustryService>(
        context,
        listen: false,
      );

      _industries = await industryService.getIndustries();
      this._loadFormSettings();
    });
  }

  _register(ContactService contactService) async {
    setState(() {
      _registrationInProcess = true;
    });
    _fetchingStream.add(true);
    _errorStream.add(null);

    try {
      var result = await contactService.register(
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
        personalId: _personalId,
        picture: _picture,
      );

      if (result == true) {
        setState(() {
          _registered = true;
        });

        setState(() {
          _registrationInProcess = true;
        });
        await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[400],
            content: const Text(
              'You are registered!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _errorStream.add(e.toString());
      setState(() {
        _registrationInProcess = false;
      });
    } finally {
      _fetchingStream.add(false);
      setState(() {
        _registrationInProcess = false;
      });
    }
  }

  ApplicationForm form;

  int pageIndex = 1;
  File imageFile;

  _takePicture(int i) async {
    final XFile image = await ImagePicker().pickImage(
        source: i == 1 ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 60);

    if (image != null) {
      imageFile = File(image.path);
      var result = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: 150,
        minHeight: 150,
        quality: 40,
        rotate: 90,
      );
      print('original file size: ${imageFile.lengthSync()}');
      print('compressed file size: ${result.length}');
      //final bytes = await image.readAsBytes();
      _picture = 'data:image/jpeg;base64,${base64.encode(result)}';
      setState(() {});
    }
  }

  bool _phoneIsNull = false;

  TextEditingController addressController = TextEditingController();
  TextEditingController residencyController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

  TextEditingController accountHolderController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController personalIDController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController kgController = TextEditingController();
  TextEditingController cmController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<Industry> _industries;
  List<Skill> _allSkill;

  bool _registrationInProcess = false;
  CustomPopupMenuController popupController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Scaffold(
            key: Key(pageIndex.toString()),
            backgroundColor: whiteColor,
            bottomSheet: !(MediaQuery.of(context).viewInsets.bottom > 70)
                ? Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: PrimaryOutlineButton(
                            btnText: translate('button.back'),
                            onPressed: () {
                              if (pageIndex != 1) pageIndex--;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: PrimaryButton(
                            btnText: pageIndex == 4
                                ? translate('button.done')
                                : translate('button.next'),
                            onPressed: () {
                              if (pageIndex == 1) {
                                if (_birthday == null) {
                                  _birthdayIsEmpty = true;
                                  setState(() {});
                                }
                                if (_phone == null) {
                                  _phoneIsNull = true;
                                } else {
                                  _phoneIsNull = false;
                                }
                                if (generalPageKey.currentState.validate() &&
                                    !_birthdayIsEmpty &&
                                    !_phoneIsNull) {
                                  if (_title != null &&
                                      _gender != null &&
                                      _phone != null) {
                                    setState(() {
                                      pageIndex++;
                                    });
                                  }
                                }
                              }
                              if (pageIndex == 2) {
                                if (additionalPageKey.currentState.validate()) {
                                  pageIndex++;
                                  setState(() {});
                                }
                              }
                              if (pageIndex == 3) {
                                if (financaialPageKey.currentState.validate()) {
                                  pageIndex++;
                                  setState(() {});
                                }
                              }
                              if (pageIndex == 4) {
                                if (insdustrialPageKey.currentState
                                    .validate()) {
                                  _register(contactService);
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    height: 78 + MediaQuery.of(context).padding.bottom,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            offset: Offset(0, -2),
                            blurRadius: 12)
                      ],
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                        right: 16,
                        left: 16),
                  )
                : null,
            appBar: AppBar(
              elevation: 0.0,
              titleSpacing: 0,
              centerTitle: false,
              title: Text(
                'Registration',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              actions: [
                LanguageSelect(
                  controller: popupController,
                  color: whiteColor,
                )
              ],
            ),
            body: form == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                              ),
                              Positioned(
                                top: 29,
                                right: 40,
                                left: 40,
                                child: Row(
                                  children: [
                                    ...List.generate(
                                      3,
                                      (index) => Expanded(
                                        child: Container(
                                          color: (index + 1) < pageIndex
                                              ? successColor
                                              : lightBlue,
                                          height: 2,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 16,
                                left: 16,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StepComponent(
                                      label: translate('General info'),
                                      number: '1',
                                      done: 1 < pageIndex,
                                      active: pageIndex == 1,
                                    ),
                                    StepComponent(
                                      label: translate('Additional info'),
                                      number: '2',
                                      done: 2 < pageIndex,
                                      active: pageIndex == 2,
                                    ),
                                    StepComponent(
                                      label: translate('Financial info'),
                                      number: '3',
                                      done: 3 < pageIndex,
                                      active: pageIndex == 3,
                                    ),
                                    StepComponent(
                                      label: translate('Industry & skills'),
                                      number: '4',
                                      done: 4 < pageIndex,
                                      active: pageIndex == 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          height: 102,
                          color: Color(0xffFBFBFD),
                        ),
                        if (pageIndex == 1) buildGeneralInfo(),
                        if (pageIndex == 2) buildAdditionalInfo(),
                        if (pageIndex == 3) buildFinancialInfo(),
                        if (pageIndex == 4) buildIdustryInfo(),
                      ],
                    ),
                  ),
          ),
          if (_registrationInProcess)
            Container(
              color: Colors.black.withOpacity(.5),
              width: double.infinity,
              height: double.infinity,
            ),
          if (_registrationInProcess)
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(onDoubleTap: (){},child: Text('Please Wait While We Register Your Account...'),),
                    SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator())
                  ],
                ),
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            )
        ],
      ),
    );
  }

  buildIdustryInfo() {
    return Form(
      key: insdustrialPageKey,
      child: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (form.isExist(['skill'])) ...[
                  CustomTextFieldWIthLabel(
                    controller: industryController,
                    hint: translate('field.industry').toUpperCase(),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Material(
                              color: Colors.transparent,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: StatefulBuilder(
                                    builder: (context, setState) => Column(
                                      children: [
                                        Text(translate('field.industry')),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                            child: ListView(
                                          children: [
                                            ..._industries.map((e) =>
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context, [e.id]);
                                                  },
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: primaryColor
                                                              .withOpacity(.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Text(e.name)),
                                                ))
                                          ],
                                        )),
                                        PrimaryButton(
                                          btnText: translate('button.cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              .1),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  height: 320,
                                  width: MediaQuery.of(context).size.width * .8,
                                ),
                              ),
                            );
                          }).then((value) {
                        if (value != null) {
                          industryController.text = _industries
                              .firstWhere((element) => element.id == value[0])
                              .name;
                          _industry = _industries
                              .firstWhere((element) => element.id == value[0])
                              .id;

                          industryService
                              .getSkills(
                            value[0],
                            companyService.settings.company,
                          )
                              .then((value) {
                            _allSkill = value;
                            setState(() {});
                          });
                        }
                      });
                    },
                  ),
                ],
                if (form.isExist(['skill'])) ...[
                  CustomTextFieldWIthLabel(
                    controller: skillsController,
                    hint: translate('field.skills').toUpperCase(),
                    onTap: _allSkill != null
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  List<String> selectedSkill = [];
                                  return Material(
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: StatefulBuilder(
                                          builder: (context, setState) =>
                                              Column(
                                            children: [
                                              Text(translate('field.skills')),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                  child: StatefulBuilder(
                                                builder: (context, setState) =>
                                                    ListView(
                                                  children: [
                                                    ..._allSkill.map((e) =>
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (selectedSkill
                                                                .contains(
                                                                    e.id)) {
                                                              selectedSkill
                                                                  .remove(e.id);
                                                            } else
                                                              selectedSkill
                                                                  .add(e.id);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                              margin:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  color: primaryColor
                                                                      .withOpacity(
                                                                          .3),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(e.name),
                                                                  if (selectedSkill
                                                                      .contains(
                                                                          e.id))
                                                                    Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      size: 15,
                                                                    )
                                                                ],
                                                              )),
                                                        ))
                                                  ],
                                                ),
                                              )),
                                              PrimaryButton(
                                                btnText:
                                                    translate('button.done'),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, [selectedSkill]);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .1),
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        height: 320,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                      ),
                                    ),
                                  );
                                }).then((value) {
                              if (value != null) {
                                _skills = [];
                                value[0].forEach((element) {
                                  _skills.add({'id': element.toString()});
                                });

                                skillsController.text = _allSkill
                                    .where((element) =>
                                        value[0].contains(element.id))
                                    .toList()
                                    .map((e) => e.name)
                                    .toList()
                                    .toString()
                                    .replaceFirst('[', '')
                                    .replaceFirst(']', '');
                              }
                            });
                          }
                        : () {},
                  ),
                ],
                SizedBox(
                  height: 100 + MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildFinancialInfo() {
    return Form(
      key: financaialPageKey,
      child: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (form
                    .isExist(['contact.bank_accounts.AccountholdersName'])) ...[
                  CustomTextFieldWIthLabel(
                    capital: true,
                    type: TextInputType.text,
                    controller: accountHolderController,
                    hint: translate('field.account_holders_name').toUpperCase(),
                    onChanged: (v) {
                      _bankAccountName = v;
                    },
                  ),
                ],
                if (form.isExist(['contact.bank_accounts.bank_name'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: bankNameController,
                    hint: translate('field.bank_name').toUpperCase(),
                    onChanged: (v) {
                      _bankName = v;
                    },
                  ),
                ],
                if (form.isExist(['contact.bank_accounts.IBAN'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: ibanController,
                    hint: translate('field.iban').toUpperCase(),
                    onChanged: (v) {
                      _iban = v;
                    },
                  ),
                ],
                if (form.isExist(['formalities.personal_id'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: personalIDController,
                    hint: translate('field.personal_id').toUpperCase(),
                    onChanged: (v) {
                      _personalId = v;
                    },
                  ),
                ],
                SizedBox(
                  height: 100 + MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildGeneralInfo() {
    return Form(
      key: generalPageKey,
      child: Column(
        children: [
          SizedBox(
            height: 35.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (form.isExist(['contact.picture'])) ...[
                  Container(
                    height: 150,
                    width: 150,
                    child: imageFile != null
                        ? Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            CupertinoIcons.person_fill,
                            size: 90,
                            color: primaryColor,
                          ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(.1)),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryOutlineButton(
                        btnText: translate('button.take_photo'),
                        onPressed: () {
                          _takePicture(1);
                        },
                      ),
                      Spacer(),
                      PrimaryOutlineButton(
                        btnText: 'Camera',
                        onPressed: () {
                          _takePicture(2);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
                if (form
                    .isExist(['contact.first_name', 'contact.last_name'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: firstNameController,
                    hint: translate('field.first_name').toUpperCase(),
                    onChanged: (v) {
                      _firstName = v;
                    },
                  ),
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: lastNameController,
                    hint: translate('field.last_name').toUpperCase(),
                    onChanged: (v) {
                      _lastName = v;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                if (form.isExist(['contact.gender'])) ...[
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 2.5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            translate('field.title').toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: greyColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '✱',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: warningColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            4,
                            (index) => CustomOptionPicker(
                                onPressed: () {
                                  _title = titleOptions[index].value;
                                  setState(() {});
                                },
                                title: titleOptions
                                    .firstWhere(
                                        (element) => element.value == _title)
                                    .title,
                                label: titleOptions[index].title),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 2.5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            translate('field.gender').toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: greyColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '✱',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: warningColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            2,
                            (index) => CustomOptionPicker(
                                onPressed: () {
                                  _gender = genderOptions[index].value;
                                  setState(() {});
                                },
                                title: genderOptions
                                    .firstWhere(
                                        (element) => element.value == _gender)
                                    .title,
                                label: genderOptions[index].title),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                if (form.isExist(['contact.birthday'])) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 2.5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            translate('field.birthday').toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: greyColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: warningColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            _birthdayIsEmpty = false;
                            _birthday = DateFormat('dd/MM/yyyy').format(value);
                            setState(() {});
                          });
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  _birthday ??
                                      translate('field.birthday').toUpperCase(),
                                  style: TextStyle(
                                      color: activeTextColor, fontSize: 16),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.calendar,
                                color: primaryColor,
                              )
                            ],
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 49,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: _birthdayIsEmpty
                                      ? warningColor
                                      : hintColor,
                                  width: 1)),
                        ),
                      ),
                      if (_birthdayIsEmpty)
                        Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              translate('field.required'),
                              style: TextStyle(
                                  color: warningColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                if (form.isExist(['height', 'weight']))
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFieldWIthLabel(
                          type: TextInputType.number,
                          controller: kgController,
                          hint: translate('field.weight').toUpperCase() + ',KG',
                          onChanged: (v) {
                            _weight = v;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomTextFieldWIthLabel(
                          type: TextInputType.number,
                          controller: cmController,
                          hint: translate('field.height').toUpperCase() + ',CM',
                          onChanged: (v) {
                            _height = v;
                          },
                        ),
                      ),
                    ],
                  ),
                if (form.isExist(['contact.email'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.emailAddress,
                    controller: emailController,
                    hint: translate('field.email').toUpperCase(),
                    onChanged: (v) {
                      _email = v;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
                if (form.isExist(['contact.phone_mobile'])) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 2.5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            translate('field.phone').toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: greyColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '✱',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: warningColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                width: 80,
                                child: CountryCodePicker(
                                  dialogSize: Size(
                                      MediaQuery.of(context).size.width - 40,
                                      MediaQuery.of(context).size.height -
                                          (MediaQuery.of(context)
                                                  .padding
                                                  .bottom +
                                              MediaQuery.of(context)
                                                  .padding
                                                  .top)),
                                  searchDecoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: hintColor, width: 1.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusColor: primaryColor,
                                      fillColor: whiteColor,
                                      filled: true,
                                      isDense: true,
                                      hintText: 'Search Country',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                      hintStyle: TextStyle(
                                          color: hintColor, fontSize: 16),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  padding: EdgeInsets.zero,
                                  onInit: (prefix) =>
                                      _phoneCountryCode = prefix,
                                  onChanged: (prefix) => setState(
                                      () => _phoneCountryCode = prefix),
                                  initialSelection:
                                      companyService.settings.countryCode,
                                  alignLeft: true,
                                  showFlag: true,
                                  showDropDownButton: false,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              color: hintColor,
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                                validator: (v) {},
                                onChanged: (v) {
                                  _phone = '$_phoneCountryCode$v';
                                  print(_phone);
                                  _phoneIsNull = false;
                                  setState(() {});
                                },
                                style: TextStyle(
                                    color: activeTextColor, fontSize: 16),
                                decoration: InputDecoration(
                                    focusColor: primaryColor,
                                    fillColor: whiteColor,
                                    filled: true,
                                    isDense: true,
                                    hintText: 'XXXXXXXXXXX',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    hintStyle: TextStyle(
                                        color: hintColor, fontSize: 16),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(right: 20),
                        height: 49,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: _phoneIsNull ? warningColor : hintColor,
                                width: 1)),
                      ),
                      if (_phoneIsNull)
                        Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              translate('field.required'),
                              style: TextStyle(
                                  color: warningColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            )),
                      SizedBox(
                        height: 100 + MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildAdditionalInfo() {
    return Form(
      key: additionalPageKey,
      child: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (form.isExist(['contact.address.street_address'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: addressController,
                    hint: translate('field.address').toUpperCase(),
                    onTap: () {
                      Navigator.pushNamed(context, '/address')
                          .then((value) async {
                        if (value != null) {
                          addressController.text =
                              (value as Map<String, dynamic>)['streetAddress'];
                          setState(() {
                            _address =
                                (value as Map<String, dynamic>)['address'];
                          });

                          final root = await getApplicationDocumentsDirectory();

                          File file = File('${root.path}/address.txt');
                          file.writeAsString(_address.toString());
                        }
                      });
                    },
                  ),
                ],
                if (form.isExist(['nationality'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: nationalityController,
                    hint: translate('field.nationality').toUpperCase(),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Material(
                              color: Colors.transparent,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: StatefulBuilder(
                                    builder: (context, setState) => Column(
                                      children: [
                                        Text(translate('field.nationality')),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                            child: ListView(
                                          children: [
                                            // CustomTextFieldWIthoutLabel(
                                            //   controller:
                                            //       nationalityControllerSearch,
                                            //   hint: 'Search',
                                            //   onChanged: (v) {
                                            //     nationalityControllerSearch.text =
                                            //         v;
                                            //     setState(() {});
                                            //   },
                                            // ),

                                            ...countries
                                                .map((e) => e['name'])
                                                .toList()
                                                .map((e) => GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(
                                                            context, [e]);
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.symmetric(
                                                                  vertical: 5),
                                                          padding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          10),
                                                          decoration: BoxDecoration(
                                                              color: primaryColor
                                                                  .withOpacity(
                                                                      .3),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Text(e)),
                                                    )),
                                          ],
                                        )),
                                        PrimaryButton(
                                          btnText: translate('button.cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              .1),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  height:
                                      MediaQuery.of(context).size.height * .8,
                                  width: MediaQuery.of(context).size.width * .8,
                                ),
                              ),
                            );
                          }).then((value) {
                        if (value != null)
                          nationalityController.text = value[0];
                        _nationality = value[0];
                      });
                    },
                  ),
                ],
                if (form.isExist(['residency'])) ...[
                  CustomTextFieldWIthLabel(
                    type: TextInputType.text,
                    controller: residencyController,
                    hint: translate('field.residency').toUpperCase(),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Material(
                              color: Colors.transparent,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: StatefulBuilder(
                                    builder: (context, setState) => Column(
                                      children: [
                                        Text(translate('field.residency')),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                            child: ListView(
                                          children: [
                                            ...residencyOptions.map((e) =>
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context, [e.value]);
                                                  },
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: primaryColor
                                                              .withOpacity(.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Text(e.title)),
                                                ))
                                          ],
                                        )),
                                        PrimaryButton(
                                          btnText: translate('button.cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              .1),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  height: 320,
                                  width: MediaQuery.of(context).size.width * .8,
                                ),
                              ),
                            );
                          }).then((value) {
                        if (value != null) {
                          residencyController.text = residencyOptions
                              .firstWhere(
                                  (element) => element.value == value[0])
                              .title;
                          _residency = value[0];
                        }
                      });
                    },
                  ),
                ],
                if (form.isExist(['transportation_to_work']))
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 2.5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            translate('field.transport').toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: greyColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '✱',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: warningColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            2,
                            (index) => CustomOptionPicker(
                                onPressed: () {
                                  _transport =
                                      transportationOptions[index].value;
                                  setState(() {});
                                },
                                title: transportationOptions
                                    .firstWhere((element) =>
                                        element.value == _transport)
                                    .title,
                                label: transportationOptions[index].title),
                          )
                        ],
                      )
                    ],
                  ),
                SizedBox(
                  height: 100 + MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomOptionPicker extends StatelessWidget {
  final String title;
  final String label;
  final VoidCallback onPressed;

  const CustomOptionPicker({Key key, this.title, this.label, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.only(right: label == 'Dr.' ? 0 : 5, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(
                title == label
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: title == label ? whiteColor : hintColor,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: title == label ? whiteColor : hintColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
          height: 39,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: title == label ? primaryColor : whiteColor,
              border: Border.all(color: hintColor)),
        ),
      ),
    );
  }
}
