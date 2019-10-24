import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(
      new MaterialApp(
          debugShowCheckedModeBanner: false,// скрываем надпись debug
          theme: ThemeData(
            primarySwatch: Colors.grey,
            //primarySwatch: Colors.grey,
            //brightness: Brightness.dark,
            //primaryColorLight: Colors.grey[800],
            //cardColor: Colors.grey[800],
            //primaryColorDark: Colors.grey[800],
            secondaryHeaderColor: Colors.grey[800],
            //textSelectionColor: Colors.grey[800],
            //cursorColor: Colors.grey[800],
            //textSelectionHandleColor: Colors.grey[800],
            //backgroundColor: Colors.grey[800],
            //dialogBackgroundColor:Colors.grey[800],
            indicatorColor: Colors.grey[800],
            hintColor: Colors.grey[800],
            //errorColor: Colors.grey[800],
            //primaryColor: Colors.grey[800],
            accentColor: Colors.grey[800],
      ),
          home: WeatherBody()
      )
  );
}