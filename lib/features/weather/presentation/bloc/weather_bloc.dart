import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weatherapp/Core/error/failures.dart';

import 'package:weatherapp/features/weather/domain/entities/weather.dart';
import 'package:weatherapp/features/weather/domain/usecases/get_concrete_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetConcreteWeather getConcreteWeather;
  WeatherBloc({
    @required GetConcreteWeather concrete,
  })  : assert(concrete != null),
        getConcreteWeather = concrete,
        super(Empty());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeatherForConcreteCity) {
      yield Loading();
      final failureOrWeather =
          await getConcreteWeather(Params(country: event.countryString));
      yield failureOrWeather.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (weather) => Loaded(weather: weather));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
