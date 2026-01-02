import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

class DiscoverMovies implements UseCase<List<Movie>, DiscoverMoviesParams> {
  final MovieRepository repository;

  DiscoverMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(DiscoverMoviesParams params) async {
    return await repository.discoverMovies(
      withGenres: params.withGenres,
      page: params.page,
    );
  }
}

class DiscoverMoviesParams {
  final String? withGenres;
  final int page;

  DiscoverMoviesParams({this.withGenres, this.page = 1});
}
