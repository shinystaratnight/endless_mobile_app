import 'package:flutter/material.dart';
import 'package:piiprent/services/company_service.dart';
import 'package:piiprent/widgets/login_form.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:piiprent/widgets/register_form.dart';
import 'package:provider/provider.dart';

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
            color: active ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(35),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CompanyService companyService = Provider.of<CompanyService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: PageContainer(
          child: FutureBuilder(
            future: companyService.getSettings(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 45.0),
                      child: Image.asset('images/company_banner.png'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                        border: Border.all(
                          color: Colors.grey[700],
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildPageButton(_activeForm == 'login', 'Login',
                              () => setState(() => _activeForm = 'login')),
                          SizedBox(
                            width: 10,
                          ),
                          _buildPageButton(_activeForm == 'register', 'Sign Up',
                              () => setState(() => _activeForm = 'register'))
                        ],
                      ),
                    ),
                    _activeForm == 'login'
                        ? LoginForm(
                            onRegister: () =>
                                setState(() => _activeForm = 'register'))
                        : RegisterForm(settings: snapshot.data),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
