import 'package:equatable/equatable.dart';
import 'package:weatherapp/Core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:weatherapp/Core/usecases/usecase.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:meta/meta.dart';

class GetConcreteWeather implements UseCase<Weather, Params> {
  final WeatherRepository repository;

  GetConcreteWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(Params params) async {
    return await repository.getConcreteWeather(params.country);
  }
}

class Params extends Equatable {
  final String country;

  Params({@required this.country});

  @override
  List<Object> get props => [country];
}
