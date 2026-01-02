import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/movie_remote_data_source_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_genres.dart';
import '../../presentation/stores/movie_store.dart';
import '../../presentation/stores/onboarding_store.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Data sources
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetPopularMovies(getIt()));
  getIt.registerLazySingleton(() => GetGenres(getIt()));

  // Stores
  getIt.registerFactory(() => MovieStore(getIt()));
  getIt.registerFactory(() => OnboardingStore(getIt(), getIt()));
}

