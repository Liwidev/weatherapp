import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherapp/Core/error/failures.dart';
import 'package:weatherapp/features/weather/domain/entities/current.dart';
import 'package:weatherapp/features/weather/domain/entities/location.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';
import 'package:weatherapp/features/weather/domain/usecases/get_concrete_weather.dart';
import 'package:weatherapp/features/weather/presentation/bloc/weather_bloc.dart';

class MockGetConcreteWeather extends Mock implements GetConcreteWeather {}

void main() {
  MockGetConcreteWeather mockGetConcreteWeather;
  WeatherBloc bloc;

  setUp(() {
    mockGetConcreteWeather = MockGetConcreteWeather();
    bloc = WeatherBloc(concrete: mockGetConcreteWeather);
  });

  test('initalState should be [Empty]', () async {
    expectLater(bloc.state, equals(Empty()));
  });

  group('GetWeatherForConcreteCity', () {
    final tCity = 'London';
    final tLocation = Location(
      name: 'London',
      region: 'LAS',
      country: "United Kingdom",
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
      'should get data from the concrete use case',
      () async {
        //Arrange
        when(mockGetConcreteWeather(any))
            .thenAnswer((_) async => Right(tCountryWeather));
        // Act
        bloc.add(GetWeatherForConcreteCity(tCity));
        await untilCalled(mockGetConcreteWeather(any));
        // Assert
        verify(mockGetConcreteWeather(Params(country: tCity)));
      },
    );

    test(
      'should emit [Loading, Loaded] when is gottten successfully',
      () async {
        //Arrange
        when(mockGetConcreteWeather(any))
            .thenAnswer((_) async => Right(tCountryWeather));
        // Assert Later
        final expected = [Loading(), Loaded(weather: tCountryWeather)];
        expectLater(bloc, emitsInOrder(expected));
        // Act
        bloc.add(GetWeatherForConcreteCity(tCity));
      },
    );

    test(
      'should emit [Loading, Error] when is gottten unsuccessfully',
      () async {
        //Arrange
        when(mockGetConcreteWeather(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // Assert Later
        final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expected));
        // Act
        bloc.add(GetWeatherForConcreteCity(tCity));
      },
    );

    test(
      'should emit [Loading, Error] when is gottten unsuccessfully from the cache',
      () async {
        //Arrange
        when(mockGetConcreteWeather(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // Assert Later
        final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expected));
        // Act
        bloc.add(GetWeatherForConcreteCity(tCity));
      },
    );
  });
}
