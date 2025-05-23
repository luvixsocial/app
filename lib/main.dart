import 'dart:io';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/notifications.dart';
import 'pages/profile.dart';
import 'pages/settings.dart';
import 'pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<bool> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    return true;
  } else {
    return false;
  }
}

Future<String?> getFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return token;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseAuth.instance.signOut();
  
  requestNotificationPermission();
  runApp(const LuvixApp());
}

class LuvixApp extends StatelessWidget {
  const LuvixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luvix Social',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        colorScheme: ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.redAccent,
        ),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const Profile(),
        '/notifications': (context) => const Notifications(),
        '/settings': (context) => const Settings(),
        '/home': (context) => const LuvixScreen(),
      },
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const LuvixScreen();
        }
        return const LoginPage();
      },
    );
  }
}

class LuvixScreen extends StatefulWidget {
  const LuvixScreen({super.key});

  @override
  State<LuvixScreen> createState() => _LuvixScreenState();
}

class _LuvixScreenState extends State<LuvixScreen> {
  int currentPageIndex = 0;
  final List<Widget> pages = [const Home(), const Notifications()];

  @override
  Widget build(BuildContext context) {
    bool isMobile = Platform.isAndroid || Platform.isIOS;
    bool isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
    bool isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Luvix Social'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          if (isTablet || isDesktop) _buildSidebar(),
          Expanded(child: pages[currentPageIndex]),
        ],
      ),
      bottomNavigationBar: isMobile ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Text('Luvix Social'),
          ),
          _buildDrawerItem(
            'Home',
            Icons.home,
            () => setState(() => currentPageIndex = 0),
          ),
          _buildDrawerItem(
            'Notifications',
            Icons.notifications,
            () => setState(() => currentPageIndex = 1),
          ),
          _buildDrawerItem(
            'Profile',
            Icons.person,
            () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildDrawerItem(
            'Settings',
            Icons.settings,
            () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildSidebar() {
    return NavigationRail(
      selectedIndex: currentPageIndex,
      backgroundColor: const Color(0xFF1E1E1E),
      onDestinationSelected:
          (index) => setState(() => currentPageIndex = index),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: Text('Notifications'),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      onTap: (index) => setState(() => currentPageIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
      ],
    );
  }
}
