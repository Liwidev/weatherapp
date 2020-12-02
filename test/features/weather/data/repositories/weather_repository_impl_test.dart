import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:weatherapp/Core/error/failures.dart';
import 'package:weatherapp/Core/network/network_info.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/features/weather/data/models/weather_model.dart';
import 'package:weatherapp/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weatherapp/features/weather/domain/entities/current.dart';
import 'package:weatherapp/features/weather/domain/entities/location.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements WeatherLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  WeatherRepositoryImpl repository;
  MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  MockWeatherLocalDataSource mockWeatherLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockWeatherLocalDataSource = MockWeatherLocalDataSource();
    mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      localDataSource: mockWeatherLocalDataSource,
      remoteDataSource: mockWeatherRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteWeather', () {
    final tCountry = "Chile";
    final tLocation = Location(
      name: 'Santiago',
      region: 'LAS',
      country: tCountry,
      lat: 123.0,
      lon: 123.0,
      tzid: 'id',
      localtimeepoch: 123,
      localtime: '1234',
    );
    final tCurrent = Current(
      tempc: 40.0,
      tempf: 80.0,
      windmph: 10.0,
      windkph: 15.0,
      pressuremb: 1000.0,
      pressurein: 1000.0,
      humidity: 20,
      uv: 1,
    );
    final tCountryWeatherModel =
        WeatherModel(location: tLocation, current: tCurrent);
    group('device is online', () {
      test(
        'should check if service is online',
        () async {
          //Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // Act
          repository.getConcreteWeather(tCountry);
          // Assert
          verify(mockNetworkInfo.isConnected);
        },
      );

      test(
        'should return remote data when the data source is successful',
        () async {
          //Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(mockWeatherRemoteDataSource.getConcreteWeather(any))
              .thenAnswer((_) async => tCountryWeatherModel);
          // Act
          final result = await repository.getConcreteWeather(tCountry);
          // Assert
          verify(mockWeatherRemoteDataSource.getConcreteWeather(tCountry));
          expect(result, equals(Right(tCountryWeatherModel)));
        },
      );

      test(
        'should cache te data when the data source is successful',
        () async {
          //Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(mockWeatherRemoteDataSource.getConcreteWeather(any))
              .thenAnswer((_) async => tCountryWeatherModel);
          // Act
          await repository.getConcreteWeather(tCountry);
          // Assert
          verify(mockWeatherRemoteDataSource.getConcreteWeather(tCountry));
          verify(mockWeatherLocalDataSource.cacheWeather(tCountryWeatherModel));
        },
      );

      test(
        'should return Server Failure data when the data source is unsuccessful',
        () async {
          //Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(mockWeatherRemoteDataSource.getConcreteWeather(any))
              .thenThrow(ServerFailure());
          // Act
          final result = await repository.getConcreteWeather(tCountry);
          // Assert
          verify(mockWeatherRemoteDataSource.getConcreteWeather(tCountry));
          verifyZeroInteractions(mockWeatherLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    group('device is offline', () {
      test(
        'should check if service is offline',
        () async {
          //Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // Act
          repository.getConcreteWeather(tCountry);
          // Assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      test(
        'should return cache data when the data source is successful',
        () async {
          //Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          when(mockWeatherLocalDataSource.getLastCachedWeather())
              .thenAnswer((_) async => tCountryWeatherModel);
          // Act
          final result = await repository.getConcreteWeather(tCountry);
          // Assert
          verify(mockWeatherLocalDataSource.getLastCachedWeather());
          expect(result, equals(Right(tCountryWeatherModel)));
        },
      );

      test(
        'should return Cache Failure data when the data source is unsuccessful',
        () async {
          //Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          when(mockWeatherLocalDataSource.getLastCachedWeather())
              .thenThrow(CacheFailure());
          // Act
          final result = await repository.getConcreteWeather(tCountry);
          // Assert
          verify(mockWeatherLocalDataSource.getLastCachedWeather());
          verifyZeroInteractions(mockWeatherRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
