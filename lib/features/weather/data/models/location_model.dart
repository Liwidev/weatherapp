import 'package:weatherapp/features/weather/domain/entities/location.dart';
import 'package:meta/meta.dart';

class LocationModel extends Location {
  LocationModel({
    @required String name,
    @required String region,
    @required String country,
    @required double lat,
    @required double lon,
    @required String tzid,
    @required int localtimeepoch,
    @required String localtime,
  }) : super(
            country: country,
            lat: lat,
            localtime: localtime,
            localtimeepoch: localtimeepoch,
            lon: lon,
            name: name,
            region: region,
            tzid: tzid);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
      tzid: json['tz_id'],
      localtimeepoch: json['localtime_epoch'],
      localtime: json['localtime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'tz_id': tzid,
      'localtime_epoch': localtimeepoch,
      'localtime': localtime,
    };
  }
}
