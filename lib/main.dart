import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(
      new MaterialApp(
          debugShowCheckedModeBanner: false,// скрываем надпись debug
          home: WeatherBody()
      )
  );
}