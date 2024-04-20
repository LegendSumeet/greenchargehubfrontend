import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenchargehub/auth/mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:sizer_pro/sizer.dart';

import 'consts.dart';
import 'widgets/MapView.dart';
import 'widgets/battery.dart';
import 'widgets/bookingView.dart';
import 'widgets/closest_charging_banner.dart';
import 'widgets/listviewstations.dart';
import 'widgets/nearest_location_item.dart';
import 'widgets/total_distance.dart';
import 'widgets/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  String? email;
  String? username;
  String? photo;
  String? phonenumber;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('user_email');
      username = prefs.getString('user_name');
      photo = prefs.getString('user_photo_url');
      phonenumber = prefs.getString('user_number');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade700,
        title: const Text("Green Charge Hub"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        photo ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'Hello $username',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Email: $email',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Phone: $phonenumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),

                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.safety_check),
              title: const Text('Find Stations List'),
              onTap: () {
                Get.to(() => ListViewOFsTATIONS());
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Booking History'),
              onTap: () {
                Get.to(() => BookingView(phonenumber: phonenumber.toString(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Find in Map'),
              onTap: () {
                Get.to(() => MapView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.outbound_outlined),
              title: const Text('Log Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Get.to(()=>AuthPage());
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green.shade100,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 30.h,
                width: 100.w,
                color: Colors.black,
                padding: EdgeInsets.fromLTRB(5.w, 10.w, 5.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'BMW i8',
                      style: TextStyle(fontSize: 6.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -7.h,
                right: 0,
                child: Image.asset(
                  'assets/bmw_i8.png',
                  width: 80.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50.w,
                  child: const BatteryScreen(),
                ),
                SizedBox(
                  width: 37.w,
                  child: Column(
                    children: const [
                      TotalDistance(),
                      SizedBox(height: 3),
                      Weather(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: ClosestChargingBanner(),
          ),
        ],
      ),
    );
  }
}
