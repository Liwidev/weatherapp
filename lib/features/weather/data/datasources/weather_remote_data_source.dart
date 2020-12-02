import 'package:weatherapp/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getConcreteWeather(String country);
}
