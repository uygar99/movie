import 'package:mobx/mobx.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/usecase.dart';

part 'onboarding_store.g.dart';

class OnboardingStore = _OnboardingStore with _$OnboardingStore;

abstract class _OnboardingStore with Store {
  final GetPopularMovies getPopularMovies;
  final GetGenres getGenres;

  _OnboardingStore(this.getPopularMovies, this.getGenres);

  // Movies
  @observable
  ObservableList<Movie> movies = ObservableList<Movie>();

  @observable
  ObservableSet<int> selectedMovieIds = ObservableSet<int>();

  @observable
  bool isLoadingMovies = false;

  @observable
  String? moviesError;

  @observable
  int currentMoviePage = 1;

  // Wheel scroll position
  @observable
  double wheelScrollPosition = 0.0;

  // Genres
  @observable
  ObservableList<Genre> genres = ObservableList<Genre>();

  @observable
  ObservableSet<int> selectedGenreIds = ObservableSet<int>();

  @observable
  bool isLoadingGenres = false;

  @observable
  String? genresError;

  // Computed
  @computed
  bool get canContinueFromMovies => selectedMovieIds.length >= 3;

  @computed
  bool get canContinueFromGenres => selectedGenreIds.length >= 2;

  @computed
  List<Movie> get selectedMovies =>
      movies.where((m) => selectedMovieIds.contains(m.id)).toList();

  @computed
  List<Genre> get selectedGenres =>
      genres.where((g) => selectedGenreIds.contains(g.id)).toList();

  // Actions
  @action
  Future<void> loadMovies({bool loadMore = false}) async {
    if (isLoadingMovies) return;

    isLoadingMovies = true;
    moviesError = null;

    if (!loadMore) {
      currentMoviePage = 1;
      movies.clear();
    }

    final result = await getPopularMovies(MovieParams(page: currentMoviePage));

    result.fold(
      (failure) {
        moviesError = failure.message;
        isLoadingMovies = false;
      },
      (movieList) {
        movies.addAll(movieList);
        currentMoviePage++;
        isLoadingMovies = false;
      },
    );
  }

  @action
  Future<void> loadGenres() async {
    if (isLoadingGenres) return;

    isLoadingGenres = true;
    genresError = null;

    final result = await getGenres(NoParams());

    result.fold(
      (failure) {
        genresError = failure.message;
        isLoadingGenres = false;
      },
      (genreList) {
        genres.clear();
        genres.addAll(genreList);
        isLoadingGenres = false;
      },
    );
  }

  @action
  void toggleMovieSelection(int movieId) {
    if (selectedMovieIds.contains(movieId)) {
      selectedMovieIds.remove(movieId);
    } else {
      selectedMovieIds.add(movieId);
    }
  }

  @action
  void toggleGenreSelection(int genreId) {
    if (selectedGenreIds.contains(genreId)) {
      selectedGenreIds.remove(genreId);
    } else {
      selectedGenreIds.add(genreId);
    }
  }

  @action
  void clearSelections() {
    selectedMovieIds.clear();
    selectedGenreIds.clear();
  }

  @action
  void updateWheelPosition(double position) {
    wheelScrollPosition = position;
  }
}

