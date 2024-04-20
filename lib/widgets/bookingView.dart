

import 'package:flutter/material.dart';
import 'package:greenchargehub/auth/controller.dart';
import 'package:greenchargehub/models/bookingmodel.dart';
import 'package:provider/provider.dart';

class BookingView extends StatefulWidget {
  String phonenumber;
   BookingView({super.key,required this.phonenumber});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Booking History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),

      ),
      body: Consumer<OnBoardNotifier>(
        builder: (context, mentorNotifier, child) {
          mentorNotifier.getbootking(widget.phonenumber);
          return FutureBuilder<List<UserModel>>(
            future: mentorNotifier.bookingData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("Loading......"));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data!.isEmpty) {
                return Center(child: Text("No Slots Confirmed"));
              } else {
                List<UserModel> bookingData = snapshot.data!;
                return ListView.builder(
                  itemCount: bookingData.length,
                  itemBuilder: (context, index) {
                    UserModel userModel = bookingData[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChargingStationCard(userModel),
                    );
                  },
                );
              }
            },
          );
        },
      ),

    );
  }

  }

class ChargingStationCard extends StatelessWidget {
  final UserModel chargingStation;

  ChargingStationCard(this.chargingStation);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Station Name: ${chargingStation.stationName}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Address: ${chargingStation.address}'),
            SizedBox(height: 5),
            Text('Price: ₹${chargingStation.price}'),
            SizedBox(height: 5),
            Text('Date: ${chargingStation.date}'),
            SizedBox(height: 5),
            Text('Time: ${chargingStation.time}'),
          ],
        ),
      ),
    );
  }
}