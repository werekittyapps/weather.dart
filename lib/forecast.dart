import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/cards.dart';
import 'package:dio/dio.dart';

class ForecastBody extends StatefulWidget {
  final String id;
  final String city;
  final bool caching;
  ForecastBody({this.id, this.city, this.caching});

  @override
  createState() => new ForecastBodyState(id, city, caching);
}


class ForecastBodyState extends State<ForecastBody> {
  final String id;
  final String city;
  final bool caching;
  ForecastBodyState(this.id, this.city, this.caching);

  var _forecast; // for forecast
  bool forecastError = false;
  String forecastErrorMessage = "";

  bool isLoading = false;

  DateTime first;
  DateTime second;
  DateTime third;
  DateTime forth;
  DateTime fifth;

  List<dynamic> firstDayData = [];
  List<dynamic> secondDayData = [];
  List<dynamic> thirdDayData = [];
  List<dynamic> forthDayData = [];
  List<dynamic> fifthDayData = [];

  weatherForecastCall(String id) async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get("https://api.openweathermap.org/data/2.5/forecast?id=$id&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c");
      debugPrint("forecast response ${response.statusCode}");
      if(response.statusCode == 200) {
        //if (caching){
        //  print("caching forecast");
        //  SharedPreferences prefs = await SharedPreferences.getInstance();
        //  prefs.setString('forecastFor$id', response.data);
        //}
        setState(() {
          _forecast = response.data;
          forecastError = false;
          forecastHandler();

        });
      }
      if(response.statusCode == 400) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Некорректный запрос";
          isLoading = false;
        });
      }
      if(response.statusCode == 404) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Такого города не найдено";
          isLoading = false;
        });
      }
      if(response.statusCode == 429) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Исчерпан лимит запросов";
          isLoading = false;
        });
      }
      if(response.statusCode == 500) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Internal Server Error: ошибка соединения с сервером";
          isLoading = false;
        });
      }
      if(response.statusCode == 503) {
        setState(() {
          forecastError = true;
          forecastErrorMessage = "Сервер недоступен";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        forecastError = true;
        forecastErrorMessage = "Ошибка запроса: проверьте подключение";
        isLoading = false;
      });
    }
  }

  forecastHandler(){
    int beginOfSecondDay;
    int beginOfThirdDay;
    int beginOfForthDay;
    int beginOfFifthDay;
    List list = _forecast["list"];
    List firstList = [];
    List secondList = [];
    List thirdList = [];
    List forthList = [];
    List fifthList = [];

    // разбиваем прогноз по дням
    for (int i = 0; i < list.length; i++){
      var weeky = DateTime.parse(list[i]["dt_txt"]);
      if(i == 0){
        first = weeky;
      }
      if(first != null && second == null && third == null && forth == null && fifth == null){
        if (weeky.day != first.day){
          second = weeky;
          beginOfSecondDay = i;
        }
      }
      if(first != null && second != null && third == null && forth == null && fifth == null){
        if (weeky.day != second.day){
          third = weeky;
          beginOfThirdDay = i;
        }
      }
      if(first != null && second != null && third != null && forth == null && fifth == null){
        if (weeky.day != third.day){
          forth = weeky;
          beginOfForthDay = i;
        }
      }
      if(first != null && second != null && third != null && forth != null && fifth == null){
        if (weeky.day != forth.day){
          fifth = weeky;
          beginOfFifthDay = i;
        }
      }
    }

    // Выделяем листы данных каждому дню
    for(int i = 0; i < beginOfSecondDay; i++){
      firstList.add(list[i]);
    }
    for(int i = beginOfSecondDay; i < beginOfThirdDay; i++){
      secondList.add(list[i]);
    }
    for(int i = beginOfThirdDay; i < beginOfForthDay; i++){
      thirdList.add(list[i]);
    }
    for(int i = beginOfForthDay; i < beginOfFifthDay; i++){
      forthList.add(list[i]);
    }
    for(int i = beginOfFifthDay; i < beginOfFifthDay + 8; i++){
      fifthList.add(list[i]);
    }

    setState(() {
      print("Bыгружаем листы");
      isLoading = false;
      forecastHelper(first, firstList, firstDayData);
      forecastHelper(second, secondList, secondDayData);
      forecastHelper(third, thirdList, thirdDayData);
      forecastHelper(forth, forthList, forthDayData);
      forecastHelper(fifth, fifthList, fifthDayData);
    });
  }

  forecastHelper(DateTime day, List listInput, List listOutput){
    var highest;
    var highState;
    var highIcon;
    var lowest;
    var lowState;
    var lowIcon;
    var pressure = 0;
    for(int i = 0; i < listInput.length; i++){
      pressure += listInput[i]["main"]["pressure"];
      if (highest == null){
        highest = lowest = listInput[i]["main"]["temp"];
        highState = lowState = listInput[i]["weather"][0]["main"];
        highIcon = lowIcon = listInput[i]["weather"][0]["icon"];
      }
      if (highest != null && listInput[i]["main"]["temp"] > highest){
        highest = listInput[i]["main"]["temp"];
        highState = listInput[i]["weather"][0]["main"];
        highIcon = listInput[i]["weather"][0]["icon"];
      }
      if (highest != null && listInput[i]["main"]["temp"] < lowest){
        lowest = listInput[i]["main"]["temp"];
        lowState = listInput[i]["weather"][0]["main"];
        lowIcon = listInput[i]["weather"][0]["icon"];
      }
    }
    pressure = (pressure/listInput.length).round();
    highest = (highest).round();
    lowest = (lowest).round();

    if(day == first) listOutput.add("Сегодня");
    if(day == second) listOutput.add("Завтра");
    if(day != first && day != second) listOutput.add("${weekDay(day.weekday)}");
    listOutput.add("${day.day}.${day.month}");
    listOutput.add(highIcon.replaceAll("n", "d"));
    listOutput.add(highState);
    listOutput.add(highest);
    listOutput.add(lowest);
    listOutput.add(lowIcon.replaceAll("d", "n"));
    listOutput.add(lowState);
    listOutput.add(pressure);
  }

  String weekDay(int index){
    if (index == 1) return "Пн";
    if (index == 2) return "Вт";
    if (index == 3) return "Ср";
    if (index == 4) return "Чт";
    if (index == 5) return "Пт";
    if (index == 6) return "Сб";
    return "Вс";
  }

  void initState() {
    weatherForecastCall(id);
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
              child: isLoading ?
              Container(alignment: Alignment(0.0,-1.0), padding: EdgeInsets.fromLTRB(0, 55, 0, 0), child: CircularProgressIndicator())
                  : forecastError? Container(height: 120, padding: EdgeInsets.fromLTRB(20, 10, 20, 0), child: errorCard(context, false))
                  : weatherForecast(firstDayData, secondDayData, thirdDayData, forthDayData, fifthDayData),
            ),
            new Positioned(
              top: 0.0, left: 0.0, right: 0.0,
              child: AppBar(
                title: Text('$city'),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            )
          ],
        )
    );
  }

}