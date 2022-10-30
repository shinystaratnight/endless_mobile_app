import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/models/client_contact_model.dart';
import 'package:piiprent/screens/change_password_screen.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/profile_group.dart';
import 'package:provider/provider.dart';

import '../widgets/candidate_drawer.dart';

class ClientProfileScreen extends StatelessWidget {
  Widget _buildContactExpandable(ClientContact contact) {
    return ProfileGroup(
      title: translate('group.title.contact_details'),
      onEdit: () {},
      content: [
        Container(
          child: Field(
            label: translate('field.email'),
            initialValue: contact.email,
            readOnly: true,
          ),
        ),
        Container(
          child: Field(
            label: translate('field.phone'),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            Size size = Size(constraints.maxWidth, constraints.maxHeight);
            return Scaffold(
              appBar: getClientAppBar(translate('page.title.profile'), context),
              body: FutureBuilder(
                future: contactService
                    .getCompanyContactDetails(loginService.user.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  ClientContact contact = snapshot.data;

                  return SafeArea(
                    child: size.width > 798 && size.height > 360
                        ? Container(
                            width: size.width,
                            height: orientation == Orientation.portrait
                                ? size.height * 0.65
                                : size.height,
                            child: Center(
                              child: _buildProfileWidget(
                                  context, size, contact, orientation),
                            ),
                          )
                        : _buildProfileWidget(
                            context, size, contact, orientation),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileWidget(
      context, Size size, contact, Orientation orientation) {
    return Container(
      width: size.width,
      constraints: BoxConstraints(maxWidth: 650),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.width < 801) && orientation == Orientation.landscape
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildImageAndContactDetails(context, contact,size,orientation),
                              SizedBox(
                                height: 15.0,
                              ),
                              MaterialButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 10),
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangePasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  translate('button.change_password'),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(child: _buildContactExpandable(contact))
                      ],
                    )
                  : Column(
                      children: [
                        _buildImageAndContactDetails(context, contact,size,orientation),
                        _buildContactExpandable(contact),
                        SizedBox(
                          height: 15.0,
                        ),
                        MaterialButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 10),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            translate('button.change_password'),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _buildImageAndContactDetails(context, contact,Size size,Orientation orientation) {
    return Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        Center(
          child: Container(
            height:size.width>950 && size.height>450?300: 100,
            width:size.width>950 && size.height>450?300: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width>950 && size.height>450?180:60),
              child: CachedNetworkImage(
                imageUrl: contact.avatar,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  height:size.width>950 && size.height>450?300: 100,
                  width:size.width>950 && size.height>450?300: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: new CircularProgressIndicator(),),
                ),
                errorWidget: (context, url, error) =>
                    ImageContainer(
                      content: Center(child: new Icon(Icons.error),),
                    ),
              ),
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
      ],
    );
  }
}
