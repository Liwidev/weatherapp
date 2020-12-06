import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/Core/error/exceptions.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/features/weather/data/models/current_model.dart';
import 'package:weatherapp/features/weather/data/models/location_model.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:matcher/matcher.dart' as matcher;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  WeatherRemoteDataSource dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteWeather', () {
    final tCountry = "London";
    final tLocation = LocationModel(
      name: tCountry,
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
      '''should perform a GET Request on a URL with a Country Name (q) 
      as query param and Apikey (key) & with application/json header''',
      () async {
        //Arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(
                  fixture('weather.json'),
                  200,
                ));
        // Act
        dataSource.getConcreteWeather(tCountry);
        // Assert
        verify(mockHttpClient.get(
            'http://api.weatherapi.com/v1/current.json?key=$APIKEY&q=$tCountry',
            headers: {
              'Content-Type': 'application/json',
            }));
      },
    );

    test(
      '''should return [WeatherModel] when the response is 200 (successfyul)''',
      () async {
        //Arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(
                  fixture('weather.json'),
                  200,
                ));
        // Act
        final result = await dataSource.getConcreteWeather(tCountry);
        // Assert
        expect(result, equals(tCountryWeatherModel));
      },
    );

    test(
      '''should return [WeatherModel] when the response is 404 (not found)''',
      () async {
        //Arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(
                  'Something Happened',
                  404,
                ));
        // Act
        final call = dataSource.getConcreteWeather;

        // Assert
        expect(call(tCountry), throwsA(matcher.TypeMatcher<ServerException>()));
      },
    );
  });
}
