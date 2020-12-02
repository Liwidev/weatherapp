import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Location extends Equatable {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzid;
  final int localtimeepoch;
  final String localtime;

  Location({
    @required this.name,
    @required this.region,
    @required this.country,
    @required this.lat,
    @required this.lon,
    @required this.tzid,
    @required this.localtimeepoch,
    @required this.localtime,
  });

  @override
  List<Object> get props => [
        name,
        region,
        country,
        lat,
        lon,
        tzid,
        localtimeepoch,
        localtime,
      ];
}
