import 'package:flutter/material.dart';
import 'package:flutter12rplthn2627/providers/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'pages/main_navigation.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favProvider = FavoriteProvider();
  await favProvider.initStorage();

  runApp(
    ChangeNotifierProvider.value(value: favProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData.dark(),
      home: const SplashScreen()
    );
  }
}


 