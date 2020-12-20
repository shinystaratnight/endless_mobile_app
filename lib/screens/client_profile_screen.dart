import 'package:flutter/material.dart';
import 'package:piiprent/models/client_contact_model.dart';
import 'package:piiprent/screens/change_password_screen.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:piiprent/widgets/profile_group.dart';
import 'package:provider/provider.dart';

class ClientProfileScreen extends StatelessWidget {
  Widget _buildContactDetails(ClientContact contact) {
    return ProfileGroup(
      title: 'Contact Details',
      onEdit: () {},
      content: [
        Container(
          child: Field(
            label: 'Email',
            initialValue: contact.email,
            readOnly: true,
          ),
        ),
        Container(
          child: Field(
            label: 'Phone',
            initialValue: contact.phone,
            readOnly: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ContactService contactService = Provider.of<ContactService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: FutureBuilder(
        future: contactService.getCompanyContactDetails(loginService.user.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          ClientContact contact = snapshot.data;

          return SingleChildScrollView(
            child: PageContainer(
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
                        image: contact.avatar != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  contact.avatar,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    contact.fullName,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                  ),
                  Center(
                    child: Text(
                      contact.company,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      contact.jobTitle,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildContactDetails(contact),
                  SizedBox(
                    height: 15.0,
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10),
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
            ),
          );
        },
      ),
    );
  }
}
