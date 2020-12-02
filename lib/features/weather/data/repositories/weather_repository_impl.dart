import 'package:weatherapp/Core/network/network_info.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';
import 'package:weatherapp/Core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:meta/meta.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherLocalDataSource localDataSource;
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Weather>> getConcreteWeather(String country) async {
    if (await networkInfo.isConnected) {
      try {
        final weatherRemote =
            await remoteDataSource.getConcreteWeather(country);
        localDataSource.cacheWeather(weatherRemote);
        return Right(weatherRemote);
      } on ServerFailure {
        return Left(ServerFailure());
      }
    } else {
      try {
        final weatherCache = await localDataSource.getLastCachedWeather();
        return Right(weatherCache);
      } on CacheFailure {
        return Left(CacheFailure());
      }
    }
  }
}
