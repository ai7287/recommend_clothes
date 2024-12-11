import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather2Page extends StatefulWidget {
  const Weather2Page({Key? key}) : super(key: key);

  @override
  _Weather2PageState createState() => _Weather2PageState();
}

class _Weather2PageState extends State<Weather2Page> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherInfo = "지역명을 입력하세요";
  double? _temperature;
  int? _humidity;
  double? _windSpeed;
  String? _weatherIcon;

  final String apiKey = "8d39f57ae0fc27f728280148a1111911";

  Future<void> _fetchWeatherData(String city) async {
    final String encodedCity = Uri.encodeComponent(city);
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$encodedCity&appid=$apiKey&units=metric&lang=kr";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = data['main']['temp'];
          _humidity = data['main']['humidity'];
          _windSpeed = data['wind']['speed'];
          _weatherInfo = data['weather'][0]['description'];
          _weatherIcon =
              "http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png";
        });
      } else {
        setState(() {
          _weatherInfo = "날씨 데이터를 불러오지 못했습니다: '$city'";
          _weatherIcon = null;
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = "오류 발생: $e";
        _weatherIcon = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.wb_sunny, color: Colors.black, size: 28),
            SizedBox(width: 8),
            Text(
              "Search Weather",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "지역명을 입력하세요",
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _fetchWeatherData(value);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  _fetchWeatherData(_cityController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "날씨 확인",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: _temperature == null
                    ? Text(
                        _weatherInfo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_weatherIcon != null)
                            Image.network(
                              _weatherIcon!,
                              width: 100,
                              height: 100,
                            ),
                          const SizedBox(height: 16),
                          Text(
                            "${_temperature!.toStringAsFixed(1)}°C",
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
                                    "습도",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.air,
                                      size: 40, color: Colors.white),
                                  Text(
                                    "${_windSpeed!.toStringAsFixed(1)} m/s",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "풍속",
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
              ),
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  _fetchWeatherData(_cityController.text);
                }
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              iconSize: 32,
            ),
          ],
        ),
      ),
    );
  }
}
