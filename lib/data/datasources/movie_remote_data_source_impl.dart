import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie_model.dart';
import '../models/genre_model.dart';
import 'movie_remote_data_source.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl(this.dio);

  String get _baseUrl => dotenv.env['TMDB_BASE_URL'] ?? '';
  String get _apiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '$_baseUrl/movie/popular',
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'accept': 'application/json',
          },
        ),
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular movies: $e');
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        '$_baseUrl/movie/now_playing',
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'accept': 'application/json',
          },
        ),
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch now playing movies: $e');
    }
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get(
        '$_baseUrl/movie/$movieId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'accept': 'application/json',
          },
        ),
      );

      return MovieModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    try {
      final response = await dio.get(
        '$_baseUrl/genre/movie/list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'accept': 'application/json',
          },
        ),
      );

      final genres = response.data['genres'] as List;
      return genres.map((json) => GenreModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch genres: $e');
    }
  }
}

