import '../models/movie_model.dart';
import '../models/genre_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<MovieModel> getMovieDetails(int movieId);
  Future<List<GenreModel>> getGenres();
}

