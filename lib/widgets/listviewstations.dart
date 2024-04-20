import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer_pro/sizer.dart';

import '../consts.dart';
import '../detail_page.dart';
import '../models/gas_station.dart';
import 'nearest_location_item.dart';

class ListViewOFsTATIONS extends StatelessWidget {
  const ListViewOFsTATIONS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Nearby Stations"),
      ),
      body: FutureBuilder<List<GasStation>>(
        future: fetchGasStations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<GasStation> gasStations = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: gasStations.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            final distance = const Distance().as(
                              LengthUnit.Meter,
                              currentLocation,
                              gasStations[index].location,
                            ) / 40;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  gasStation: gasStations[index],
                                  distance: distance.toString(),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: NearestLocationItem(
                              gasStation: gasStations[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
