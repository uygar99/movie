// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardingStore on _OnboardingStore, Store {
  Computed<bool>? _$canContinueFromMoviesComputed;

  @override
  bool get canContinueFromMovies =>
      (_$canContinueFromMoviesComputed ??= Computed<bool>(
        () => super.canContinueFromMovies,
        name: '_OnboardingStore.canContinueFromMovies',
      )).value;
  Computed<bool>? _$canContinueFromGenresComputed;

  @override
  bool get canContinueFromGenres =>
      (_$canContinueFromGenresComputed ??= Computed<bool>(
        () => super.canContinueFromGenres,
        name: '_OnboardingStore.canContinueFromGenres',
      )).value;
  Computed<List<Movie>>? _$selectedMoviesComputed;

  @override
  List<Movie> get selectedMovies =>
      (_$selectedMoviesComputed ??= Computed<List<Movie>>(
        () => super.selectedMovies,
        name: '_OnboardingStore.selectedMovies',
      )).value;
  Computed<List<Genre>>? _$selectedGenresComputed;

  @override
  List<Genre> get selectedGenres =>
      (_$selectedGenresComputed ??= Computed<List<Genre>>(
        () => super.selectedGenres,
        name: '_OnboardingStore.selectedGenres',
      )).value;

  late final _$moviesAtom = Atom(
    name: '_OnboardingStore.movies',
    context: context,
  );

  @override
  ObservableList<Movie> get movies {
    _$moviesAtom.reportRead();
    return super.movies;
  }

  @override
  set movies(ObservableList<Movie> value) {
    _$moviesAtom.reportWrite(value, super.movies, () {
      super.movies = value;
    });
  }

  late final _$selectedMovieIdsAtom = Atom(
    name: '_OnboardingStore.selectedMovieIds',
    context: context,
  );

  @override
  ObservableSet<int> get selectedMovieIds {
    _$selectedMovieIdsAtom.reportRead();
    return super.selectedMovieIds;
  }

  @override
  set selectedMovieIds(ObservableSet<int> value) {
    _$selectedMovieIdsAtom.reportWrite(value, super.selectedMovieIds, () {
      super.selectedMovieIds = value;
    });
  }

  late final _$isLoadingMoviesAtom = Atom(
    name: '_OnboardingStore.isLoadingMovies',
    context: context,
  );

  @override
  bool get isLoadingMovies {
    _$isLoadingMoviesAtom.reportRead();
    return super.isLoadingMovies;
  }

  @override
  set isLoadingMovies(bool value) {
    _$isLoadingMoviesAtom.reportWrite(value, super.isLoadingMovies, () {
      super.isLoadingMovies = value;
    });
  }

  late final _$moviesErrorAtom = Atom(
    name: '_OnboardingStore.moviesError',
    context: context,
  );

  @override
  String? get moviesError {
    _$moviesErrorAtom.reportRead();
    return super.moviesError;
  }

  @override
  set moviesError(String? value) {
    _$moviesErrorAtom.reportWrite(value, super.moviesError, () {
      super.moviesError = value;
    });
  }

  late final _$currentMoviePageAtom = Atom(
    name: '_OnboardingStore.currentMoviePage',
    context: context,
  );

  @override
  int get currentMoviePage {
    _$currentMoviePageAtom.reportRead();
    return super.currentMoviePage;
  }

  @override
  set currentMoviePage(int value) {
    _$currentMoviePageAtom.reportWrite(value, super.currentMoviePage, () {
      super.currentMoviePage = value;
    });
  }

  late final _$wheelScrollPositionAtom = Atom(
    name: '_OnboardingStore.wheelScrollPosition',
    context: context,
  );

  @override
  double get wheelScrollPosition {
    _$wheelScrollPositionAtom.reportRead();
    return super.wheelScrollPosition;
  }

  @override
  set wheelScrollPosition(double value) {
    _$wheelScrollPositionAtom.reportWrite(value, super.wheelScrollPosition, () {
      super.wheelScrollPosition = value;
    });
  }

  late final _$genresAtom = Atom(
    name: '_OnboardingStore.genres',
    context: context,
  );

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

  late final _$selectedGenreIdsAtom = Atom(
    name: '_OnboardingStore.selectedGenreIds',
    context: context,
  );

  @override
  ObservableSet<int> get selectedGenreIds {
    _$selectedGenreIdsAtom.reportRead();
    return super.selectedGenreIds;
  }

  @override
  set selectedGenreIds(ObservableSet<int> value) {
    _$selectedGenreIdsAtom.reportWrite(value, super.selectedGenreIds, () {
      super.selectedGenreIds = value;
    });
  }

  late final _$isLoadingGenresAtom = Atom(
    name: '_OnboardingStore.isLoadingGenres',
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

  late final _$genresErrorAtom = Atom(
    name: '_OnboardingStore.genresError',
    context: context,
  );

  @override
  String? get genresError {
    _$genresErrorAtom.reportRead();
    return super.genresError;
  }

  @override
  set genresError(String? value) {
    _$genresErrorAtom.reportWrite(value, super.genresError, () {
      super.genresError = value;
    });
  }

  late final _$loadMoviesAsyncAction = AsyncAction(
    '_OnboardingStore.loadMovies',
    context: context,
  );

  @override
  Future<void> loadMovies({bool loadMore = false}) {
    return _$loadMoviesAsyncAction.run(
      () => super.loadMovies(loadMore: loadMore),
    );
  }

  late final _$loadGenresAsyncAction = AsyncAction(
    '_OnboardingStore.loadGenres',
    context: context,
  );

  @override
  Future<void> loadGenres() {
    return _$loadGenresAsyncAction.run(() => super.loadGenres());
  }

  late final _$_OnboardingStoreActionController = ActionController(
    name: '_OnboardingStore',
    context: context,
  );

  @override
  void toggleMovieSelection(int movieId) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.toggleMovieSelection',
    );
    try {
      return super.toggleMovieSelection(movieId);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGenreSelection(int genreId) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.toggleGenreSelection',
    );
    try {
      return super.toggleGenreSelection(genreId);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelections() {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.clearSelections',
    );
    try {
      return super.clearSelections();
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateWheelPosition(double position) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.updateWheelPosition',
    );
    try {
      return super.updateWheelPosition(position);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
movies: ${movies},
selectedMovieIds: ${selectedMovieIds},
isLoadingMovies: ${isLoadingMovies},
moviesError: ${moviesError},
currentMoviePage: ${currentMoviePage},
wheelScrollPosition: ${wheelScrollPosition},
genres: ${genres},
selectedGenreIds: ${selectedGenreIds},
isLoadingGenres: ${isLoadingGenres},
genresError: ${genresError},
canContinueFromMovies: ${canContinueFromMovies},
canContinueFromGenres: ${canContinueFromGenres},
selectedMovies: ${selectedMovies},
selectedGenres: ${selectedGenres}
    ''';
  }
}
