import 'package:jais/components/lite_episodes/lite_episode_loader_widget.dart';
import 'package:jais/components/lite_episodes/lite_episode_widget.dart';
import 'package:jais/entities/anime.dart';
import 'package:jais/entities/episode.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/url/url_const.dart';

class AnimeEpisodeMapper extends IMapper<Episode> {
  Anime? anime;

  AnimeEpisodeMapper()
      : super(
          limit: 24,
          loaderWidget: const LiteEpisodeLoaderWidget(),
          fromJson: Episode.fromJson,
          toWidget: (Episode episode) => LiteEpisodeWidget(episode: episode),
        );

  @override
  Future<bool> updateCurrentPage() async {
    if (anime == null) {
      return false;
    }

    return await loadPage(UrlConst.getEpisodesAnimePage(anime!, page, limit));
    // return true;
  }
}
