import "dart:convert";

import "package:greenchargehub/auth/model.dart";
import "package:greenchargehub/models/bookingmodel.dart";
import "package:http/http.dart" as https;

class AuthHelper {
  static var client = https.Client();

  static Future<bool> booking(Booking model) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var url = Uri.https(
        "apicodehub.vercel.app", "/api/liveevents/insertData");

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model));

    if (response.statusCode == 201) {
      print(response.body);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }


  static Future<List<UserModel>> Getbooking(String phonenumber) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var url = Uri.https(
        "apicodehub.vercel.app", "/api/liveevents/bookingByPhoneNumber/${phonenumber}");

    var response = await client.get(url,
        headers: requestHeaders);

    if (response.statusCode == 200) {
      var surajData = userModelFromJson(response.body);
      return surajData;
    } else {
      print(response.body);
      return [];
    }
  }
}