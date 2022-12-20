import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/url/url_const.dart';
import 'package:jais/widgets/decoration/round_border_decoration.dart';
import 'package:jais/widgets/skeleton.dart';

class LiteEpisodeImage extends StatelessWidget {
  final Episode episode;
  final double? height;

  const LiteEpisodeImage({required this.episode, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${UrlConst.episodeAttachment}${episode.uuid}',
      imageBuilder: (_, ImageProvider<Object> imageProvider) {
        return RoundBorderDecoration(
          widget: Image(image: imageProvider, fit: BoxFit.cover),
        );
      },
      placeholder: (_, __) => Skeleton(height: height),
      errorWidget: (_, __, ___) => Skeleton(height: height),
    );
  }
}
