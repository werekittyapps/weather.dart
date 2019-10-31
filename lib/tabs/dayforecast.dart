import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:weather/widgets/cards.dart';
import 'package:weather/widgets/charts.dart';


class DayForecast extends StatefulWidget {
  final String id;
  final String city;
  final bool caching;

  const DayForecast({Key key, this.id, this.city, this.caching}) : super(key: key);

  @override
  DayForecastState createState() => DayForecastState(id, city, caching);
}

class DayForecastState extends State<DayForecast> {
  final String id;
  final String city;
  final bool caching;

  DayForecastState(this.id, this.city, this.caching);

  var _forecast; // for forecast
  bool forecastError = false;
  bool isLoading = false;

  DateTime first;

  List dayList = [];
  List<double> tempList = [];

  weatherForecastCall(String id) async {
    checkInternet();
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          "https://api.openweathermap.org/data/2.5/forecast?id=$id&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c");
      debugPrint("forecast response ${response.statusCode}");
      if (response.statusCode == 200) {
        if (caching) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var data = response.data;
          prefs.setString('forecastFor$id', json.encode(data));
        }
        setState(() {
          _forecast = response.data;
          forecastError = false;
          forecastHandler();
        });
      }
      if (response.statusCode == 400 || response.statusCode == 404 ||
          response.statusCode == 429 || response.statusCode == 500 ||
          response.statusCode == 503) {
        // 400 - "Некорректный запрос"
        // 404 - "Такого города не найдено"
        // 429 - "Исчерпан лимит запросов"
        // 500 - "Internal Server Error: ошибка соединения с сервером"
        // 503 - "Сервер недоступен"
        getCachedForecast();
      }
    } catch (e) {
      print(e);
      getCachedForecast();
    }
  }

  getCachedForecast() async {
    var noData = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cache = (prefs.getString('forecastFor$id') ?? {
      forecastError = true,
      noData = true,
    });
    if (!noData) {
      _forecast = json.decode(cache);
      setState(() {
        forecastHandler();
      });
    }
    setState(() {
      forecastError = forecastError;
      isLoading = false;
    });
  }

  forecastHandler() {
    // Выделяем лист данных дню
    for (int i = 0; i < 9; i++) {
      var weeky = DateTime.parse(_forecast["list"][i]["dt_txt"]);
      dayList.add("${weeky.hour}:00");
      tempList.add(_forecast["list"][i]["main"]["temp"].toDouble());
    }
    setState(() {
      forecastError = forecastError;
      isLoading = false;
    });
  }

  checkInternet() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
    } else {
      Toast.show("Не удалось подключиться к сети", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }


  void initState() {
    weatherForecastCall(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading ?
      Container(alignment: Alignment(0.0,-1.0), padding: EdgeInsets.fromLTRB(0, 55, 0, 0), child: CircularProgressIndicator())
          : forecastError?
      ListView.builder(
          itemCount: 1,
          itemBuilder: (context, i){
            return new ListTile(
                title: Container(height: 170, padding: EdgeInsets.fromLTRB(20, 10, 20, 0), child: errorCard(context, false))
            );
          })
          : Container(alignment: Alignment(0.0, -1.0), child:
      Card(child: Container(height: 400, child: SelectionCallbackExample.withSampleData(_forecast),),)
    ));
  }
}