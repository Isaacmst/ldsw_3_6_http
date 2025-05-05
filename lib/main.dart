import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String? errorMessage;

  
  final String apiKey = 'bd60db2f448ec8ee18c289e41da52df9';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=20.659698&lon=-103.349609&units=metric&appid=$apiKey',
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al obtener datos: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LDSW 3.6 - OpenWeatherMap'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() 
            : errorMessage != null
                ? Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nombre de la ciudad
                      Text(
                        'Ciudad: ${weatherData!['name']}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Temperatura
                      Text(
                        'Temperatura: ${weatherData!['main']['temp']} °C',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      // Descripción del clima
                      Text(
                        'Clima: ${weatherData!['weather'][0]['description']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      // Icono del clima
                      Image.network(
                        'https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
      ),
    );
  }
}
