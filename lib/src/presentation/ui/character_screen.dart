import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/main_bloc.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@immutable
class CharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MainPageBloc(
          InitialMainPageState(),
          GetIt.I.get<CharactersRepository>(),
        )..add(const GetTestDataOnMainPageEvent(1)),
        child: BlocConsumer<MainPageBloc, MainPageState>(
          listener: (context, state) {},
          builder: (blocContext, state) {
            if (state is LoadingMainPageState) {
              return _loadingWidget(context);
            } else if (state is SuccessfulMainPageState) {
              return _successfulWidget(context, state);
            } else {
              return Center(child: const Text("error"));
            }
          },
        ),
      ),
    );
  }

  Widget _loadingWidget(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _successfulWidget(
      BuildContext context, SuccessfulMainPageState state) {
    return ListView.builder(
      //cacheExtent: double.infinity,
      itemCount: state.characters.length,
      itemBuilder: (context, index) {
        return _characterWidget(context, state.characters[index]);
      },
    );
  }

  Widget _characterWidget(BuildContext context, Character character) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: ShapeDecoration(
          color: Color.fromARGB(120, 204, 255, 255),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(character.name),
            ),
            Image.network(
              character.image,
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
