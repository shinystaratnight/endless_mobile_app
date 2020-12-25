import 'package:flutter/material.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context);

    loginService.getUser().then((RoleType role) {
      if (role == RoleType.Candidate) {
        Navigator.pushNamed(context, '/candidate_home');
      } else if (role == RoleType.Client) {
        Navigator.pushNamed(context, '/client_home');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/company_banner.png'),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
