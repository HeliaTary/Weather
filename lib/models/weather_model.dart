import 'dart:developer';

class WeatherDataModel {
  CoordDataModel? coord;
  List<WeatherCondition>? weather;
  MainDataModel? main;
  WindDataModel? wind;
  CloudDataModel? clouds;
  int? visibility;
  int? dt;
  int? timezone;
  String? name;
  String? cod;

  WeatherDataModel({
    this.coord,
    this.weather,
    this.main,
    this.wind,
    this.clouds,
    this.visibility,
    this.dt,
    this.timezone,
    this.name,
    this.cod,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      coord: json['coord'] != null ? CoordDataModel.fromJson(json['coord']) : null,
      weather: (json['weather'] as List?)?.map((e) => WeatherCondition.fromJson(e)).toList() ?? [],
      main: json['main'] != null ? MainDataModel.fromJson(json['main']) : null,
      wind: json['wind'] != null ? WindDataModel.fromJson(json['wind']) : null,
      clouds: json['clouds'] != null ? CloudDataModel.fromJson(json['clouds']) : null,
      visibility: json['visibility'],
      dt: json['dt'],
      timezone: json['timezone'],
      name: json['name'],
      cod: json['cod']?.toString(), // Ensuring cod is properly assigned as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coord': coord?.toJson(),
      'weather': weather?.map((e) => e.toJson()).toList(),
      'main': main?.toJson(),
      'wind': wind?.toJson(),
      'clouds': clouds?.toJson(),
      'visibility': visibility,
      'dt': dt,
      'timezone': timezone,
      'name': name,
      'cod': cod,
    };
  }
}

class CoordDataModel {
  double lon;
  double lat;

  CoordDataModel({required this.lon, required this.lat});

  factory CoordDataModel.fromJson(Map<String, dynamic> json) {
    return CoordDataModel(
      lon: (json['lon'] ?? 0.0).toDouble(),
      lat: (json['lat'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lon': lon, 'lat': lat};
  }
}

class WeatherCondition {
  int id;
  String main;
  String description;
  String icon;

  WeatherCondition({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      id: json['id'] ?? 0,
      main: json['main'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}

class MainDataModel {
  double temp;
  double feelsLike;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;

  MainDataModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory MainDataModel.fromJson(Map<String, dynamic> json) {
    return MainDataModel(
      temp: (json['temp'] ?? 0.0).toDouble(),
      feelsLike: (json['feels_like'] ?? 0.0).toDouble(),
      tempMin: (json['temp_min'] ?? 0.0).toDouble(),
      tempMax: (json['temp_max'] ?? 0.0).toDouble(),
      pressure: json['pressure'] ?? 0,
      humidity: json['humidity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feels_like': feelsLike,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'pressure': pressure,
      'humidity': humidity,
    };
  }
}

class WindDataModel {
  double speed;
  int deg;

  WindDataModel({required this.speed, required this.deg});

  factory WindDataModel.fromJson(Map<String, dynamic> json) {
    return WindDataModel(
      speed: (json['speed'] ?? 0.0).toDouble(),
      deg: json['deg'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'speed': speed, 'deg': deg};
  }
}

class CloudDataModel {
  int all;

  CloudDataModel({required this.all});

  factory CloudDataModel.fromJson(Map<String, dynamic> json) {
    return CloudDataModel(all: json['all'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'all': all};
  }
}
