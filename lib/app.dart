import 'package:flutter/material.dart';
import 'package:weather_project/router.dart';

final appRouter = AppRouter();
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      routerConfig:appRouter.config() ,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return  child!;
      },
    );
  }
}