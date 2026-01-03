import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/movie_remote_data_source_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/get_movies_by_genre.dart';
import '../../domain/usecases/discover_movies.dart';
import '../../presentation/stores/movie_store.dart';
import '../../presentation/stores/onboarding_store.dart';
import '../../presentation/stores/home_store.dart';
import '../../presentation/stores/paywall_store.dart';

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
  getIt.registerLazySingleton(() => GetMoviesByGenre(getIt()));
  getIt.registerLazySingleton(() => DiscoverMovies(getIt()));

  // Stores
  getIt.registerFactory(() => MovieStore(getIt()));
  getIt.registerLazySingleton(() => OnboardingStore(getIt(), getIt()));
  getIt.registerFactory(() => HomeStore(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => PaywallStore());
}

