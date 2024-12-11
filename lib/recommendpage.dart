import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendPage extends StatefulWidget {
  const RecommendPage({Key? key}) : super(key: key);

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  double _temperature = 0.0;
  double _feelsLike = 0.0;
  String _weatherInfo = "Loading...";
  String _dailyTemperatureMessage = "";
  String _forecastMessage6PM = ""; // 오후 6시 메시지
  String _forecastMessage9PM = ""; // 오후 9시 메시지
  String _weatherWarningMessage = ""; // 날씨 경고 메시지
  final String apiKey = "8d39f57ae0fc27f728280148a1111911";
  final double latitude = 36.6017;
  final double longitude = 127.2982;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _fetchForecastData();
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
          _feelsLike = data['main']['feels_like'];
          _weatherInfo = data['weather'][0]['description'];
          _dailyTemperatureMessage = _getDailyTemperatureMessage(
            tempMax: data['main']['temp_max'],
            tempMin: data['main']['temp_min'],
          );
          _weatherWarningMessage =
              _getWeatherWarning(data['weather'][0]['main']);
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

  Future<void> _fetchForecastData() async {
    final String url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=kr";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final now = DateTime.now();
        final forecast6PM = _findClosestForecast(data['list'], now, 18);
        final forecast9PM = _findClosestForecast(data['list'], now, 21);

        setState(() {
          _forecastMessage6PM =
              "오후 6시 예상 기온: ${forecast6PM.toStringAsFixed(1)}°C";
          _forecastMessage9PM =
              "오후 9시 예상 기온: ${forecast9PM.toStringAsFixed(1)}°C";
        });
      }
    } catch (e) {
      setState(() {
        _forecastMessage6PM = "오후 6시 예보 데이터를 가져올 수 없습니다.";
        _forecastMessage9PM = "오후 9시 예보 데이터를 가져올 수 없습니다.";
      });
    }
  }

  double _findClosestForecast(
      List<dynamic> forecasts, DateTime now, int targetHour) {
    final targetTime = DateTime(now.year, now.month, now.day, targetHour);
    final closest = forecasts.reduce((a, b) {
      final timeA = DateTime.parse(a['dt_txt']);
      final timeB = DateTime.parse(b['dt_txt']);
      return (timeA.difference(targetTime).abs() <
              timeB.difference(targetTime).abs())
          ? a
          : b;
    });

    return closest['main']['temp'];
  }

  String _getDailyTemperatureMessage(
      {required double tempMax, required double tempMin}) {
    double difference = tempMax - tempMin;
    if (difference < 5) {
      return "오늘의 일교차는 크지 않습니다.";
    } else if (difference < 10) {
      return "오늘은 약간의 일교차가 있습니다.";
    } else {
      return "오늘은 일교차가 큽니다! 외투를 준비하세요.";
    }
  }

  String _getWeatherWarning(String weatherMain) {
    if (weatherMain.contains("Rain")) {
      return "오늘 폭우가 예상됩니다. 우산을 챙기세요.";
    } else if (weatherMain.contains("Snow")) {
      return "오늘 눈이 내릴 예정입니다. 따뜻한 옷차림을 하세요.";
    } else if (weatherMain.contains("Thunderstorm")) {
      return "천둥번개가 예상됩니다. 외출 시 주의하세요.";
    } else {
      return ""; // 경고가 필요하지 않은 경우
    }
  }

  List<Map<String, String>> _getClothingRecommendations(double feelsLike) {
    if (feelsLike < 0) {
      return [
        {'image': 'assets/clothes/0_1.png', 'text': '두꺼운 패딩'},
        {'image': 'assets/clothes/0_2.png', 'text': '기모 바지'},
      ];
    } else if (feelsLike >= 0 && feelsLike <= 5) {
      return [
        {'image': 'assets/clothes/0_4degree_1.png', 'text': '패딩'},
        {'image': 'assets/clothes/0_4degree_4.png', 'text': '목도리'},
        {'image': 'assets/clothes/0_4degree_2.png', 'text': '두꺼운 스웨터'},
        {'image': 'assets/clothes/0_4degree_3.png', 'text': '방한 장갑'}
      ];
    } else if (feelsLike > 5 && feelsLike <= 11) {
      return [
        {'image': 'assets/clothes/5_10degree_1.png', 'text': '자켓'},
        {'image': 'assets/clothes/5_10degrxee_2.png', 'text': '니트'},
        {'image': 'assets/clothes/5_10degree_3.png', 'text': '코트'}
      ];
    } else if (feelsLike > 11 && feelsLike <= 15) {
      return [
        {'image': 'assets/clothes/10_14degree_1.png', 'text': '얇은 자켓'},
        {'image': 'assets/clothes/10_14degree_2.png', 'text': '스웨터'},
        {'image': 'assets/clothes/10_14degree_3.png', 'text': '셔츠'}
      ];
    } else if (feelsLike > 15 && feelsLike <= 20) {
      return [
        {'image': 'assets/clothes/15_19degree_1.png', 'text': '가벼운 자켓'},
        {'image': 'assets/clothes/15_19degree_2.png', 'text': '반팔 티셔츠'},
      ];
    } else if (feelsLike > 20 && feelsLike <= 24) {
      return [
        {'image': 'assets/clothes/20_24degree_1.png', 'text': '얇은 셔츠'},
        {'image': 'assets/clothes/20_24degree_2.png', 'text': '가디건'},
        {'image': 'assets/clothes/20_24degree_3.png', 'text': '면바지'}
      ];
    } else {
      return [
        {'image': 'assets/clothes/25degree_1.png', 'text': '반팔티'},
        {'image': 'assets/clothes/25degree_2.png', 'text': '반바지'},
        {'image': 'assets/clothes/25degree_3.png', 'text': '원피스'}
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> clothingRecommendations =
        _getClothingRecommendations(_feelsLike);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.checkroom,
              color: Colors.black,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              "Today's Dresscode",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    "현재온도: ${_temperature.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "추천 의류",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: clothingRecommendations.map((recommendation) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.asset(
                                recommendation['image']!,
                                width: 100,
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recommendation['text']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32), // 아래 빈 공간을 채우기 위해 간격 추가
                  Text(
                    "체감온도: ${_feelsLike.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _forecastMessage6PM,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _forecastMessage9PM,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _dailyTemperatureMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_weatherWarningMessage.isNotEmpty)
                    Text(
                      _weatherWarningMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
