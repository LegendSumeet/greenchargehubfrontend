import 'package:greenchargehub/consts.dart';
import 'package:greenchargehub/detail_page.dart';
import 'package:greenchargehub/models/gas_station.dart';
import 'package:greenchargehub/widgets/custom_marker.dart';
import 'package:greenchargehub/widgets/nearest_location_item.dart';
import 'package:greenchargehub/widgets/zoom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView>
    with TickerProviderStateMixin {
  late final MapController mapController;
  late Position _currentPosition;
  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    currentLocation = LatLng(19.230353621625376, 73.07875114572468);
    mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        currentLocation = LatLng(
          _currentPosition.latitude,
          _currentPosition.longitude,
        );
      });
    } catch (e) {
      print(e);
    }
  }



  @override
  void dispose() {
    super.dispose();
    mapController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                onMapReady: () {
                  // setBound();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(markers: [
                  Marker(
                      width: 120,
                      height: 28.sp,
                      point: currentLocation,
                      alignment: Alignment.topCenter,
                      child: RippleWave(
                        color: blue,
                        child: CustomMarker(
                            color: white,
                            widget1: Positioned(
                                right: 0,
                                child: Image.asset(
                                  'assets/bmw_i8.png',
                                  width: 28.sp,
                                  height: 28.sp,
                                )),
                            widget2: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(
                                Icons.radar_rounded,
                                color: blue,
                                size: 7.f,
                              ),
                            )
                        ),
                      )),
                  // ...List.generate(gasStations.length, (index) {
                  //   final distance = const Distance().as(LengthUnit.Meter,
                  //       currentLocation, gasStations[index].location);
                  //   return Marker(
                  //       rotate: true,
                  //       width: 25.sp,
                  //       height: 28.sp,
                  //       alignment: Alignment.topCenter,
                  //       point: gasStations[index].location,
                  //       child: RippleWave(
                  //         repeat: true,
                  //         duration: Durations.extralong2,
                  //         color: Colors.green,
                  //         child: CustomMarker(
                  //
                  //           widget1: ClipOval(
                  //             child: Image.network(
                  //               gasStations[index].image,
                  //               width: 23.sp,
                  //               height: 23.sp,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //           widget2: Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 5, vertical: 2),
                  //             child: Text(
                  //               '${(distance / 1000).toStringAsFixed(1)} km',
                  //               style: roboto.copyWith(
                  //                   fontSize: 5.f, fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //           color: Colors.blue,
                  //         ),
                  //       ));
                  // })
                ]),
                ZoomButton(
                    alignment: const Alignment(1, -.75),
                    maxZoom: 19,
                    minZoom: 5,
                    padding: 5.w)
              ]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5.w,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.5.w),
                  child: Card(
                    color: CupertinoColors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.w)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.place_rounded,
                            size: 6.f,
                            color: white,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            currentAddress,
                            style:
                            roboto.copyWith(color: white, fontSize: 5.5.f),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // setBound() async {
  //   final bounds = LatLngBounds.fromPoints([
  //     currentLocation,
  //     ...List.generate(
  //         gasStations.length, (index) => gasStations[index].location)
  //   ]);
  //   mapController.fitCamera(CameraFit.bounds(
  //       bounds: bounds,
  //       padding:
  //       EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.w, top: 10.w)));
  // }

  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween(
        begin: mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween(
        begin: mapController.camera.center.longitude,
        end: destLocation.longitude);
    final zoomTween = Tween(begin: mapController.camera.zoom, end: destZoom);
    final controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    final Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;
    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }
      hasTriggeredMove |= mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation),
          id: id);
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }
}
