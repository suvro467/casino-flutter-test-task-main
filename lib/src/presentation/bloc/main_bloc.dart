import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final CharactersRepository _charactersRepository;

  late MainPageEvent _previousEvent;
  @override
  void onEvent(MainPageEvent event) {
    _previousEvent = event;
    super.onEvent(event);
  }

  MainPageBloc(
    MainPageState initialState,
    this._charactersRepository,
  ) : super(initialState) {
    on<GetTestDataOnMainPageEvent>(
      (event, emitter) => _getDataOnMainPageCasino(event, emitter),
    );
    on<DataLoadedOnMainPageEvent>(
      (event, emitter) => _dataLoadedOnMainPageCasino(event, emitter),
    );
    on<LoadingDataOnMainPageEvent>(
      (event, emitter) => emitter(LoadingMainPageState()),
    );
  }

  Future<void> _dataLoadedOnMainPageCasino(
    DataLoadedOnMainPageEvent event,
    Emitter<MainPageState> emit,
  ) async {
    if (event.characterInfo != null) {
      emit(SuccessfulMainPageState(event.characterInfo!));
    } else {
      emit(UnSuccessfulMainPageState());
    }
  }

  Future<void> _getDataOnMainPageCasino(
    GetTestDataOnMainPageEvent event,
    Emitter<MainPageState> emit,
  ) async {
    _charactersRepository.getCharacters(event.page).then(
      (value) {
        add(DataLoadedOnMainPageEvent(value));
      },
    ).onError((error, stackTrace) {
      print("OnError called");
      // In case of any error, this unsuccessful event will be added
      // to the bloc unless and untill this event is successfully emited.
      if (_previousEvent != null) {
        add(_previousEvent);
      }
    });
  }
}
