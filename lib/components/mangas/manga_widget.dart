import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/border_element.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/entities/manga.dart';
import 'package:jais/mappers/country_mapper.dart';
import 'package:jais/url/url.dart';
import 'package:jais/url/url_const.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';

class MangaWidget extends StatelessWidget {
  final Manga manga;
  final bool redirect;

  const MangaWidget({required this.manga, this.redirect = true, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!redirect) {
          return;
        }

        URL.goOnUrl(
          'https://www.amazon.${CountryMapper.selectedCountry?.tag}/s?k=${manga.ean}',
          showAd: false,
        );
      },
      child: BorderElement(
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: '${UrlConst.mangasAttachment}${manga.uuid}',
              imageBuilder: (_, ImageProvider<Object> imageProvider) {
                return RoundBorderWidget(
                  widget: Image(image: imageProvider, fit: BoxFit.cover),
                );
              },
              placeholder: (_, __) => const Skeleton(
                width: Const.mangaImageWith,
                height: Const.mangaImageHeight,
              ),
              errorWidget: (_, __, ___) => const Skeleton(
                width: Const.mangaImageWith,
                height: Const.mangaImageHeight,
              ),
              width: Const.mangaImageWith,
              height: Const.mangaImageHeight,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    manga.anime.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    manga.ref.ifEmptyOrNull('Aucune référence pour le moment'),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    manga.editor,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Utils.printTimeSinceDays(
                      DateTime.parse(manga.releaseDate),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}