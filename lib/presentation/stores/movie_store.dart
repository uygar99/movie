import 'package:mobx/mobx.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';

part 'movie_store.g.dart';

class MovieStore = _MovieStore with _$MovieStore;

abstract class _MovieStore with Store {
  final GetPopularMovies getPopularMovies;

  _MovieStore(this.getPopularMovies);

  @observable
  ObservableList<Movie> movies = ObservableList<Movie>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  int currentPage = 1;

  @action
  Future<void> loadPopularMovies({bool loadMore = false}) async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;

    if (!loadMore) {
      currentPage = 1;
      movies.clear();
    }

    final result = await getPopularMovies(MovieParams(page: currentPage));

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (movieList) {
        movies.addAll(movieList);
        currentPage++;
        isLoading = false;
      },
    );
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
