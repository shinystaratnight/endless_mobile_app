import 'package:flutter/material.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/page_container.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Column(
            children: [
              Field(label: 'Current password'),
              Field(label: 'New password'),
              Field(label: 'Verify password'),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                color: Colors.blueAccent,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
