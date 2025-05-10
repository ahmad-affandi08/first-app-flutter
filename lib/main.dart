import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '/theme/theme_provider.dart';
import '/screen/splash_screen.dart';
import '/screen/home_screen.dart';
import '/screen/profile_screen.dart';
import '/screen/booking_screen.dart';
import '/screen/setting_screen.dart';
import '/model/pengguna.dart';

void main() async {
  await GetStorage.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      title: 'Fan8Ball',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Pengguna pengguna;

  const MainScreen({super.key, required this.pengguna});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _bottomNavIndex = 0;
  final autoSizeGroup = AutoSizeGroup();

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  final iconList = <IconData>[
    Icons.home,
    Icons.calendar_today,
    Icons.person,
    Icons.settings,
  ];

  final titleList = <String>['Beranda', 'Booking', 'Profil', 'Pengaturan'];

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(borderRadiusCurve);

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  Widget _getScreen() {
    switch (_bottomNavIndex) {
      case 0:
        return HomeScreen(pengguna: widget.pengguna);
      case 1:
        return BookingScreen(pengguna: widget.pengguna);
      case 2:
        return ProfileScreen(pengguna: widget.pengguna);
      case 3:
        return SettingScreen(pengguna: widget.pengguna);
      default:
        return HomeScreen(pengguna: widget.pengguna);
    }
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    _hideBottomBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: _getScreen(),
      ),
      floatingActionButton: ScaleTransition(
        scale: fabAnimation,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color:
                  isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing animation background
              ScaleTransition(
                scale: Tween(begin: 0.8, end: 1.2).animate(
                  AnimationController(
                    duration: const Duration(milliseconds: 1000),
                    vsync: this,
                  )..repeat(reverse: true),
                ),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
              ),
              // Main icon with rotation
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _fabAnimationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Icon(
                  Icons.sports_basketball,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              // Shining effect
              Positioned.fill(
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // Add haptic feedback
            Feedback.forTap(context);

            // Show the tip dialog
            _showBilliardTipDialog();

            // Reset and restart animations
            _fabAnimationController.reset();
            _borderRadiusAnimationController.reset();
            _borderRadiusAnimationController.forward();
            _fabAnimationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Theme.of(context).primaryColor : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconList[index], size: 24, color: color),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  titleList[index],
                  maxLines: 1,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ],
          );
        },
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        activeIndex: _bottomNavIndex,
        splashColor: Theme.of(context).primaryColor,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 0.5,
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  void _showBilliardTipDialog() {
    final billiardTips = [
      'Selalu fokus pada teknik pukulan Anda',
      'Pastikan postur tubuh Anda benar saat memukul bola',
      'Latihan adalah kunci untuk meningkatkan kemampuan Anda',
      'Gunakan kapur dengan benar pada ujung cue Anda',
      'Pelajari aturan permainan dengan benar',
    ];

    final random = DateTime.now().millisecond % billiardTips.length;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tips Biliar'),
            content: Text(billiardTips[random]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
    );
  }
}
