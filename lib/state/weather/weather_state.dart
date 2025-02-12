import 'package:weather_project/models/base_state.dart';
import 'package:weather_project/models/weather_model.dart';
import 'package:weather_project/network/exception.dart';


class WeatherState extends BaseState {
  const WeatherState({
    super.httpException,
    super.status,
    this.weatherData
  });

  final WeatherDataModel? weatherData;



  @override
  List<Object?> get props => [
    ...super.props,
    weatherData
  ];

  WeatherState copyWith({
    StateStatus? status,
    HttpException? httpException,
    WeatherDataModel? weatherData

  }) {
    return WeatherState(
        status: status ?? this.status,
        httpException: httpException ?? this.httpException,
        weatherData: weatherData ?? this.weatherData
    );
  }
}
