part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}
class LoadMapEvent extends MapEvent{}
class UpdateLocationEvent extends MapEvent{
  final LatLng location;
  UpdateLocationEvent(this.location);
}
