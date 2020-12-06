import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/features/weather/data/models/current_model.dart';
import 'package:weatherapp/features/weather/data/models/location_model.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:weatherapp/features/weather/domain/entities/current.dart';
import 'package:weatherapp/features/weather/domain/entities/location.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLocation = LocationModel(
    name: 'London',
    region: 'City of London, Greater London',
    country: 'United Kingdom',
    lat: 51.52,
    lon: -0.11,
    tzid: 'Europe/London',
    localtimeepoch: 1606870643,
    localtime: '2020-12-02 0:57',
  );
  final tCurrent = CurrentModel(
    tempc: 6.0,
    tempf: 42.8,
    windmph: 5.6,
    windkph: 9.0,
    pressuremb: 1025.0,
    pressurein: 30.8,
    humidity: 75,
    uv: 1.0,
  );
  final tCountryWeatherModel =
      WeatherModel(location: tLocation, current: tCurrent);

  test(
    'should be a subclass of [Weather] entity',
    () async {
      // Assert
      expect(tCountryWeatherModel, isA<Weather>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when ',
      () async {
        //Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('weather.json'));
        // Act
        final result = WeatherModel.fromJson(jsonMap);
        // Assert
        print(result);
        print(tCountryWeatherModel);
        expect(result, tCountryWeatherModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a valid JSON map containing the proper data ',
      () async {
        // Act
        final result = tCountryWeatherModel.toJson();
        final expectedMap = {
          "location": {
            "name": "London",
            "region": "City of London, Greater London",
            "country": "United Kingdom",
            "lat": 51.52,
            "lon": -0.11,
            "tz_id": "Europe/London",
            "localtime_epoch": 1606870643,
            "localtime": "2020-12-02 0:57"
          },
          "current": {
            "temp_c": 6.0,
            "temp_f": 42.8,
            "wind_mph": 5.6,
            "wind_kph": 9.0,
            "pressure_mb": 1025.0,
            "pressure_in": 30.8,
            "humidity": 75,
            "uv": 1.0,
          }
        };
        // Assert
        expect(result, expectedMap);
      },
    );
  });
}
