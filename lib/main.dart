import 'dart:ffi';

import 'package:aircade/personal_page.dart';
import 'package:aircade/qr_page.dart';
import 'package:aircade/services/user_service.dart';
import 'package:aircade/video_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final userService = UserService(baseUrl: 'https://api.arcade-link.top');

  runApp(
    Provider.value(
      value: userService,
      child: const Aircade(),
    ),
  );
}

class Aircade extends StatelessWidget {
  const Aircade({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArcadeLink Air',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationPage(),
    );
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  final List<Widget> pages = const <Widget>[
    QrPage(qrData: "test", remainingTime: 20),
    VideoPage(),
    PersonalPage(
      userName: "test",
      nickName: "tester",
      registerTime: "1234-56-78",
    )
  ];

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex < widget.pages.length
          ? widget.pages[currentIndex]
          : const Placeholder(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        selectedIndex: currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.qr_code),
            label: '二维码',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_collection),
            label: '视频',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: '个人',
          ),
        ],
      ),
    );
  }
}
