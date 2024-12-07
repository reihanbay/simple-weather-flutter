import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //apiKey
  final _weatherService = WeatherServices("APIKEY");
  Weather? _weather;
  
  //fetchWeather
  _fetchWeather() async {
    //get current city
    List<double> latlon = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(latlon[0],latlon[1]);
      setState(() {
        _weather = weather;
      });
    }
    catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  //weather animations
  String iconState(String? weather) {
    if(weather == null) return "sunny.json";
    switch(weather.toLowerCase()) {
      case "drizzle":
      case "rain":
        return "rainy.json";
      case "thunderstorm":
        return "thunderstorm.json";
      case "clouds":
        return "cloudy.json";
      case "snow": 
        return "snowy.json";
      case "smoke":
      case "haze":
      case "dust":
      case "sand":
      case "fog":
      case "ash":
      case "tornado":
      case "squall":
      case "mist":
        return "mist.json";
      case "sunny":
      default:
        return "sunny.json";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //city name
              Icon(Icons.pin_drop_sharp, color: Theme.of(context).colorScheme.onSurface),
              const SizedBox.square(dimension: 4),
              Text(_weather?.cityName.toUpperCase()?? "loading city..", style: TextStyle(fontSize: 20, color:Theme.of(context).colorScheme.onSurface),),
              const SizedBox.square(dimension: 100),
              Lottie.asset("assets/${iconState(_weather?.mainCondition)}"),
              const SizedBox.square(dimension: 100),
              //temperature
              Text("${_weather?.temperature.round().toString()}°C", style: TextStyle(fontSize: 48, color:Theme.of(context).colorScheme.onSurface))
            ],
          ),
        ),
      ),
    );
  }
}