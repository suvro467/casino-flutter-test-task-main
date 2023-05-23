import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/models/character_info.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/main_bloc.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

@immutable
class CharactersScreen extends StatefulWidget {
  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late final _characterBloc = MainPageBloc(
    InitialMainPageState(),
    GetIt.I.get<CharactersRepository>(),
  );

  List<Character> records = [];
  final PagingController<int, Character> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    //*so at event add list of records
    _pagingController.addPageRequestListener(
      (pageKey) => _characterBloc.add(
          //GetTimeslotViewEvent(records: records, offset: pageKey, limit: 10)
          GetTestDataOnMainPageEvent(pageKey)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _characterBloc.close();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _characterBloc,
        /* create: (context) => MainPageBloc(
          InitialMainPageState(),
          GetIt.I.get<CharactersRepository>(),
        )..add(GetTestDataOnMainPageEvent(1)), */
        child: BlocConsumer<MainPageBloc, MainPageState>(
          listener: (context, state) {
            if (state is LoadingMainPageState) {
              //return _loadingWidget(context);
            } else if (state is SuccessfulMainPageState) {
              CharacterInfo characterInfo = state.props.cast().first;
              records = characterInfo.characters!;
              int lastPage = characterInfo.pages!;
              final _next = 1 + records.length;
              if (_next > lastPage) {
                _pagingController.appendLastPage(records);
              } else {
                _pagingController.appendPage(records, _next);
              }

              print("Testing");
            } else {
              //_pagingController.error = state.error;
            }
          },
          builder: (blocContext, state) {
            return PagedListView<int, Character>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Character>(
                    itemBuilder: (context, character, index) =>
                        _characterWidget(
                          context,
                          character,
                        )));
            /* if (state is LoadingMainPageState) {
              return _loadingWidget(context);
            } else if (state is SuccessfulMainPageState) {
              return _successfulWidget(context, state);
            } else {
              return Center(child: const Text("error"));
            } */
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
    return PagedListView<int, Character>(
      pagingController: _pagingController,
      //cacheExtent: double.infinity,
      builderDelegate: PagedChildBuilderDelegate<Character>(
          itemBuilder: (context, character, index) {
        //state.characters[index]
        return _characterWidget(context, character);
      }),
    );
  }

  Widget _characterWidget(
    BuildContext context,
    Character character,
  ) {
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
