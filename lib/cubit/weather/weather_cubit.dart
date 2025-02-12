import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_project/Repository/weather_repository.dart';
import 'package:weather_project/models/base_state.dart';
import 'package:weather_project/models/weather_model.dart';
import 'package:weather_project/network/exception.dart';
import 'package:weather_project/state/weather/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(const WeatherState(status: StateStatus.initial)){}

  TextEditingController cityController=TextEditingController();

  Future getWeather(String city) async {
    try {
      var result = await WeatherRepository().getWeather(city);
      var data = WeatherDataModel.fromJson(result);
      emit(state.copyWith(
        status: StateStatus.loaded,
        weatherData: data
      ));
    } on HttpException catch (e) {
      emit(state.copyWith(
        status: StateStatus.error,
        httpException: e,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.error,
      ));
    }
  }
  Future clear(BuildContext context) async {
    emit(
      state.copyWith(
        status: StateStatus.initial,
        weatherData: WeatherDataModel(),
      ),
    );
    cityController.clear();
  }
}
