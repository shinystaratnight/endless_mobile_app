import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/screens/auth/register_screen.dart';
import 'package:piiprent/screens/widgets/primary_button.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/language-select.dart';
import 'package:provider/provider.dart';

import '../../helpers/validator.dart';
import '../../widgets/form_message.dart';
import '../forgot_password_screen.dart';
import '../widgets/custom_text_field_without_label.dart';

class LoginScreen extends StatefulWidget {
  static final String name = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username;
  String _password;
  String _formError;
  bool _fetching = false;

  _onLogin(LoginService loginService, ContactService contactService) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
   LoginProvider loginProvider = Provider.of<LoginProvider>(context,listen: false);
    // _formKey.currentState.save();

    setState(() {
      _fetching = true;
      _formError = null;
    });

    try {
      RoleType type = await loginService.login(_username, _password);

      if (type == RoleType.Candidate) {
        if (loginProvider.image == null)
          Provider.of<ContactService>(context, listen: false)
              .getContactPicture(
              loginService.user.userId)
              .then((value) {
            loginProvider.image = value;
            setState(() {});
          });
        Navigator.pushNamed(context, '/candidate_home');

        return;
      } else if (type == RoleType.Client) {
        List<Role> roles = await contactService.getRoles();
        roles[0].active = true;
        loginService.user.roles = roles;
        if (loginProvider.image == null)
          Provider.of<ContactService>(context, listen: false)
              .getContactPicture(
              loginService.user.userId)
              .then((value) {
            loginProvider.image = value;
            setState(() {});
          });

        Navigator.pushNamed(context, '/client_home');
        return;
      }
    } catch (e) {
      setState(() {
        _fetching = false;
        _formError = e?.toString() ?? 'Unexpected error occurred.';
      });
    }
  }

  CustomPopupMenuController popupController = CustomPopupMenuController();
  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);
    ContactService contactService = Provider.of<ContactService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: SafeArea(
                          bottom: false,
                          child: LanguageSelect(
                            controller: popupController,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Image.asset(
                        'images/company_banner.png',
                        width: 200,
                        // height: 44,
                      ),
                    ],
                  ),

                  // SizedBox(
                  //   height: (MediaQuery.of(context).size.height -
                  //               (622 +
                  //                   MediaQuery.of(context).padding.bottom +
                  //                   MediaQuery.of(context).padding.top)) >
                  //           0
                  //       ? MediaQuery.of(context).size.height -
                  //           (622 +
                  //               MediaQuery.of(context).padding.bottom +
                  //               MediaQuery.of(context).padding.top +
                  //               15)
                  //       : 35,
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(translate('text.login_page'),
                          style: TextStyle(
                              color: greyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegistrationScreen.name);
                        },
                        child: Text(translate('link.register_here'),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      ),
                      SafeArea(
                        top: false,
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                    ],
                  ),
                  // RegisterForm(
                  //   key: key,
                  //   settings: companyService.settings,
                  // ),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 56),
                  padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                  width: MediaQuery.of(context).size.width-32,
                  constraints: BoxConstraints(
                    maxWidth: 550,
                    maxHeight: 550
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          translate('button.login'),
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        CustomTextFieldWIthoutLabel(
                          hint: translate('field.email'),
                          onChanged: (v) {
                            _username = v;
                          },
                          validator: emailValidator,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomTextFieldWIthoutLabel(
                          passowrd: true,
                          hint: translate('field.password'),
                          onChanged: (v) {
                            _password = v;
                          },
                        ),
                        Spacer(),
                        FormMessage(type: MessageType.Error, message: _formError),
                        Spacer(),
                        PrimaryButton(
                          btnText: translate('button.login'),
                          onPressed: () => _onLogin(loginService, contactService),
                          loading: _fetching,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, ForgotPasswordScreen.name);
                          },
                          child: Text(
                            translate('link.forgot_password'),
                            style: TextStyle(color: primaryColor, fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  height: 345,
                  //width: MediaQuery.of(context).size.width - 32,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color(0xff5D7CAC).withOpacity(.13),
                        blurRadius: 38,
                        spreadRadius: 0,
                        offset: Offset(0, 4))
                  ], color: Colors.white, borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
