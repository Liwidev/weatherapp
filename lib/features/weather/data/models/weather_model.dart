import 'package:weatherapp/features/weather/data/models/current_model.dart';
import 'package:weatherapp/features/weather/data/models/location_model.dart';
import 'package:weatherapp/features/weather/domain/entities/current.dart';
import 'package:weatherapp/features/weather/domain/entities/location.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';
import 'package:meta/meta.dart';

class WeatherModel extends Weather {
  WeatherModel({@required Location location, @required Current current})
      : super(
          current: current,
          location: location,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> loc = json['location'];
    Map<String, dynamic> curr = json['current'];
    return WeatherModel(
      location: LocationModel.fromJson(loc),
      current: CurrentModel.fromJson(curr),
    );
  }

  Map<String, dynamic> toJson() {
    var lm = LocationModel(
      name: location.name,
      region: location.region,
      country: location.country,
      lat: location.lat,
      lon: location.lon,
      tzid: location.tzid,
      localtimeepoch: location.localtimeepoch,
      localtime: location.localtime,
    );
    var cm = CurrentModel(
      humidity: current.humidity,
      pressurein: current.pressurein,
      pressuremb: current.pressuremb,
      tempc: current.tempc,
      tempf: current.tempf,
      uv: current.uv,
      windkph: current.windkph,
      windmph: current.windmph,
    );
    return {
      "location": lm.toJson(),
      "current": cm.toJson(),
    };
  }
}
