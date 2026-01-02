import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/genre.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  final MovieRepository repository;

  GetGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) async {
    return await repository.getGenres();
  }
}
