import 'package:casino_test/src/data/models/character.dart';

import '../models/character_info.dart';

abstract class CharactersRepository {
  Future<CharacterInfo?> getCharacters(int page);
}
