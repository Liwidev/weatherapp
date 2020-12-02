import 'package:dartz/dartz.dart';
import 'package:weatherapp/Core/error/failures.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getConcreteWeather(String country);
}
