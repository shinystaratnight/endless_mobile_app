import 'package:cached_network_image/cached_network_image.dart';
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
import '../widgets/size_config.dart';

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
            SizeConfig().init(constraints, orientation);

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
                            height:size.height,
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
        //padding: EdgeInsets.symmetric(horizontal: 15.0),
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 3.65),
        child: SingleChildScrollView(
          child: Column(
            children: [
              (size.width < 801) && orientation == Orientation.landscape
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildImageAndContactDetails(
                                  context, contact, size, orientation),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 2.19,
                                //height: 15.0,
                              ),
                              MaterialButton(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.widthMultiplier * 14.60,
                                  vertical: SizeConfig.heightMultiplier * 1.46,
                                  // horizontal: 60,
                                  // vertical: 10,
                                ),
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  //borderRadius: BorderRadius.circular(20),
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.heightMultiplier * 2.92,
                                  ),
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
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.heightMultiplier * 2.34,
                                    //fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 2.34,
                                //height: 15.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 3.65,
                          //width: 15,
                        ),
                        Expanded(child: _buildContactExpandable(contact))
                      ],
                    )
                  : Column(
                      children: [
                        _buildImageAndContactDetails(
                            context, contact, size, orientation),
                        _buildContactExpandable(contact),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2.34,
                          //height: 15.0,
                        ),
                        MaterialButton(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 14.60,
                            vertical: SizeConfig.heightMultiplier * 1.46,
                            // horizontal: 60,
                            // vertical: 10,
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            //borderRadius: BorderRadius.circular(20),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.heightMultiplier * 2.92),
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
                            style: TextStyle(
                                //fontSize: 16,
                                fontSize: SizeConfig.heightMultiplier * 2.34),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 4.34,
                          //height: 15.0,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _buildImageAndContactDetails(
      context, contact, Size size, Orientation orientation) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 2.92,
          //height: 20.0,
        ),
        Center(
          child: Container(
            height: SizeConfig.heightMultiplier * 18.04,
            width: SizeConfig.widthMultiplier * 30.33,
            // height: size.width > 950 && size.height > 450 ? 300 : 100,
            // width: size.width > 950 && size.height > 450 ? 300 : 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  // size.width > 950 && size.height > 450 ? 180 : 60
                  SizeConfig.heightMultiplier * 8.78),
              child: CachedNetworkImage(
                imageUrl: contact.avatar ?? '',
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  height: SizeConfig.heightMultiplier * 18.04,
                  width: SizeConfig.widthMultiplier * 30.33,
                  // height: size.width > 950 && size.height > 450 ? 300 : 100,
                  // width: size.width > 950 && size.height > 450 ? 300 : 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => ImageContainer(
                  content: Container(
                    color: Colors.grey[400],
                    child: new Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1.46,
          // height: 10.0,
        ),
        Text(
          contact.fullName,
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: SizeConfig.heightMultiplier * 2.64,
            //fontSize: 18.0,
          ),
        ),
        Center(
          child: Text(
            contact.company,
            style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2.34
                //fontSize: 16.0,
                ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1.46,
          // height: 10.0,
        ),
        Center(
          child: Text(
            contact.jobTitle,
            style: TextStyle(fontSize: SizeConfig.heightMultiplier * 2.34
                //fontSize: 16.0,
                ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 2.34,
          //height: 15.0,
        ),
      ],
    );
  }
}
