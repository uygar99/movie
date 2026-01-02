import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

class GetMoviesByGenre implements UseCase<List<Movie>, GetMoviesByGenreParams> {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetMoviesByGenreParams params) async {
    return await repository.getMoviesByGenre(params.genreId, page: params.page);
  }
}

class GetMoviesByGenreParams {
  final int genreId;
  final int page;

  GetMoviesByGenreParams({required this.genreId, this.page = 1});
}
