import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/navigations/screen_router.dart';
import 'package:untitled/presentation/pages/forgot-password/forgot-password.dart';
import 'package:untitled/presentation/pages/home_page.dart';
import 'package:untitled/presentation/pages/musicPlayer_page.dart';
import 'package:untitled/presentation/pages/premium_page.dart';
import 'package:untitled/presentation/pages/setting/editProfile_view.dart';
import 'package:untitled/providers/sign_up_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white10,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white38,
        ),
      ),
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
      home: const MusicPlayerPage(musicId: 1),      
    );
  }
}
