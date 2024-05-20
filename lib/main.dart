import 'package:aircade/personal_page.dart';
import 'package:aircade/qr_page.dart';
import 'package:aircade/services/user_service.dart';
import 'package:aircade/video_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

Future<void> main() async {
  final userService = UserService(baseUrl: 'https://api.arcade-link.top');

  WidgetsFlutterBinding.ensureInitialized();

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
    QrPage(),
    VideoPage(),
    PersonalPage()
  ];

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final userService = Provider.of<UserService>(context, listen: false);
    userService.isLoggedIn.addListener(_refresh);
  }

  @override
  void dispose() {
    final userService = Provider.of<UserService>(context, listen: false);
    userService.isLoggedIn.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return FutureBuilder<bool>(
      future: userService.isJwtValid(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 显示加载指示器
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 显示错误信息
        } else if (snapshot.data == false) {
          print("jwt is invalid, showing login page...");
          return const LoginPageAndRegisterPage(); // 如果 JWT 无效，显示登录页面
        } else {
          // 如果 JWT 有效，显示主页面
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
      },
    );
  }
}
