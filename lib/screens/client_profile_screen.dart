import 'package:flutter/material.dart';
import 'package:piiprent/screens/change_password_screen.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/profile_group.dart';
import 'package:piiprent/widgets/stars.dart';

class ClientProfileScreen extends StatelessWidget {
  Widget _buildContactDetails() {
    return ProfileGroup(
      title: 'Contact Details',
      onEdit: () {},
      content: [
        Container(
          child: Field(
            label: 'Email',
          ),
        ),
        Container(
          child: Field(
            label: 'Phone',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('https://picsum.photos/200/300'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Mr. Peter Hokke',
                style: TextStyle(color: Colors.blueAccent, fontSize: 18.0),
              ),
              Center(
                child: Text('Smart Builders Ltd',
                    style: TextStyle(fontSize: 16.0)),
              ),
              SizedBox(height: 10.0),
              Center(
                child:
                    Text('Project Manager', style: TextStyle(fontSize: 16.0)),
              ),
              SizedBox(
                height: 15.0,
              ),
              _buildContactDetails(),
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
                  'Change Password',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }
}
