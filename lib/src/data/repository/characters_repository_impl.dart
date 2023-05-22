import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:http/http.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final Client client;

  CharactersRepositoryImpl(this.client);

  @override
  Future<List<Character>?> getCharacters(int page) async {
    var client = Client();
    final charResult = await client.get(
      Uri.parse("https://rickandmortyapi.com/api/character/?page=$page"),
    );
    final jsonMap = await json.decode(charResult.body) as Map<String, dynamic>;

    final bool showMockedError = Random().nextBool();
    print("casino test log: showMockedError = $showMockedError");
    /* if (showMockedError) {
      return Future.delayed(
        const Duration(seconds: 5),
        () => null,
      );
    } */
    return Future.value(
      List.of(
        (jsonMap["results"] as List<dynamic>).map(
          (value) => Character.fromJson(value),
        ),
      ),
    );
  }
}
