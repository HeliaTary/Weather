import 'package:dio/dio.dart';
import 'package:weather_project/network/http_helper.dart';


class WeatherRepository {
  Future<Map<String, dynamic>> getWeather(String city) async {
    var res = await HttpHelper()
        .httpGet("?q=${city}&appid=e82090054e14033f55d5dc62236ff9e2&units=metric",baseUrl: 'https://api.openweathermap.org/data/2.5/weather',);
    return res.data;
  }
}
