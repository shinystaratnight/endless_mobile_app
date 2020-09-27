import 'package:flutter/material.dart';
import 'package:piiprent/screens/change_password_screen.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/profile_group.dart';
import 'package:piiprent/widgets/stars.dart';

class CandidateProfileScreen extends StatelessWidget {
  Widget _buildPersonalDetails() {
    return ProfileGroup(
      title: 'Personal Details',
      onEdit: () {},
      canEdit: true,
      content: [
        Row(
          children: [
            Expanded(
              child: Field(
                label: 'First name',
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Last name',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Field(
                label: 'Height',
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Weight',
              ),
            ),
          ],
        ),
        Container(
          child: Field(
            label: 'BMI',
          ),
        ),
        Container(
          child: Field(
            label: 'Birthday',
          ),
        ),
      ],
    );
  }

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
        Container(
          child: Field(
            label: 'Address',
          ),
        ),
      ],
    );
  }

  Widget _buildScore() {
    return ProfileGroup(
      title: 'Score',
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Average test'),
              Stars(
                active: 3,
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[700],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Client feedback'),
              Stars(
                active: 3,
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[700],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reliability'),
              Stars(
                active: 3,
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[700],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Loyality'),
              Stars(
                active: 3,
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[700],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Everage skill'),
              Stars(
                active: 3,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResidency() {
    return ProfileGroup(
      title: 'Residency',
      content: [
        Row(
          children: [
            Expanded(
              child: Field(
                label: 'Residency status',
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Nationality',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Field(
                label: 'Visa type',
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Visa expire date',
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getCandidateAppBar('Profile', context),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mr. Peter Hokke',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 14.0,
                        ),
                        Text(
                          '4.00',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Text('Some address very long address',
                    style: TextStyle(fontSize: 16.0)),
              ),
              SizedBox(height: 10.0),
              Center(
                child:
                    Text('Brick/blocklayer', style: TextStyle(fontSize: 16.0)),
              ),
              SizedBox(
                height: 15.0,
              ),
              _buildPersonalDetails(),
              SizedBox(
                height: 15.0,
              ),
              _buildContactDetails(),
              SizedBox(
                height: 15.0,
              ),
              _buildScore(),
              SizedBox(
                height: 15.0,
              ),
              _buildResidency(),
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
