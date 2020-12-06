import 'package:weatherapp/features/weather/domain/entities/current.dart';
import 'package:meta/meta.dart';

class CurrentModel extends Current {
  CurrentModel({
    @required double tempc,
    @required double tempf,
    @required double windmph,
    @required double windkph,
    @required double pressuremb,
    @required double pressurein,
    @required int humidity,
    @required double uv,
  }) : super(
            humidity: humidity,
            pressurein: pressurein,
            pressuremb: pressuremb,
            tempc: tempc,
            tempf: tempf,
            uv: uv,
            windkph: windkph,
            windmph: windmph);

  factory CurrentModel.fromJson(Map<String, dynamic> json) {
    return CurrentModel(
      tempc: json['temp_c'],
      tempf: json['temp_f'],
      windmph: json['wind_mph'],
      windkph: json['wind_kph'],
      pressuremb: json['pressure_mb'],
      pressurein: json['pressure_in'],
      humidity: json['humidity'],
      uv: json['uv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_c': tempc,
      'temp_f': tempf,
      'wind_mph': windmph,
      'wind_kph': windkph,
      'pressure_mb': pressuremb,
      'pressure_in': pressurein,
      'humidity': humidity,
      'uv': uv
    };
  }
}
