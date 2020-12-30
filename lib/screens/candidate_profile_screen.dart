import 'package:flutter/material.dart';
import 'package:piiprent/helpers/validator.dart';
import 'package:piiprent/models/average_scores_model.dart';
import 'package:piiprent/models/candidate_model.dart';
import 'package:piiprent/models/candidate_skill_model.dart';
import 'package:piiprent/models/candidate_tag_model.dart';
import 'package:piiprent/screens/change_password_screen.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/form_field.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:piiprent/widgets/profile_group.dart';
import 'package:piiprent/widgets/score_badge.dart';
import 'package:piiprent/widgets/stars.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CandidateProfileScreen extends StatefulWidget {
  @override
  _CandidateProfileScreenState createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  int _heigth;
  int _weight;
  bool _fetching = false;
  dynamic _formError;
  Map<String, bool> _editMap = {'details': false, 'skills': false};
  GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();

  _onSavePersonalDetails(
    CandidateService candidateService,
    Candidate candidate,
  ) async {
    String id = candidate.id;
    String contactId = candidate.contact.id;

    if (!_detailsFormKey.currentState.validate()) {
      return;
    }

    _detailsFormKey.currentState.save();

    setState(() {
      _fetching = true;
      _formError = null;
    });

    try {
      bool result = await candidateService.updatePersonalDetails(
        id: id,
        contactId: contactId,
        height: _heigth == null ? candidate.height : _heigth,
        weight: _weight == null ? candidate.weight : _weight,
      );

      if (result) {
        setState(() {
          _editMap['details'] = false;
        });
      }
    } catch (e) {
      setState(() {
        _formError = e;
      });
    } finally {
      setState(() {
        _fetching = false;
      });
    }
  }

  Widget _listItem({Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[700],
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: child,
    );
  }

  Widget _buildPersonalDetails(
    Candidate candidate, [
    bool edit = false,
    Function onEdit,
  ]) {
    CandidateService candidateService = Provider.of<CandidateService>(context);

    return ProfileGroup(
      title: 'Personal Details',
      onEdit: onEdit != null ? onEdit : () {},
      canEdit: true,
      isEditing: edit,
      content: [
        Row(
          children: [
            Expanded(
              child: Field(
                label: 'First name',
                initialValue: candidate.firstName,
                readOnly: true,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Last name',
                initialValue: candidate.lastName,
                readOnly: true,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Field(
                label: 'Height',
                type: TextInputType.number,
                initialValue: candidate.height.toString(),
                readOnly: !edit,
                validator: numberValidator,
                onChanged: (String value) {
                  setState(() {
                    _heigth = int.parse(value);
                  });
                },
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Weight',
                initialValue: candidate.weight.toString(),
                readOnly: !edit,
                validator: numberValidator,
                onChanged: (String value) {
                  setState(() {
                    _weight = int.parse(value);
                  });
                },
              ),
            ),
          ],
        ),
        Container(
          child: Field(
            label: 'BMI',
            initialValue: candidate.bmi,
            readOnly: true,
          ),
        ),
        Container(
          child: Field(
            label: 'Birthday',
            initialValue: DateFormat('dd/MM/yyyy').format(candidate.birthday),
            readOnly: true,
          ),
        ),
        edit
            ? FormSubmitButton(
                disabled: _fetching,
                onPressed: () => _onSavePersonalDetails(
                  candidateService,
                  candidate,
                ),
                label: 'Update',
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildContactDetails(Candidate candidate) {
    return ProfileGroup(
      title: 'Contact Details',
      onEdit: () {},
      content: [
        Container(
          child: Field(
            label: 'Email',
            initialValue: candidate.email,
            readOnly: true,
          ),
        ),
        Container(
          child: Field(
            label: 'Phone',
            initialValue: candidate.phone,
            readOnly: true,
          ),
        ),
        Container(
          child: Field(
            label: 'Address',
            initialValue: candidate.address,
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSkills(List<CandidateSkill> skills) {
    return ProfileGroup(
      title: 'Skills',
      onEdit: () {},
      canEdit: true,
      content: skills
          .map(
            (e) => _listItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.skill.name),
                  ScoreBadge(score: e.score),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildScore(AverageScores averageScores) {
    return ProfileGroup(
      title: 'Score',
      content: [
        _listItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Average test'),
              Stars(
                active: averageScores.recruitmentScore,
              )
            ],
          ),
        ),
        _listItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Client feedback'),
              Stars(
                active: averageScores.clientFeedback,
              )
            ],
          ),
        ),
        _listItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reliability'),
              Stars(
                active: averageScores.reliability,
              )
            ],
          ),
        ),
        _listItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Loyality'),
              Stars(
                active: averageScores.loyality,
              )
            ],
          ),
        ),
        _listItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Everage skill'),
              Stars(
                active: averageScores.skillScore,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResidency(Candidate candidate) {
    return ProfileGroup(
      title: 'Residency',
      content: [
        Row(
          children: [
            Expanded(
              child: Field(
                label: 'Residency status',
                initialValue: candidate.residency,
                readOnly: true,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Nationality',
                initialValue: candidate.nationality,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Field(
                label: 'Visa type',
                initialValue: candidate.visaType,
                readOnly: true,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Field(
                label: 'Visa expire date',
                initialValue: candidate.visaExpiryDate != null
                    ? DateFormat('dd/MM/yyyy').format(candidate.visaExpiryDate)
                    : '',
                readOnly: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTags(List<CandidateTag> tags) {
    return ProfileGroup(
      title: 'Tags',
      content: tags
          .map(
            (e) => _listItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.tag.name),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    CandidateService candidateService = Provider.of<CandidateService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return Scaffold(
      appBar: getCandidateAppBar('Profile', context),
      body: FutureBuilder(
        future: candidateService.getCandidate(loginService.user.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Candidate candidate = snapshot.data;

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
                        image: loginService.user.userAvatarUrl() != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  loginService.user.userAvatarUrl(),
                                ),
                              )
                            : null,
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
                        loginService.user.name,
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18.0,
                        ),
                      ),
                      ScoreBadge(
                        score: candidate.averageScore,
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      candidate.address,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      candidate.designation,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Form(
                    key: _detailsFormKey,
                    child: _buildPersonalDetails(
                      candidate,
                      _editMap['details'],
                      () {
                        bool isEdit = _editMap['details'];
                        print(isEdit);
                        setState(
                          () {
                            _editMap['details'] = !isEdit;
                            _editMap = _editMap;
                          },
                        );
                        print(!isEdit);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildContactDetails(candidate),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildSkills(candidate.skills),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildScore(candidate.averageScores),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildResidency(candidate),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildTags(candidate.tags),
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
