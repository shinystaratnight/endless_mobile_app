import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/application_form_model.dart';
import 'package:piiprent/screens/widgets/custom_text_field_with_label.dart';
import 'package:piiprent/screens/widgets/perimart_outline_button.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../../services/company_service.dart';
import '../timesheets_details/widgets/date_picker_box_widget.dart';

class CandidateAcceptanceForm extends StatefulWidget {
  static final String name = '/CandidateAcceptandeForm';

  @override
  _CandidateAcceptanceFormState createState() =>
      _CandidateAcceptanceFormState();
}

class _CandidateAcceptanceFormState extends State<CandidateAcceptanceForm> {
  int pageIndex = 1;
  ApplicationForm form;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _registrationInProcess = false;

  int currentStep = 1;
  int _europeanPass = 0;
  int _drivingLicense = 0;
  int _covid = 0;
  int _privateCar = 1;

  int _officeDistance = 2;

  int _publicTransfort = 1;

  int _languageSpoken = 1;

  int _whenCanStartWork = 0;

  String _firstName='';

  String _email='';

  String _phone='';

  bool _phoneIsNull=false;

  var _phoneCountryCode;
  CompanyService companyService;
  Future _loadFormSettings() async {
    try {

      form = await this
          .companyService
          .getApplicationFormSettings(companyService.settings.formId);
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }
  @override
  initState(){
    this.companyService = Provider.of<CompanyService>(
      context,
      listen: false,
    );
    this.companyService.fetchSettings();
    this._loadFormSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              if (pageIndex > 1) {
                                setState(() {
                                  pageIndex--;
                                  currentStep--;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: PrimaryButton(
                            buttonColor:
                                pageIndex == 9 ? Color(0xff66BA6C) : null,
                            btnText: pageIndex == 9
                                ? translate('button.submit')
                                : translate('button.next'),
                            onPressed: () {
                              if (pageIndex < 9) {
                                setState(() {
                                  pageIndex++;
                                  currentStep++;
                                });
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
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'General Questions',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, color: Colors.white, size: 24)),
              ],
            ),
            body:
                // form == null
                //     ? Center(
                //     child: CircularProgressIndicator(
                //       color: primaryColor,
                //     ))
                //     :
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: '0$currentStep ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff2196F3),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'of 09',
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffBCC8D6),
                                        ),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: LinearProgressBar(
                                  maxSteps: 9,
                                  minHeight: 10,
                                  progressType: LinearProgressBar
                                      .progressTypeLinear, // Use Linear progress
                                  currentStep: currentStep,
                                  progressColor: Color(0xff2196F3),
                                  backgroundColor: Color(0xffEEF6FF),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    height: 102,
                    color: Color(0xffFBFBFD),
                  ),
                  if (pageIndex == 1) buildEuropeanPassport(),
                  if (pageIndex == 2) buildDrivingLicense(),
                  if (pageIndex == 3) buildCovid(),
                  if (pageIndex == 4) buildPrivateCar(),
                  if (pageIndex == 5) buildHowFarWork(),
                  if (pageIndex == 6) buildPublicTransport(),
                  if (pageIndex == 7) buildLanguages(),
                  if (pageIndex == 8) buildWhenCanStartWork(),
                  if (pageIndex == 9) buildWorkMates(),
                  SizedBox(height: MediaQuery.of(context).size.height*0.2,),
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
                    InkWell(
                      onDoubleTap: () {},
                      child:
                          Text('Please Wait While We Register Your Account...'),
                    ),
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

  buildGeneralInfo(Color color) {
    return Container(
      height: 200,
      width: 200,
      color: color,
    );
  }

  buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  buildEuropeanPassport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('Do you have an European passport or ID card?'),
        SizedBox(
          height: 6,
        ),
        WhiteShadowContainer(
          title: 'Yes',
          value: 0,
          selectedOptions: _europeanPass,
          onChanged: (val) {
            setState(() {
              _europeanPass = val;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        WhiteShadowContainer(
          title: 'No',
          value: 1,
          selectedOptions: _europeanPass,
          onChanged: (val) {
            setState(() {
              _europeanPass = val;
            });
          },
        ),
      ],
    );
  }

  buildDrivingLicense() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('Do you have a driving licence?'),
        SizedBox(
          height: 6,
        ),
        WhiteShadowContainer(
          title: 'Yes',
          value: 0,
          selectedOptions: _drivingLicense,
          onChanged: (val) {
            setState(() {
              _drivingLicense = val;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        WhiteShadowContainer(
          title: 'No',
          value: 1,
          selectedOptions: _drivingLicense,
          onChanged: (val) {
            setState(() {
              _drivingLicense = val;
            });
          },
        ),
      ],
    );
  }

  buildCovid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('Do you have a COVID certificate?'),
        SizedBox(
          height: 6,
        ),
        WhiteShadowContainer(
          title: 'Yes',
          value: 0,
          selectedOptions: _covid,
          onChanged: (val) {
            setState(() {
              _covid = val;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        WhiteShadowContainer(
          title: 'No',
          value: 1,
          selectedOptions: _covid,
          onChanged: (val) {
            setState(() {
              _covid = val;
            });
          },
        ),
      ],
    );
  }

  buildPrivateCar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
            'Do you have the opportunity to use a private car to drive to work?'),
        SizedBox(
          height: 6,
        ),
        WhiteShadowContainer(
          title: 'Yes',
          value: 0,
          selectedOptions: _privateCar,
          onChanged: (val) {
            setState(() {
              _privateCar = val;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        WhiteShadowContainer(
          title: 'No',
          value: 1,
          selectedOptions: _privateCar,
          onChanged: (val) {
            setState(() {
              _privateCar = val;
            });
          },
        ),
      ],
    );
  }

  List<String> farWorks = [
    '0 - 1 km',
    '2 - 5 km',
    '5 - 10 km',
    '> 10 km',
  ];
  buildHowFarWork() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('How far are you ready to go to work?'),
        SizedBox(
          height: 6,
        ),
        SizedBox(
          height: 400,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ...List.generate(
                  farWorks.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: WhiteShadowContainer(
                      title: farWorks[index],
                      value: index,
                      selectedOptions: _officeDistance,
                      onChanged: (val) {
                        setState(() {
                          _officeDistance = val;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildPublicTransport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(
            'Do you use public transport if you have to drive to work for up to 30 minutes?'),
        SizedBox(
          height: 6,
        ),
        WhiteShadowContainer(
          title: 'Yes',
          value: 0,
          selectedOptions: _publicTransfort,
          onChanged: (val) {
            setState(() {
              _publicTransfort = val;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        WhiteShadowContainer(
          title: 'No',
          value: 1,
          selectedOptions: _publicTransfort,
          onChanged: (val) {
            setState(() {
              _publicTransfort = val;
            });
          },
        ),
      ],
    );
  }

  List<String> languages = [
    'Finnish',
    'Russian',
    'English',
    'Estonian',
    'Other',
  ];
  buildLanguages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('What languages do you speak?'),
        SizedBox(
          height: 6,
        ),
        SizedBox(
          height: 400,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ...List.generate(
                  languages.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: WhiteShadowContainer(
                      isRadio: false,
                      title: languages[index],
                      value: index,
                      selectedOptions: _languageSpoken,
                      onChanged: (val) {
                        setState(() {
                          _languageSpoken = val;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildWhenCanStartWork() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle('When you can start work?'),
        SizedBox(
          height: 6,
        ),
        WhiteShadowContainer(
          title: 'Tomorrow',
          value: 0,
          selectedOptions: _whenCanStartWork,
          onChanged: (val) {
            setState(() {
              _whenCanStartWork = val;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        WhiteShadowContainer(
          title: 'Select Day',
          value: 1,
          selectedOptions: _whenCanStartWork,
          onChanged: (val) {
            setState(() {
              _whenCanStartWork = val;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: _whenCanStartWork == 1,
          child: SizedBox(
            height: 62,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DatePickerBoxWidget(
                initialDate: DateTime.now(),
                onDateSelected: (DateTime startDate) {
                  DateTime _dateTime = DateTime(
                    startDate.year,
                    startDate.month,
                    startDate.day,
                    DateTime.now().hour,
                    DateTime.now().minute,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildWorkMates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
          child: Text(
            'In case you have a workmates, friends, acquaintances who could work for us with you, please write their names, phone numbers and e-mail addresses here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:Color(0xffEEF6FF),
                offset: Offset(0,2),
                spreadRadius: 3,
                blurRadius: 3
              )
            ]
          ),
          child: Column(
            children: [
              SizedBox(height: 15,),
              CustomTextFieldWIthLabel(
                type: TextInputType.text,
                controller: _firstNameController,
                hint: translate('field.first_name').toUpperCase(),
                onChanged: (v) {
                  _firstName = v;
                },
              ),
              SizedBox(height: 8,),
              CustomTextFieldWIthLabel(
                type: TextInputType.emailAddress,
                controller: emailController,
                hint: translate('field.email').toUpperCase(),
                onChanged: (v) {
                  _email = v;
                },
              ),
              SizedBox(height: 8,),
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
                              initialSelection:'US',
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
                    height: 20 + MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
              PrimaryButton(
                buttonColor: Color(0xff2196F3),
                btnText:  translate('button.save'),
                onPressed: () {

                },
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Workmates, friends, acquaintances:',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 5,),
        Container(
          height: 80,
          margin:EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color:Color(0xffEEF6FF),
                    offset: Offset(0,2),
                    spreadRadius: 3,
                    blurRadius: 3
                )
              ]
          ),
          child:ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Anne Mägi',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            subtitle:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4,),
                Text(
                  'ingrid.toots@hotmail.com',
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '+372 687 36 24',
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Icon(Icons.clear,size: 30,color: Color(0xffBCC8D6),),
            ),
          ),
        ),
      ],
    );
  }

}

class WhiteShadowContainer extends StatefulWidget {
  WhiteShadowContainer(
      {Key key,
      this.selectedOptions,
      this.onChanged,
      this.title,
      this.value,
      this.isRadio})
      : super(key: key);
  int selectedOptions;
  final bool isRadio;
  final Function(int) onChanged;
  final String title;
  final int value;
  @override
  State<WhiteShadowContainer> createState() => _WhiteShadowContainerState();
}

class _WhiteShadowContainerState extends State<WhiteShadowContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(widget.value);
        print('selected:${widget.selectedOptions}');
        print('value:${widget.value}');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: widget.value == widget.selectedOptions
                ? Colors.blue
                : Colors.transparent,
            width: 0.7,
          ),
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Color(0xffD3DEEA).withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: widget.isRadio != null && widget.isRadio == false
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: widget.value == widget.selectedOptions
                              ? Colors.blue
                              : Color(0xffD3DEEA),
                          width: 0.9,
                        ),
                      ),
                      child: widget.value == widget.selectedOptions
                          ? Icon(
                              Icons.done,
                              size: 9,
                              color: Colors.blue,
                            )
                          : null,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.title,
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Color(0xffBCC8D6),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : RadioListTile(
                value: widget.value,
                groupValue: widget.selectedOptions,
                onChanged: (value) {
                  onChange(value);
                },
                title: Text(
                  widget.title,
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Color(0xffBCC8D6),
                      fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }

  void onChange(value) {
    setState(() {
      widget.selectedOptions = value;
      widget.onChanged(widget.selectedOptions);
    });
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
