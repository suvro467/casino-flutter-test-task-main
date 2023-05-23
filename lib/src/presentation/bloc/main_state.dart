import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/models/character_info.dart';
import 'package:equatable/equatable.dart';

abstract class MainPageState extends Equatable {}

class InitialMainPageState extends MainPageState {
  @override
  List<Object> get props => [];
}

class LoadingMainPageState extends MainPageState {
  @override
  List<Object> get props => [];
}

class UnSuccessfulMainPageState extends MainPageState {
  @override
  List<Object> get props => [];
}

class SuccessfulMainPageState extends MainPageState {
  final CharacterInfo characterInfo;

  SuccessfulMainPageState(this.characterInfo);

  @override
  List<Object> get props => [characterInfo];
}
