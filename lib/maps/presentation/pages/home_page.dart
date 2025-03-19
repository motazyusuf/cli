import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orientation/maps/presentation/manager/map_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x96b8b5b5),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            print("Loading");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MapLoaded) {
            debugPrint(
                "Location => ${state.location}");
            return GoogleMap(
              style: BlocProvider.of<MapBloc>(context).style,
              markers: {
                Marker(
                  markerId: const MarkerId('marker1'),
                  position: const LatLng(30.028845, 31.407584),
                  icon: BlocProvider.of<MapBloc>(context).markersIcon, // Now it's a valid BitmapDescriptor
                ),
                Marker(
                    markerId: const MarkerId("MyLocation"),
                    position: state.location),
                Marker(
                  markerId: const MarkerId('marker2'),
                  position: const LatLng(30.031334, 31.408421),
                  icon: BlocProvider.of<MapBloc>(context).markersIcon, // Now it's a valid BitmapDescriptor
                )
              },
              initialCameraPosition: CameraPosition(
                  zoom: 16, target: state.location),
            );
          } else {
            return const Text("Something is wrong");
          }
        },
      ),
    );
  }
}
