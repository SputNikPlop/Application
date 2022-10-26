import 'package:flutter/material.dart';
import 'package:jais/mappers/device_mapper.dart';
import 'package:jais/utils/utils.dart';

class AnimeList extends StatelessWidget {
  final List<Widget> children;
  final int rowCol;

  const AnimeList({required this.children, this.rowCol = 3, super.key});

  @override
  Widget build(BuildContext context) {
    if (!DeviceMapper.isOnMobile(context)) {
      return Column(
        children: <Widget>[...Utils.separate(children, rowCol: rowCol)],
      );
    }

    return Column(
      children: <Widget>[...children],
    );
  }
}