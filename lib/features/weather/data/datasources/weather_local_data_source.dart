import 'package:weatherapp/features/weather/data/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weather);
  Future<WeatherModel> getLastCachedWeather();
}
