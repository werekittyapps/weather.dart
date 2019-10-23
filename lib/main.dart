import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(
      new MaterialApp(
          debugShowCheckedModeBanner: false,// скрываем надпись debug
          theme: ThemeData(
          primarySwatch: Colors.grey,
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.grey[800]),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.grey[800]),
            ),
      ),
          home: WeatherBody()
      )
  );
}