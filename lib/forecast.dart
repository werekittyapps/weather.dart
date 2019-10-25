import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/cards.dart';
import 'package:dio/dio.dart';

class ForecastBody extends StatefulWidget {
  final String id;
  ForecastBody({this.id});

  @override
  createState() => new ForecastBodyState(id);
}


class ForecastBodyState extends State<ForecastBody> {
  final String id;
  ForecastBodyState(this.id);

  var _forecast; // for forecast
  bool forecastError = false;
  String forecastErrorMessage = "";

  currentWeatherForFavorites(String id) async {
    print("current wheater for favorites");
    //setState(() {
    //  isLoading = true;
    //});
    try {
      Response response = await Dio().get("https://api.openweathermap.org/data/2.5/forecast?id=$id&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c");
      debugPrint("favorites weather response ${response.statusCode}");
      if(response.statusCode == 200) {
        setState(() {
          _forecast = response.data;
          forecastError = false;
          //isLoading = false;
        });
      }
      if(response.statusCode == 400) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Некорректный запрос";
          //isLoading = false;
        });
      }
      if(response.statusCode == 404) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Такого города не найдено";
          //isLoading = false;
        });
      }
      if(response.statusCode == 429) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Исчерпан лимит запросов";
          //isLoading = false;
        });
      }
      if(response.statusCode == 500) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Internal Server Error: ошибка соединения с сервером";
          //isLoading = false;
        });
      }
      if(response.statusCode == 503) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Сервер недоступен";
          //isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        forecastError = true;
        forecastErrorMessage = "Ошибка запроса: проверьте подключение";
        //isLoading = false;
      });
    }
  }

  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        //appBar:
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: weatherForecast(_forecast),
            ),
            new Positioned(
              top: 0.0, left: 0.0, right: 0.0,
              child: AppBar(
                title: Text('Forecast'),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            )
          ],
        )
    );
  }

}