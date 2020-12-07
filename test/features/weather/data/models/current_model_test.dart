import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/features/weather/data/models/current_model.dart';
import 'package:weatherapp/features/weather/domain/entities/current.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCurrentModel = CurrentModel(
    tempc: 6.0,
    tempf: 42.8,
    windmph: 5.6,
    windkph: 9.0,
    pressuremb: 1025.0,
    pressurein: 30.8,
    humidity: 75,
    uv: 1.0,
  );

  test(
    'should be a subclass of [Current] entity',
    () async {
      // Assert
      expect(tCurrentModel, isA<Current>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when JSON is processed ',
      () async {
        //Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('current.json'));
        // Act
        final result = CurrentModel.fromJson(jsonMap);
        // Assert
        expect(result, tCurrentModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a valid JSON map containing the proper data ',
      () async {
        // Act
        final result = tCurrentModel.toJson();
        final expectedMap = {
          "temp_c": 6.0,
          "temp_f": 42.8,
          "wind_mph": 5.6,
          "wind_kph": 9.0,
          "pressure_mb": 1025.0,
          "pressure_in": 30.8,
          "humidity": 75,
          "uv": 1.0,
        };
        // Assert
        expect(result, expectedMap);
      },
    );
  });
}
