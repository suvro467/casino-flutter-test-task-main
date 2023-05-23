import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/models/character_info.dart';
import 'package:equatable/equatable.dart';

abstract class MainPageEvent extends Equatable {
  const MainPageEvent();

  @override
  List<Object?> get props => [];
}

class GetTestDataOnMainPageEvent extends MainPageEvent {
  final int page;

  const GetTestDataOnMainPageEvent(this.page);

  @override
  List<Object?> get props => [];
}

class LoadingDataOnMainPageEvent extends MainPageEvent {
  const LoadingDataOnMainPageEvent();

  @override
  List<Object?> get props => [];
}

class DataLoadedOnMainPageEvent extends MainPageEvent {
  final CharacterInfo? characterInfo;

  const DataLoadedOnMainPageEvent(this.characterInfo);

  @override
  List<Object?> get props => [characterInfo];
}
