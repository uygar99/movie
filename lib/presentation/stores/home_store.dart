import 'package:mobx/mobx.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/get_movies_by_genre.dart';
import '../../domain/usecases/discover_movies.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/usecase.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final GetMoviesByGenre getMoviesByGenre;
  final DiscoverMovies discoverMovies;
  final GetGenres getGenres;

  _HomeStore(this.getMoviesByGenre, this.discoverMovies, this.getGenres);

  @observable
  ObservableList<Movie> recommendedMovies = ObservableList<Movie>();

  @observable
  ObservableMap<int, List<Movie>> moviesByGenre = ObservableMap<int, List<Movie>>();

  @observable
  ObservableList<Genre> genres = ObservableList<Genre>();

  @observable
  bool isLoadingRecommended = false;

  @observable
  bool isLoadingGenres = false;

  @observable
  int selectedGenreId = 0;

  @observable
  bool isAutoScrolling = false;

  @observable
  String searchQuery = '';

  @action
  void setAutoScrolling(bool value) {
    isAutoScrolling = value;
  }

  @action
  Future<void> init(List<int> selectedGenreIds, List<int> selectedMovieIds) async {
    await fetchGenres();
    await fetchRecommended(selectedGenreIds, selectedMovieIds);
    
    for (var i = 0; i < genres.length; i++) {
        fetchMoviesForGenre(genres[i].id);
    }
  }

  @action
  Future<void> fetchGenres() async {
    isLoadingGenres = true;
    final result = await getGenres(NoParams());
    result.fold(
      (_) => null,
      (genreList) {
        genres.clear();
        genres.addAll(genreList);
        if (genres.isNotEmpty) {
          selectedGenreId = genres.first.id;
        }
      },
    );
    isLoadingGenres = false;
  }

  @action
  Future<void> fetchRecommended(List<int> genreIds, List<int> movieIds) async {
    isLoadingRecommended = true;
    final result = await discoverMovies(DiscoverMoviesParams(
      withGenres: genreIds.join(','),
    ));
    result.fold(
      (_) => null,
      (movieList) => recommendedMovies.addAll(movieList.take(6)),
    );
    isLoadingRecommended = false;
  }

  @action
  Future<void> fetchMoviesForGenre(int genreId) async {
    if (moviesByGenre.containsKey(genreId)) return;
    
    final result = await getMoviesByGenre(GetMoviesByGenreParams(genreId: genreId));
    result.fold(
      (_) => null,
      (movieList) {
        moviesByGenre[genreId] = movieList.take(9).toList();
      },
    );
  }

  @action
  void setSelectedGenre(int id) {
    selectedGenreId = id;
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }
}
