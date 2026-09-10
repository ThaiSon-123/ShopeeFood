import 'package:app_shopeefood/screens/login_screen.dart';
import 'package:app_shopeefood/data/shopee_food_data.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appState = ShopeeFoodState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShopeeFoodScope(
      appState: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShopeeFood',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          fontFamily: 'Plus Jakarta Sans',
          useMaterial3: true,
        ),
        home: const ShopeeFoodLoginScreen(),
      ),
    );
  }
}
