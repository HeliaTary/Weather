import 'package:auto_route/auto_route.dart';
import 'package:weather_project/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: WeatherRoute.page,initial: true),
  ];
}
