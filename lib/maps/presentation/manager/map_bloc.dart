import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:orientation/maps/data/repositories/map_repo.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepo repo = MapRepo();
  late LatLng currentLocation;
  late final markersIcon;
  late final style;

  MapBloc() : super(MapInitial()) {
    Future<void> onLoadMap(event, emit) async {
      emit(MapLoading());

      markersIcon = await repo.getMarkerCustomIcon();
      style = await repo.getMapStyle();
      var result = await repo.getInitialLocation();
      result.fold((_) {}, (initialLocation) {
        currentLocation =
            LatLng(initialLocation.latitude!, initialLocation.longitude!);
      });

      Stream<LocationData> liveLocation = await repo.getLocationStream();
      emit(MapLoaded(location: currentLocation));
      liveLocation.listen((newLocation) {
        add(UpdateLocationEvent(
            LatLng(newLocation.latitude!, newLocation.longitude!)));
      });

      // result.fold((_) {}, (stream) {
      //   stream.listen((location) {
      //     currentLocation =
      //         LatLng(currentLocation.latitude, currentLocation.longitude);
      //     emit(MapLoaded(style: style, markersIcon: markersIcon));
      //   });
      // });
    }

    onUpdateLocationEvent(event, emit) {
      emit(MapLoaded(location: event.location));
    }

    on<LoadMapEvent>(onLoadMap);
    on<UpdateLocationEvent>(onUpdateLocationEvent);
  }
}
