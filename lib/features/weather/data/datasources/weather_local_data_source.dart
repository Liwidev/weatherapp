import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/Core/error/exceptions.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:meta/meta.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weather);
  Future<WeatherModel> getLastCachedWeather();
}

const LAST_WEATHER_CACHED = 'LAST_WEATHER_CACHED';

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    final cacheResult = await sharedPreferences.setString(
        LAST_WEATHER_CACHED, json.encode(weather.toJson()));
    if (cacheResult == false) {
      throw CacheException();
    }
  }

  @override
  Future<WeatherModel> getLastCachedWeather() {
    final jsonString = sharedPreferences.getString(LAST_WEATHER_CACHED);
    if (jsonString != null) {
      return Future.value(WeatherModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
