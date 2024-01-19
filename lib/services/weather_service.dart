import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);
  Future<Weather> getWeather(String cityName) async {
    Position cityPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    final response = await http.get(Uri.parse(
        "$BASE_URL?lat=${cityPosition.latitude}&lon=${cityPosition.longitude}&appid=$apiKey&units=metric"));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception("Failed to load weather data.");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placeMarks[0].locality;

    return city ?? "";
  }
}
