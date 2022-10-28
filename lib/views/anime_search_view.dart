import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/components/infinite_scroll.dart';
import 'package:jais/mappers/anime_mapper.dart';

class AnimeSearchView extends StatefulWidget {
  const AnimeSearchView({super.key});

  @override
  State<AnimeSearchView> createState() => _AnimeSearchViewState();
}

class _AnimeSearchViewState extends State<AnimeSearchView> {
  final AnimeMapper _animeMapper = AnimeMapper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Rechercher un anime',
            border: InputBorder.none,
          ),
          autofocus: true,
          onSubmitted: (String value) async {
            await _animeMapper.search(value);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: InfiniteScroll<AnimeMapper>(
                mapper: _animeMapper,
                builder: () => AnimeList(children: _animeMapper.list),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
