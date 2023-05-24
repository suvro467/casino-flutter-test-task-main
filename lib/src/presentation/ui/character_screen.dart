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
import 'package:intl/intl.dart';

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

  int storePageKey = 1;

  List<Character> records = [];
  final PagingController<int, Character> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener(
      (pageKey) => _characterBloc.add(GetTestDataOnMainPageEvent(storePageKey)),
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
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _characterBloc,
          child: BlocConsumer<MainPageBloc, MainPageState>(
            listener: (context, state) {
              try {
                if (state is InitialMainPageState) {
                } else if (state is LoadingMainPageState) {
                } else if (state is SuccessfulMainPageState) {
                  CharacterInfo characterInfo = state.props.cast().first;
                  records = characterInfo.characters!;
                  int lastPage = characterInfo.pages!;
                  final _next = storePageKey++;
                  if (_next > lastPage) {
                    _pagingController.appendLastPage(records);
                  } else {
                    _pagingController.appendPage(records, _next);
                  }
                }
              } on Exception catch (e) {
                _pagingController.error = e;
              }
            },
            builder: (blocContext, state) {
              if (state is InitialMainPageState) {
                return _initialWidget(context, state);
              } else if (state is LoadingMainPageState) {
                return _loadingWidget(context);
              } else if (state is SuccessfulMainPageState) {
                return _successfulWidget(context, state);
              } else {
                return Center(child: const Text("error"));
              }
            },
          ),
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
      builderDelegate: PagedChildBuilderDelegate<Character>(
          itemBuilder: (context, character, index) {
        return _characterWidget(context, character);
      }),
    );
  }

  Widget _initialWidget(BuildContext context, InitialMainPageState state) {
    return PagedListView<int, Character>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Character>(
          itemBuilder: (context, character, index) {
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    character.image,
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Species: ",
                            style: TextStyle(
                              color: Color(0xff214A96),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          character.species,
                          style: TextStyle(
                            color: Color(0xff214A96),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Status: ",
                            style: TextStyle(
                              color: Color(0xff214A96),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          character.status,
                          style: TextStyle(
                            color: Color(0xff214A96),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Created: ",
                            style: TextStyle(
                              color: Color(0xff214A96),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('MM/dd/yyyy hh:mm a').format(
                              DateTime.parse(
                                  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                      .parse(character.created)
                                      .toString())),
                          style: TextStyle(
                            color: Color(0xff214A96),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  character.name,
                  style: TextStyle(
                    color: Color(0xff214A96),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              " (${character.gender})",
              style: TextStyle(
                color: Color(0xff214A96),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
