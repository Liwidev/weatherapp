part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForConcreteCity extends WeatherEvent {
  final String countryString;
  GetWeatherForConcreteCity(this.countryString);

  @override
  List<Object> get props => [countryString];
}
