import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/features/weather/data/models/location_model.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:weatherapp/features/weather/domain/entities/current.dart';
import 'package:weatherapp/features/weather/domain/entities/location.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLocationModel = LocationModel(
    name: 'London',
    region: 'City of London, Greater London',
    country: "United Kingdom",
    lat: 51.52,
    lon: -0.11,
    tzid: 'Europe/London',
    localtimeepoch: 1606870643,
    localtime: '2020-12-02 0:57',
  );

  test(
    'should be a subclass of [Location] entity',
    () async {
      // Assert
      expect(tLocationModel, isA<Location>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when JSON is processed ',
      () async {
        //Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('location.json'));
        // Act
        final result = LocationModel.fromJson(jsonMap);
        // Assert
        expect(result, tLocationModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a valid JSON map containing the proper data ',
      () async {
        // Act
        final result = tLocationModel.toJson();
        final expectedMap = {
          "name": "London",
          "region": "City of London, Greater London",
          "country": "United Kingdom",
          "lat": 51.52,
          "lon": -0.11,
          "tz_id": "Europe/London",
          "localtime_epoch": 1606870643,
          "localtime": "2020-12-02 0:57"
        };
        // Assert
        expect(result, expectedMap);
      },
    );
  });
}
