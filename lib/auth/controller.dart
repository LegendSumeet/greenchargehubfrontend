import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/bookingmodel.dart';
import 'helper.dart';
import 'model.dart';

class OnBoardNotifier extends ChangeNotifier {
  late Future<List<UserModel>> bookingData; // Change this line

  userconfslots(Booking model) {
    AuthHelper.booking(model).then((response) {
      if (response) {
        Get.back();
        print(response);
        Get.snackbar("DONE", "Booking Saved Successfully");
      } else if (!response) {
        Get.snackbar("Booking is Already Exists", "Same");
      }
    }).catchError((error) {
      print(model.toJson());
      print(error);
      Get.snackbar('Failed', 'Invalid');
    });
  }

  Future<void> getbootking(String phonenumber) async {
    bookingData = AuthHelper.Getbooking(phonenumber); // Change this line
  }
}
