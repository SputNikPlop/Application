import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:jais/components/navbar.dart';
import 'package:jais/mappers/device_mapper.dart';
import 'package:jais/mappers/navbar_mapper.dart';
import 'package:jais/views/animes_view.dart';
import 'package:jais/views/episodes_view.dart';
import 'package:jais/views/mangas_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void changePage(int page) => NavbarMapper.instance.currentPage = page;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bool showRequestReview =
          await DeviceMapper.reviewMapper.canShowReview();

      if (!mounted || !showRequestReview) {
        return;
      }

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Aimez-vous notre application ?'),
            content: const Text('Voulez-vous laisser un avis ?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Non'),
                onPressed: () async {
                  Navigator.pop(context);
                  await DeviceMapper.reviewMapper.neverReview();
                },
              ),
              TextButton(
                child: const Text('Plus tard'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Oui'),
                onPressed: () async {
                  Navigator.pop(context);
                  await DeviceMapper.reviewMapper.acceptReview();
                  InAppReview.instance.requestReview();
                },
              )
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavbarMapper>.value(
      value: NavbarMapper.instance,
      child: Consumer<NavbarMapper>(
        builder: (BuildContext context, NavbarMapper navbarMapper, __) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: <Widget>[
                Navbar(
                  onPageChanged: changePage,
                  topWidgets: <Widget>[
                    if (navbarMapper.currentPage == 1)
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamed('/scan');
                        },
                        icon: const Icon(Icons.document_scanner),
                      ),
                    if (navbarMapper.currentPage == 2)
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamed('/search');
                        },
                        icon: const Icon(Icons.search),
                      ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: navbarMapper.pageController,
                    onPageChanged: changePage,
                    children: const <Widget>[
                      EpisodesView(),
                      MangasView(),
                      AnimesView(),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              currentIndex: navbarMapper.currentPage,
              onTap: changePage,
              items: <BottomNavigationBarItem>[
                ...navbarMapper.itemsBottomNavBar
              ],
            ),
          );
        },
      ),
    );
  }
}