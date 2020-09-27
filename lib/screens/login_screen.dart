import 'package:flutter/material.dart';
import 'package:piiprent/widgets/login_form.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:piiprent/widgets/register_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _activeForm = 'login';

  Widget _buildPageButton(bool active, String title, Function onTap) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            color: active ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(35),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
                color: active ? Colors.white : Colors.grey[700], fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageContainer(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 45.0),
                  Image.asset('images/company_banner.png'),
                  SizedBox(
                    height: 45.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                      border: Border.all(
                          width: 1,
                          color: Colors.grey[700],
                          style: BorderStyle.solid),
                    ),
                    child: Row(
                      children: [
                        _buildPageButton(_activeForm == 'login', 'Login', () {
                          setState(() {
                            _activeForm = 'login';
                          });
                        }),
                        SizedBox(
                          width: 10,
                        ),
                        _buildPageButton(_activeForm == 'register', 'Sign Up',
                            () {
                          setState(() {
                            _activeForm = 'register';
                          });
                        })
                      ],
                    ),
                  ),
                  _activeForm == 'login'
                      ? LoginForm(
                          onRegister: () {
                            setState(() {
                              _activeForm = 'register';
                            });
                          },
                        )
                      : RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
