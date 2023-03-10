import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/api_error_model.dart';
import 'package:piiprent/models/client_contact_model.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/services/api_service.dart';

class ContactService {
  final ApiService apiService = ApiService.create();

  Future<bool> forgotPassowrd(String email) async {
    http.Response res = await apiService.post(
      path: '/core/contacts/forgot_password/',
      body: {'email': email},
    );

    if (res.statusCode == 200) {
      // Map<String, dynamic> body = json.decode(res.body);

      return true;
    } else {
      throw Exception("User with this email doesn't exist");
    }
  }

  Future switchAccount() async {
    http.Response res = await apiService.get(path: '/auth/restore_session/');

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> roles = body["data"]["roles"];
      return roles.map((dynamic el) => RoleSwitchUser.fromJson(el)).toList();
    } else {
      throw Exception("User with this email doesn't exist");
    }
  }

  Future<String> changePassowrd({
    String oldPass,
    String newPass,
    String confirmPass,
    String id,
  }) async {
    var body = {
      'old_password': oldPass,
      'password': newPass,
      'confirm_password': confirmPass,
    };

    http.Response res = await apiService.put(
      path: '/core/contacts/$id/change_password/',
      body: body,
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));

      return body['message'];
    } else {
      throw Exception("Password was not change");
    }
  }

  Future<bool> register(
      {title,
      email,
      phone,
      firstName,
      birthday,
      lastName,
      industry,
      skills,
      gender,
      residency,
      nationality,
      transport,
      height,
      weight,
      bankAccountName,
      bankName,
      iban,
      tags,
      address,
      personalId,
      picture}) async {
    var body = {
      "contact": {
        'picture': _parse(picture, null),
        'title': _parse(title, ''),
        'first_name': _parse(firstName, ''),
        'last_name': _parse(lastName, ''),
        'birthday': _parse(birthday, ''),
        'phone_mobile': _parse(phone, ''),
        'email': _parse(email, ''),
        'gender': _parse(gender, ''),
        'address': {'street_address': _parse(address, '')},
        "bank_accounts": {
          'AccountholdersName': _parse(bankAccountName, ''),
          'IBAN': _parse(iban, ''),
          'bank_name': _parse(bankName, ''),
        }
      },
      'nationality': {
        'id': _parse(nationality, ''),
      },
      'residency': _parse(residency, ''),
      'transportation_to_work': _parse(transport, ''),
      'height': _parse(height, null),
      'weight': _parse(weight, null),
      'formatilies': {
        'personal_id': _parse(personalId, ''),
      },
      'industry': {'id': _parse(industry, '')},
      'skill': _parse(skills, []),
      "tests": [
        {
          "acceptance_test_question": "9f5c24c5-6377-45a7-95e0-6c4c31716ce5",
          "answer": "8e1b4fc4-5420-421d-a7d7-059d6c32650e"
        },
        {
          "acceptance_test_question": "eb02425e-2f13-42ec-ba72-072f1262c82b",
          "answer": "362b44e6-fa64-4e88-b1db-87fc31951356"
        },
        {
          "acceptance_test_question": "fbfd70de-0807-40a5-bf36-3dc00e72824f",
          "answer": "12beafd6-492b-4b32-abde-03aa02802d50"
        },
        {
          "acceptance_test_question": "4b33ca8f-1c8e-45be-be91-fc58371066e2",
          "answer": ""
        },
        {
          "acceptance_test_question": "994783b0-87d6-404c-a866-f6b70cb32ede",
          "answer_text": "",
          "score": ""
        },
        {
          "acceptance_test_question": "28023546-b75f-487d-8638-fa08ac320f61",
          "answer": ""
        },
        {
          "acceptance_test_question": "a41de089-4212-449d-9481-913b7be7b4ad",
          "answer": []
        },
        {
          "acceptance_test_question": "c44efcfa-4740-4a6f-88fd-3e1465b868d4",
          "answer_text": "",
          "score": ""
        },
        {
          "acceptance_test_question": "d58d4f88-d86b-497e-a107-60923621e8ca",
          "answer_text": "",
          "score": ""
        }
      ]
    };

    http.Response res = await apiService.post(
      path: 'core/forms/$formId/submit/',
      body: body,
    );

    if (res.statusCode == 201) {
      return true;
    } else {
      var error = ApiError.fromJson(json.decode(res.body));
      debugPrint('Error ::${error.messages}');
      ScaffoldMessenger.of(navigator.context).showSnackBar(
        SnackBar(
          backgroundColor: warningColor,
          content: Text(
            error.messages.join(' '),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      throw Exception(error.messages.join(' '));
    }
  }

  Future getRoles() async {
    try {
      // switchAccount();
      http.Response res = await apiService.get(path: '/core/users/roles/');

      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> roles = body['roles'];
      return roles.map((dynamic el) => Role.fromJson(el)).toList();
      // return roles
      //     .where((dynamic el) => el['__str__'].contains('client'))
      //     .map((dynamic el) => Role.fromJson(el))
      //     .toList();
    } catch (e) {
      throw Exception("Failed fetching roles");
    }
  }

  Future getCompanyContactDetails(String id) async {
    try {
      http.Response res =
          await apiService.get(path: '/core/companycontacts/$id/');

      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      return ClientContact.fromJson(body);
    } catch (e) {
      throw Exception("Failed fetching roles");
    }
  }

  Future getContactPicture(String id) async {
    Map<String, dynamic> params = {
      'fields': ['picture'],
    };

    try {
      http.Response res = await apiService.get(
        path: '/core/contacts/$id/',
        params: params,
      );

      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      var picture = body['picture'];

      return picture != null ? picture['origin'] : null;
    } catch (e) {
      throw Exception("Failed fetching roles");
    }
  }

  dynamic _parse(dynamic value, dynamic defautValue) {
    return value == null ? defautValue : value;
  }
}

// Request Example
// {
//   "contact": {
//     "title": "",
//     "first_name": "Test",
//     "last_name": "Test",
//     "birthday": "",
//     "gender": "",
//     "phone_mobile": "+372 5363 5042",
//     "email": "email@email.com",
//     "address": {
//       "street_address": {
//         "address_components": [
//           {
//             "long_name": "Berry Street",
//             "short_name": "Berry St",
//             "types": [
//               "route"
//             ]
//           },
//           {
//             "long_name": "Rosebery",
//             "short_name": "Rosebery",
//             "types": [
//               "locality",
//               "political"
//             ]
//           },
//           {
//             "long_name": "New South Wales",
//             "short_name": "NSW",
//             "types": [
//               "administrative_area_level_1",
//               "political"
//             ]
//           },
//           {
//             "long_name": "Australia",
//             "short_name": "AU",
//             "types": [
//               "country",
//               "political"
//             ]
//           },
//           {
//             "long_name": "2018",
//             "short_name": "2018",
//             "types": [
//               "postal_code"
//             ]
//           }
//         ],
//         "adr_address": "<span class=\"street-address\">Berry St</span>, <span class=\"locality\">Rosebery</span> <span class=\"region\">NSW</span> <span class=\"postal-code\">2018</span>, <span class=\"country-name\">Australia</span>",
//         "formatted_address": "Berry St, Rosebery NSW 2018, Australia",
//         "geometry": {
//           "location": {
//             "lat": -33.9247523,
//             "lng": 151.2050364
//           },
//           "viewport": {
//             "south": -33.9261012802915,
//             "west": 151.2036874197085,
//             "north": -33.9234033197085,
//             "east": 151.2063853802915
//           }
//         },
//         "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/geocode-71.png",
//         "icon_background_color": "#7B9EB0",
//         "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
//         "name": "Berry Street",
//         "place_id": "EiZCZXJyeSBTdCwgUm9zZWJlcnkgTlNXIDIwMTgsIEF1c3RyYWxpYSIuKiwKFAoSCZfCZ-OjsRJrEfCblCKXFR7NEhQKEglPzct0vLESaxEAyTIWaH0BBQ",
//         "reference": "EiZCZXJyeSBTdCwgUm9zZWJlcnkgTlNXIDIwMTgsIEF1c3RyYWxpYSIuKiwKFAoSCZfCZ-OjsRJrEfCblCKXFR7NEhQKEglPzct0vLESaxEAyTIWaH0BBQ",
//         "types": [
//           "route"
//         ],
//         "url": "https://maps.google.com/?q=Berry+St,+Rosebery+NSW+2018,+Australia&ftid=0x6b12b1a3e367c297:0xcd1e159722949bf0",
//         "utc_offset": 660,
//         "vicinity": "Rosebery",
//         "html_attributions": [],
//         "utc_offset_minutes": 660
//       }
//     },
//     "bank_accounts": {
//       "AccountholdersName": "123",
//       "bank_name": "123",
//       "IBAN": "123"
//     }
//   },
//   "nationality": {
//     "id": ""
//   },
//   "residency": "2",
//   "transportation_to_work": "",
//   "weight": null,
//   "height": null,
//   "formalities": {
//     "personal_id": ""
//   },
//   "superannuation_fund": {
//     "id": ""
//   },
//   "superannuation_membership_number": null,
//   "industry": {
//     "id": "af3dc95e-3bc4-4c6a-b02c-a72ff67a8f61"
//   },
//   "skill": [
//     {
//       "id": "515ba677-38fa-4379-9f6b-574a5e732396"
//     }
//   ],
//   "tag": [
//     {
//       "id": "2e7c710c-b630-465e-8b40-ad025f004504"
//     }
//   ],
//   "tests": [
//     {
//       "acceptance_test_question": "6e224129-07fc-45c4-a155-b8dd250c9990",
//       "answer": "8d4e47ac-402b-4eff-9763-2fc24c964e4e"
//     }
//   ]
// }
