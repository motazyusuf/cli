import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:dartz/dartz.dart';

class MapRepo {
  Location location = Location();

  Future<BitmapDescriptor> getMarkerCustomIcon() async {
    BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(64, 64)),
      'assets/markers/pin.png',
    );
    return customIcon;
  }

  Future<String> getMapStyle() async {
    return await rootBundle.loadString('assets/markers/map_style.json');
  }

  Future<Stream<LocationData>> getLocationStream() async {
    return location.onLocationChanged;
  }

  Future<Either<String, LocationData>> getInitialLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return const Left("Error Getting Location");
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return const Left("Error Getting Location");
      }
    }

    print("Getting location");
    locationData = await location.getLocation();
    print("Got location");
    return Right(locationData);
  }

// Future<List<LatLng>> getRoutePoints() async {
//   List<LatLng> routePoints = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//   print("I am before");
//   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     googleApiKey: 'AIzaSyCj0Lyma41ICXuj1BXOFlSXlf_vBeFT-y4',
//     request: PolylineRequest(
//       origin: const PointLatLng(30.028845, 31.407584),
//       destination: const PointLatLng(30.031334, 31.408421),
//       mode: TravelMode.transit,
//     ),
//   );
//   print("I am after");
//
//
//   result.points.forEach((point) {
//     print(">>>>>>>>>>>>>>>>>${point.longitude}");
//     routePoints.add(LatLng(point.latitude, point.longitude));
//   });
//   return routePoints;
// }
}
