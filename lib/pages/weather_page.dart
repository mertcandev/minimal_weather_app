import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("59fafcc8bb4173f30843073a9225ece6");
  Weather? _weather;
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloudy.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rainy.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";

      default:
        return "assets/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.pin_drop_rounded,
            color: Colors.white,
            size: 20,
          ),
          Text(
            _weather?.cityName ?? "loading city...",
            style: GoogleFonts.asapCondensed(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 50,
          ),
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          const SizedBox(
            height: 50,
          ),
          Text("${_weather?.temperature.round()} °C",
              style: GoogleFonts.barlowSemiCondensed(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
          Text(_weather?.mainCondition ?? "",
              style: GoogleFonts.barlowSemiCondensed(
                  color: Colors.white, fontSize: 24))
        ]),
      ),
    );
  }
}
