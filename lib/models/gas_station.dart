import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GasStation {
  final LatLng location;
  final String id,
      name,
      image,
      address,
      ownerName,
      ownerPhone,
      ownerEmail,
      ownerPassword;
  final int price;
  final String plugs;
  final bool isApproved;
  final DateTime createdAt, updatedAt;

  GasStation({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.location,
    required this.ownerName,
    required this.image,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.ownerPassword,
    required this.isApproved,
    required this.plugs,
    required this.createdAt,
    required this.updatedAt,
  });
}

Future<List<GasStation>> fetchGasStations() async {
  var url = Uri.http("16.171.199.244:5001", "/createstation/station");
  var response = await http.get(url);
  print(response.body);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    List<GasStation> gasStations = data.map((station) {
      return GasStation(
        id: station['_id'] ?? '',
        name: station['name'] ?? '',
        address: station['address'] ?? '',
        image: station['image'] ?? '',
        price: station['price'] ?? 0,
        location: LatLng(station['latitude'] ?? 0.0, station['longitude'] ?? 0.0),
        ownerName: station['ownerName'] ?? '',
        ownerPhone: station['ownerPhone'] ?? '',
        ownerEmail: station['ownerEmail'] ?? '',
        ownerPassword: station['ownerPassword'] ?? '',
        isApproved: station['isapproved'] ?? false,
        plugs: station['plugs'] ?? '',
        createdAt: station['createdAt'] != null ? DateTime.parse(station['createdAt']) : DateTime.now(),
        updatedAt: station['updatedAt'] != null ? DateTime.parse(station['updatedAt']) : DateTime.now(),
      );
    }).toList();
    return gasStations;
  } else {
    throw Exception('Failed to fetch gas stations');
  }
}