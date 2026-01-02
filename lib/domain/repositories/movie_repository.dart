import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../entities/genre.dart';
import '../../core/error/failures.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies({int page = 1});
  Future<Either<Failure, Movie>> getMovieDetails(int movieId);
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId, {int page = 1});
  Future<Either<Failure, List<Movie>>> discoverMovies({String? withGenres, int page = 1});
}
