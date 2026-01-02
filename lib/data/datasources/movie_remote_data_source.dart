import '../models/movie_model.dart';
import '../models/genre_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<MovieModel> getMovieDetails(int movieId);
  Future<List<GenreModel>> getGenres();
  Future<List<MovieModel>> getMoviesByGenre(int genreId, {int page = 1});
  Future<List<MovieModel>> discoverMovies({String? withGenres, int page = 1});
}

