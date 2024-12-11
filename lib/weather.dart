import 'package:flutter/material.dart';
import 'recommendpage.dart';
import 'login.dart';
import 'auth_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather2.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  double _temperature = 0.0;
  int _humidity = 0;
  double _windSpeed = 0.0;
  String _weatherInfo = "Loading weather data...";
  final String apiKey = "8d39f57ae0fc27f728280148a1111911";
  final double latitude = 36.6017;
  final double longitude = 127.2982;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=kr";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = data['main']['temp'];
          _humidity = data['main']['humidity'];
          _windSpeed = data['wind']['speed'];
          _weatherInfo = data['weather'][0]['description'];
        });
      } else {
        setState(() {
          _weatherInfo = "Failed to load weather data.";
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = "Error: $e";
      });
    }
  }

  Map<String, dynamic> _getWeatherImageWithSize(String description) {
    if (description.contains("rain") || description.contains("비")) {
      return {
        'path': 'assets/rain.png',
        'width': 250.0,
        'height': 250.0,
      };
    } else if (description.contains("cloud") || description.contains("구름")) {
      return {
        'path': 'assets/main_cloud.png',
        'width': 120.0,
        'height': 120.0,
      };
    } else if (description.contains("clear") || description.contains("맑음")) {
      return {
        'path': 'assets/sun.png',
        'width': 150.0,
        'height': 150.0,
      };
    } else if (description.contains("snow") || description.contains("눈")) {
      return {
        'path': 'assets/snow.png',
        'width': 130.0,
        'height': 130.0,
      };
    } else {
      return {
        'path': 'assets/default_weather.png',
        'width': 150.0,
        'height': 150.0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherImage = _getWeatherImageWithSize(_weatherInfo);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // 흰색 배경
        elevation: 0, // 그림자 제거
        centerTitle: true, // 제목 가운데 정렬
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wb_sunny, // 햇살 아이콘
              color: Colors.black,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              "Today's Weather",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.black,
            tooltip: "로그아웃",
            onPressed: () {
              context.read<AuthService>().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "조치원읍",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Weather2Page()),
                        );
                      },
                      child: const Icon(Icons.location_on, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: weatherImage['height'],
                        width: weatherImage['width'],
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(weatherImage['path']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        "${_temperature.toStringAsFixed(1)}°C",
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _weatherInfo,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.water_drop,
                            size: 40, color: Colors.white),
                        Text(
                          "$_humidity%",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Humidity",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.air, size: 40, color: Colors.white),
                        Text(
                          "${_windSpeed.toStringAsFixed(1)} m/s",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Wind Speed",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecommendPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    "오늘의 드레스코드",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () {
                    _fetchWeatherData();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
