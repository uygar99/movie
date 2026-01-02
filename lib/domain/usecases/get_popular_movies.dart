import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

class GetPopularMovies implements UseCase<List<Movie>, MovieParams> {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class MovieParams {
  final int page;

  MovieParams({this.page = 1});
}
