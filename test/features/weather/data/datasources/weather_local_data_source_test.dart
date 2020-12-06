import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/Core/error/exceptions.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/features/weather/data/models/current_model.dart';
import 'package:weatherapp/features/weather/data/models/location_model.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:matcher/matcher.dart' as matcher;

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  WeatherLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = WeatherLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastCachedWeather', () {
    final tWeatherModel =
        WeatherModel.fromJson(json.decode(fixture('weather_cache.json')));

    test(
      'should return [WeatherModel] from SharedPreferences',
      () async {
        //Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(
          fixture('weather_cache.json'),
        );
        // Act
        final result = await dataSource.getLastCachedWeather();
        // Assert
        verify(mockSharedPreferences.getString(LAST_WEATHER_CACHED));
        expect(result, equals(tWeatherModel));
      },
    );

    test(
      'should return CacheException when there is no CACHE',
      () async {
        //Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // Act
        final call = dataSource.getLastCachedWeather;
        // Assert
        expect(() => call(), throwsA(matcher.TypeMatcher<CacheException>()));
        verify(mockSharedPreferences.getString(LAST_WEATHER_CACHED));
      },
    );
  });

  group('cacheWeather', () {
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
      'should call sharedPreferences to cache the data',
      () async {
        //Arrange
        when(mockSharedPreferences.setString(LAST_WEATHER_CACHED, any))
            .thenAnswer((_) async => Future.value(true));
        // Act
        dataSource.cacheWeather(tCountryWeatherModel);
        // Assert
        final expecJsonString = json.encode(tCountryWeatherModel.toJson());
        verify(mockSharedPreferences.setString(
            LAST_WEATHER_CACHED, expecJsonString));
      },
    );

    test(
      'should return [CacheException] when there is a problem caching data',
      () async {
        //Arrange
        when(mockSharedPreferences.setString(LAST_WEATHER_CACHED, any))
            .thenAnswer((_) async => Future.value(false));
        // Act
        final call = dataSource.cacheWeather;
        // Assert
        final expecJsonString = json.encode(tCountryWeatherModel.toJson());
        expect(() => call(tCountryWeatherModel),
            throwsA(matcher.TypeMatcher<CacheException>()));
        verify(mockSharedPreferences.setString(
            LAST_WEATHER_CACHED, expecJsonString));
      },
    );
  });
}
