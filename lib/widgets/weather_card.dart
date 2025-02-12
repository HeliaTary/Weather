import 'package:flutter/material.dart';
import 'package:weather_project/models/weather_model.dart';
import 'package:weather_project/utils/weather_utils.dart';

class WeatherCard extends StatelessWidget {
  final WeatherDataModel weatherData;

  const WeatherCard(this.weatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    String icon = weatherData.weather?.first.icon ?? "";
    IconData weatherIcon = WeatherUtils.getWeatherIcon(icon);

    Color iconColor;
    switch (WeatherUtils.getWeatherCondition(icon)) {
      case 'Sunny':
        iconColor = Colors.yellow;
        break;
      case 'Cloudy':
      case 'Partly Cloudy':
        iconColor = Colors.grey;
        break;
      case 'Rainy':
        iconColor = Colors.blue;
        break;
      case 'Snowy':
        iconColor = Colors.white;
        break;
      case 'Stormy':
      case 'Foggy':
        iconColor = Colors.deepPurple;
        break;
      default:
        iconColor = Colors.black;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              weatherData.name ?? "Unknown City",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Icon(
              weatherIcon,
              size: 80,
              color: iconColor, // Apply dynamic color
            ),
            const SizedBox(height: 10),
            Text("${weatherData.main?.temp.toStringAsFixed(1)}°C",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(WeatherUtils.getWeatherCondition(icon),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [const Icon(Icons.water_drop, color: Colors.blue),
                  Text("Humidity: ${weatherData.main?.humidity ?? 0}%")]),
                Column(children: [const Icon(Icons.air, color: Colors.grey),
                  Text("Wind: ${weatherData.wind?.speed ?? 0} m/s")]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}