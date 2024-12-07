import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  // "250d1b732b72e1efcbeb850fea7dec0e"

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http
        .get(Uri.parse("$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric"));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<void> permissionLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<List<double>> getCurrentCity() async {
    //get permission from user
    await permissionLocation();

    //fetch current location
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100
    );
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings);


    List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placeMark[0].subLocality;
    print(city);

    return [position.latitude, position.longitude];
  }
}
