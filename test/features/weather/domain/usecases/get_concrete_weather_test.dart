import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherapp/features/weather/domain/entities/current.dart';
import 'package:weatherapp/features/weather/domain/entities/location.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:weatherapp/features/weather/domain/usecases/get_concrete_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  GetConcreteWeather usecase;
  MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetConcreteWeather(mockWeatherRepository);
  });

  final tCountry = 'Chile';
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
  final tCountryWeather = Weather(location: tLocation, current: tCurrent);

  test(
    'should get weather for a contry from the repository',
    () async {
      //Arrange
      when(mockWeatherRepository.getConcreteWeather(any))
          .thenAnswer((_) async => Right(tCountryWeather));
      // Act
      final result = await usecase(Params(country: tCountry));
      // Assert
      expect(result, Right(tCountryWeather));
      verify(mockWeatherRepository.getConcreteWeather(tCountry));
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );
}
