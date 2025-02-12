import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_project/cubit/weather/weather_cubit.dart';
import 'package:weather_project/models/base_state.dart';
import 'package:weather_project/state/weather/weather_state.dart';
import 'package:weather_project/widgets/custom_bloc_provider.dart';
import 'package:weather_project/widgets/weather_background.dart';
import 'package:weather_project/widgets/weather_card.dart';

@RoutePage()
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return CustomBlocProvider.provide(
      bloc: WeatherCubit(),
      builder: (context) {
        return BlocConsumer<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: Stack(
                children: [
                  WeatherBackground(weatherData: state.weatherData),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16, top: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 80),
                            _buildSearchBar(context),
                            if (state.status == StateStatus.loading)
                              const CircularProgressIndicator(),
                            if (state.status == StateStatus.loaded && state.weatherData != null)
                              WeatherCard(state.weatherData!),
                            if (state.status == StateStatus.error)
                              const Text(
                                "Failed to fetch weather. Please try again.",
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {},
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final weatherCubit = BlocProvider.of<WeatherCubit>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: weatherCubit.cityController,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                FocusScope.of(context).unfocus(); // Hide keyboard when submitting
                weatherCubit.getWeather(value);
              },
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Enter city name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              onTap: () {
                String city = weatherCubit.cityController.text.trim();
                if (city.isNotEmpty) {
                  FocusScope.of(context).unfocus(); // Hide keyboard when searching
                  weatherCubit.getWeather(city);
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: () {
              weatherCubit.cityController.clear();
              weatherCubit.clear(context);
              FocusScope.of(context).unfocus(); // Hide keyboard
            },
          ),
        ],
      ),
    );
  }

}




