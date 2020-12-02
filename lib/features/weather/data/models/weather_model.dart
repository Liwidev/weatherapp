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
}
