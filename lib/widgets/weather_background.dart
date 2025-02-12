import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';
import 'package:weather_project/models/weather_model.dart';
import 'package:weather_project/utils/weather_utils.dart';

class WeatherBackground extends StatelessWidget {
  final WeatherDataModel? weatherData;

  const WeatherBackground({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    String icon = weatherData?.weather?.first.icon ?? "";

    Widget weatherEffect;
    switch (WeatherUtils.getWeatherCondition(icon)) {
      case 'Sunny':
        weatherEffect = const SunWidget();
        break;
      case 'Cloudy':
      case 'Partly Cloudy':
        weatherEffect = const CloudWidget();
        break;
      case 'Rainy':
        weatherEffect = const RainWidget();
        break;
      case 'Snowy':
        weatherEffect = const SnowWidget();
        break;
      case 'Stormy':
      case 'Foggy':
        weatherEffect = const ThunderWidget();
        break;
      default:
        weatherEffect = Container();
    }
    return Positioned.fill(child: weatherEffect);
  }
}