import 'package:flutter/material.dart';

enum WeatherType {
  sunny,
  cloudy,
  rainy,
  thunder,
  snowy,
  foggy,
}

class WeatherUtils {
  static WeatherType getWeatherType(String? icon) {
    if (icon == null || icon.isEmpty) return WeatherType.sunny; // Default

    String key = icon.substring(0, 2);

    switch (key) {
      case "01":
        return WeatherType.sunny;
      case "02":
      case "03":
      case "04":
        return WeatherType.cloudy;
      case "09":
      case "10":
        return WeatherType.rainy;
      case "11":
        return WeatherType.thunder;
      case "13":
        return WeatherType.snowy;
      case "50":
        return WeatherType.foggy;
      default:
        return WeatherType.sunny;
    }
  }

  static String getWeatherCondition(String? icon) {
    if (icon == null || icon.isEmpty) return "Unknown";
    Map<String, String> conditions = {
      "01": "Sunny",
      "02": "Partly Cloudy",
      "03": "Cloudy",
      "04": "Cloudy",
      "09": "Rainy",
      "10": "Rainy",
      "11": "Stormy",
      "13": "Snowy",
      "50": "Foggy"
    };

    return conditions[icon.substring(0, 2)] ?? "Unknown";
  }

  static IconData getWeatherIcon(String? icon) {
    if (icon == null || icon.isEmpty) return Icons.help_outline;

    Map<String, IconData> icons = {
      "01": Icons.wb_sunny,
      "02": Icons.cloud,
      "03": Icons.cloud_queue,
      "04": Icons.cloud,
      "09": Icons.umbrella,
      "10": Icons.umbrella,
      "11": Icons.flash_on,
      "13": Icons.ac_unit,
      "50": Icons.waves, // Foggy alternative
    };

    return icons[icon.substring(0, 2)] ?? Icons.help_outline;
  }
}
