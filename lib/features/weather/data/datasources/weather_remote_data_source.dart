import 'dart:convert';

import 'package:weatherapp/Core/error/exceptions.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

const APIKEY = "INSERT YOUR APIKEY HERE";

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getConcreteWeather(String country);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({@required this.client});
  @override
  Future<WeatherModel> getConcreteWeather(String country) async {
    final http.Response response = await client.get(
        'http://api.weatherapi.com/v1/current.json?key=$APIKEY&q=$country',
        headers: {
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
