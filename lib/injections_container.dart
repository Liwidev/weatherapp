import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/Core/network/network_info.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:weatherapp/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weatherapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:weatherapp/features/weather/domain/usecases/get_concrete_weather.dart';
import 'package:weatherapp/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //* INTERNAL DEPENDENCIES
  // INIT - BLOC
  sl.registerFactory(
    () => WeatherBloc(
      concrete: sl(),
    ),
  );

  // INIT - GetConcreteWeather - use Case
  sl.registerLazySingleton(
    () => GetConcreteWeather(sl()),
  );

  // INIT - Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // INIT - local data source
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // INIT - remote data source
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // INIT - network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl(),
    ),
  );

  //* EXTERNAL DEPENDENCIES
  //LOCAL STORAGE
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //HTTP CLIENT
  sl.registerLazySingleton(() => http.Client());

  // DATA Connection CHECKER
  sl.registerLazySingleton(() => DataConnectionChecker());
}
