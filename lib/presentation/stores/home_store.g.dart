// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$recommendedMoviesAtom = Atom(
    name: '_HomeStore.recommendedMovies',
    context: context,
  );

  @override
  ObservableList<Movie> get recommendedMovies {
    _$recommendedMoviesAtom.reportRead();
    return super.recommendedMovies;
  }

  @override
  set recommendedMovies(ObservableList<Movie> value) {
    _$recommendedMoviesAtom.reportWrite(value, super.recommendedMovies, () {
      super.recommendedMovies = value;
    });
  }

  late final _$moviesByGenreAtom = Atom(
    name: '_HomeStore.moviesByGenre',
    context: context,
  );

  @override
  ObservableMap<int, List<Movie>> get moviesByGenre {
    _$moviesByGenreAtom.reportRead();
    return super.moviesByGenre;
  }

  @override
  set moviesByGenre(ObservableMap<int, List<Movie>> value) {
    _$moviesByGenreAtom.reportWrite(value, super.moviesByGenre, () {
      super.moviesByGenre = value;
    });
  }

  late final _$genresAtom = Atom(name: '_HomeStore.genres', context: context);

  @override
  ObservableList<Genre> get genres {
    _$genresAtom.reportRead();
    return super.genres;
  }

  @override
  set genres(ObservableList<Genre> value) {
    _$genresAtom.reportWrite(value, super.genres, () {
      super.genres = value;
    });
  }

  late final _$isLoadingRecommendedAtom = Atom(
    name: '_HomeStore.isLoadingRecommended',
    context: context,
  );

  @override
  bool get isLoadingRecommended {
    _$isLoadingRecommendedAtom.reportRead();
    return super.isLoadingRecommended;
  }

  @override
  set isLoadingRecommended(bool value) {
    _$isLoadingRecommendedAtom.reportWrite(
      value,
      super.isLoadingRecommended,
      () {
        super.isLoadingRecommended = value;
      },
    );
  }

  late final _$isLoadingGenresAtom = Atom(
    name: '_HomeStore.isLoadingGenres',
    context: context,
  );

  @override
  bool get isLoadingGenres {
    _$isLoadingGenresAtom.reportRead();
    return super.isLoadingGenres;
  }

  @override
  set isLoadingGenres(bool value) {
    _$isLoadingGenresAtom.reportWrite(value, super.isLoadingGenres, () {
      super.isLoadingGenres = value;
    });
  }

  late final _$selectedGenreIdAtom = Atom(
    name: '_HomeStore.selectedGenreId',
    context: context,
  );

  @override
  int get selectedGenreId {
    _$selectedGenreIdAtom.reportRead();
    return super.selectedGenreId;
  }

  @override
  set selectedGenreId(int value) {
    _$selectedGenreIdAtom.reportWrite(value, super.selectedGenreId, () {
      super.selectedGenreId = value;
    });
  }

  late final _$isAutoScrollingAtom = Atom(
    name: '_HomeStore.isAutoScrolling',
    context: context,
  );

  @override
  bool get isAutoScrolling {
    _$isAutoScrollingAtom.reportRead();
    return super.isAutoScrolling;
  }

  @override
  set isAutoScrolling(bool value) {
    _$isAutoScrollingAtom.reportWrite(value, super.isAutoScrolling, () {
      super.isAutoScrolling = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_HomeStore.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    '_HomeStore.init',
    context: context,
  );

  @override
  Future<void> init(List<int> selectedGenreIds, List<int> selectedMovieIds) {
    return _$initAsyncAction.run(
      () => super.init(selectedGenreIds, selectedMovieIds),
    );
  }

  late final _$fetchGenresAsyncAction = AsyncAction(
    '_HomeStore.fetchGenres',
    context: context,
  );

  @override
  Future<void> fetchGenres() {
    return _$fetchGenresAsyncAction.run(() => super.fetchGenres());
  }

  late final _$fetchRecommendedAsyncAction = AsyncAction(
    '_HomeStore.fetchRecommended',
    context: context,
  );

  @override
  Future<void> fetchRecommended(List<int> genreIds, List<int> movieIds) {
    return _$fetchRecommendedAsyncAction.run(
      () => super.fetchRecommended(genreIds, movieIds),
    );
  }

  late final _$fetchMoviesForGenreAsyncAction = AsyncAction(
    '_HomeStore.fetchMoviesForGenre',
    context: context,
  );

  @override
  Future<void> fetchMoviesForGenre(int genreId) {
    return _$fetchMoviesForGenreAsyncAction.run(
      () => super.fetchMoviesForGenre(genreId),
    );
  }

  late final _$_HomeStoreActionController = ActionController(
    name: '_HomeStore',
    context: context,
  );

  @override
  void setAutoScrolling(bool value) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore.setAutoScrolling',
    );
    try {
      return super.setAutoScrolling(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedGenre(int id) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore.setSelectedGenre',
    );
    try {
      return super.setSelectedGenre(id);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore.setSearchQuery',
    );
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
recommendedMovies: ${recommendedMovies},
moviesByGenre: ${moviesByGenre},
genres: ${genres},
isLoadingRecommended: ${isLoadingRecommended},
isLoadingGenres: ${isLoadingGenres},
selectedGenreId: ${selectedGenreId},
isAutoScrolling: ${isAutoScrolling},
searchQuery: ${searchQuery}
    ''';
  }
}
