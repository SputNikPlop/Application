import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jais/ads/banner_ad.dart';
import 'package:jais/components/navbar.dart';
import 'package:jais/mappers/country_mapper.dart';
import 'package:jais/mappers/display_mapper.dart';
import 'package:jais/mappers/navbar_mapper.dart';
import 'package:jais/utils/ad_utils.dart';
import 'package:jais/utils/color.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/mangas_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AdUtils.canShowAd) {
    try {
      await MobileAds.instance.initialize();
      await createGlobalBanner();
    } catch (_) {}
  }

  await Future.wait(<Future<void>>[CountryMapper.instance.update()]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final Color _mainColor = mainColors[900]!;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: _mainColor,
        colorScheme: ColorScheme.fromSeed(seedColor: _mainColor),
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: _mainColor,
        primarySwatch: MaterialColor(_mainColor.value, mainColors),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SafeArea(
        child: ChangeNotifierProvider<NavbarMapper>.value(
          value: NavbarMapper.instance,
          child: Consumer<NavbarMapper>(
            builder: (BuildContext context, NavbarMapper navbarMapper, _) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Column(
                  children: <Widget>[
                    Navbar(
                      onPageChanged: (int page) =>
                          navbarMapper.currentPage = page,
                      webWidgets: navbarMapper.itemsTopNavBar(
                        (int page) => navbarMapper.currentPage = page,
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: navbarMapper.pageController,
                        onPageChanged: (int i) => navbarMapper.currentPage = i,
                        children: <Widget>[
                          const EpisodesView(),
                          const MangasView(),
                          Container(),
                          const AnimesView(),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: ((kIsWeb &&
                            DisplayMapper.isOnMobile(context)) ||
                        DisplayMapper.isOnMobile(context))
                    ? BottomNavigationBar(
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        selectedItemColor: Theme.of(context).primaryColor,
                        unselectedItemColor: Colors.grey,
                        currentIndex: navbarMapper.currentPage,
                        onTap: (int index) => navbarMapper.currentPage = index,
                        items: navbarMapper.itemsBottomNavBar,
                      )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
