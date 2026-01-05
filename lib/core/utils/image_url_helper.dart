import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageUrlHelper {
  static String getMoviePosterUrl(String? path, {String size = 'w500'}) {
    if (path == null) return '';
    final baseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return '$baseUrl/$size$path';
  }

  static String getMovieBackdropUrl(String? path, {String size = 'w780'}) {
    if (path == null) return '';
    final baseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return '$baseUrl/$size$path';
  }

  static String getOriginalImageUrl(String? path) {
    if (path == null) return '';
    final baseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return '$baseUrl/original$path';
  }
}
