import 'package:flutter/material.dart';
import 'package:jais/components/border_element.dart';
import 'package:jais/components/platforms/platform_loader_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/device_mapper.dart';
import 'package:jais/utils/const.dart';

class LiteEpisodeLoaderWidget extends StatelessWidget {
  const LiteEpisodeLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BorderElement(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Skeleton(
                  height: DeviceMapper.isOnMobile(context)
                      ? Const.episodeImageHeight / 2
                      : null,
                ),
                const Positioned(
                  top: 2,
                  right: 3,
                  child: PlatformLoaderWidget(),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Skeleton(width: 150, height: 20),
                SizedBox(height: 5),
                Skeleton(width: 100, height: 20),
                SizedBox(height: 5),
                Skeleton(width: 100, height: 20),
                SizedBox(height: 5),
                Skeleton(width: 100, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}