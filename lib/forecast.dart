import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/cards.dart';
import 'package:dio/dio.dart';

class ForecastBody extends StatefulWidget {
  final String id;
  final String city;
  ForecastBody({this.id, this.city});

  @override
  createState() => new ForecastBodyState(id, city);
}


class ForecastBodyState extends State<ForecastBody> {
  final String id;
  final String city;
  ForecastBodyState(this.id, this.city);

  var _forecast; // for forecast
  bool forecastError = false;
  String forecastErrorMessage = "";

  bool isLoading = false;

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
        setState(() {
          _forecast = response.data;
          forecastError = false;
          forecastHandler();
          //isLoading = false;
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
    DateTime first;
    DateTime second;
    int beginOfSecondDay;
    DateTime third;
    int beginOfThirdDay;
    DateTime forth;
    int beginOfForthDay;
    DateTime fifth;
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

    // Обрабатываем данные первого дня
    var firstHighest;
    var firstHighState;
    var firstHighIcon;
    var firstLowest;
    var firstLowState;
    var firstLowIcon;
    var firstPressure = 0;
    for(int i = 0; i < firstList.length; i++){
      firstPressure += firstList[i]["main"]["pressure"];
      if (firstHighest == null){
        firstHighest = firstLowest = firstList[i]["main"]["temp"];
        firstHighState = firstLowState = firstList[i]["weather"][0]["main"];
        firstHighIcon = firstLowIcon = firstList[i]["weather"][0]["icon"];
      }
      if (firstHighest != null && firstList[i]["main"]["temp"] > firstHighest){
        firstHighest = firstList[i]["main"]["temp"];
        firstHighState = firstList[i]["weather"][0]["main"];
        firstHighIcon = firstList[i]["weather"][0]["icon"];

      }
      if (firstHighest != null && firstList[i]["main"]["temp"] < firstLowest){
        firstLowest = firstList[i]["main"]["temp"];
        firstLowState = firstList[i]["weather"][0]["main"];
        firstLowIcon = firstList[i]["weather"][0]["icon"];
      }
    }

    // Обрабатываем данные второго дня
    var secondHighest;
    var secondHighState;
    var secondHighIcon;
    var secondLowest;
    var secondLowState;
    var secondLowIcon;
    var secondPressure = 0;
    for(int i = 0; i < secondList.length; i++){
      secondPressure += secondList[i]["main"]["pressure"];
      if (secondHighest == null){
        print("in null sec");
       secondHighest = secondLowest = secondList[i]["main"]["temp"];
       print("temp here");
       secondHighState = secondLowState = secondList[i]["weather"][0]["main"];
       print("state here");
       secondHighIcon = secondLowIcon = secondList[i]["weather"][0]["icon"];
       print("icon here");
      }
      if (secondHighest != null && secondList[i]["main"]["temp"] > secondHighest){
        print("in high sec");
        secondHighest = secondList[i]["main"]["temp"];
        secondHighState = secondList[i]["weather"][0]["main"];
        secondHighIcon = secondList[i]["weather"][0]["icon"];

      }
      if (secondHighest != null && secondList[i]["main"]["temp"] < secondLowest){
        print("in low sec");
        secondLowest = secondList[i]["main"]["temp"];
        secondLowState = secondList[i]["weather"][0]["main"];
        secondLowIcon = secondList[i]["weather"][0]["icon"];
      }
    }

    // Обрабатываем данные третьего дня
    var thirdHighest;
    var thirdHighState;
    var thirdHighIcon;
    var thirdLowest;
    var thirdLowState;
    var thirdLowIcon;
    var thirdPressure = 0;
    for(int i = 0; i < thirdList.length; i++){
      thirdPressure += thirdList[i]["main"]["pressure"];
      if (thirdHighest == null){
        thirdHighest = thirdLowest = thirdList[i]["main"]["temp"];
        thirdHighState = thirdLowState = thirdList[i]["weather"][0]["main"];
        thirdHighIcon = thirdLowIcon = thirdList[i]["weather"][0]["icon"];
      }
      if (thirdHighest != null && thirdList[i]["main"]["temp"] > thirdHighest){
        thirdHighest = thirdList[i]["main"]["temp"];
        thirdHighState = thirdList[i]["weather"][0]["main"];
        thirdHighIcon = thirdList[i]["weather"][0]["icon"];
      }
      if (thirdHighest != null && thirdList[i]["main"]["temp"] < thirdLowest){
        thirdLowest = thirdList[i]["main"]["temp"];
        thirdLowState = thirdList[i]["weather"][0]["main"];
        thirdLowIcon = thirdList[i]["weather"][0]["icon"];
      }
    }

    // Обрабатываем данные четвертого дня
    var forthHighest;
    var forthHighState;
    var forthHighIcon;
    var forthLowest;
    var forthLowState;
    var forthLowIcon;
    var forthPressure = 0;
    for(int i = 0; i < forthList.length; i++){
      forthPressure += forthList[i]["main"]["pressure"];
      if (forthHighest == null){
        forthHighest = forthLowest = forthList[i]["main"]["temp"];
        forthHighState = forthLowState = forthList[i]["weather"][0]["main"];
        forthHighIcon = forthLowIcon = forthList[i]["weather"][0]["icon"];
      }
      if (forthHighest != null && forthList[i]["main"]["temp"] > forthHighest){
        forthHighest = forthList[i]["main"]["temp"];
        forthHighState = forthList[i]["weather"][0]["main"];
        forthHighIcon = forthList[i]["weather"][0]["icon"];
      }
      if (forthLowest != null && forthList[i]["main"]["temp"] < forthLowest){
        forthLowest = forthList[i]["main"]["temp"];
        forthLowState = forthList[i]["weather"][0]["main"];
        forthLowIcon = forthList[i]["weather"][0]["icon"];
      }
    }

    // Обрабатываем данные пятого дня
    var fifthHighest;
    var fifthHighState;
    var fifthHighIcon;
    var fifthLowest;
    var fifthLowState;
    var fifthLowIcon;
    var fifthPressure = 0;
    for(int i = 0; i < fifthList.length; i++){
      fifthPressure += fifthList[i]["main"]["pressure"];
      if (fifthHighest == null){
        fifthHighest = fifthLowest = fifthList[i]["main"]["temp"];
        fifthHighState = fifthLowState = fifthList[i]["weather"][0]["main"];
        fifthHighIcon = fifthLowIcon = fifthList[i]["weather"][0]["icon"];
      }
      if (fifthHighest != null && fifthList[i]["main"]["temp"] > fifthHighest){
        fifthHighest = fifthList[i]["main"]["temp"];
        fifthHighState = fifthList[i]["weather"][0]["main"];
        fifthHighIcon = fifthList[i]["weather"][0]["icon"];
      }
      if (fifthHighest != null && fifthList[i]["main"]["temp"] < fifthLowest){
        fifthLowest = fifthList[i]["main"]["temp"];
        fifthLowState = fifthList[i]["weather"][0]["main"];
        fifthLowIcon = fifthList[i]["weather"][0]["icon"];
      }
    }

    // Получаем среднестатистическое давление
    firstPressure = (firstPressure/firstList.length).round();
    secondPressure = (secondPressure/secondList.length).round();
    thirdPressure = (thirdPressure/thirdList.length).round();
    forthPressure = (forthPressure/forthList.length).round();
    fifthPressure = (fifthPressure/fifthList.length).round();

    firstHighest = (firstHighest).round();
    secondHighest = (secondHighest).round();
    thirdHighest = (thirdHighest).round();
    forthHighest = (forthHighest).round();
    fifthHighest = (fifthHighest).round();

    firstLowest = (firstLowest).round();
    secondLowest = (secondLowest).round();
    thirdLowest = (thirdLowest).round();
    forthLowest = (forthLowest).round();
    fifthLowest = (fifthLowest).round();

    setState(() {
      print("Bыгружаем листы");
      isLoading = false;
      firstDayData.add("Сегодня");
      firstDayData.add("${first.day}.${first.month}");
      firstDayData.add(firstHighIcon.replaceAll("n", "d"));
      firstDayData.add(firstHighState);
      firstDayData.add(firstHighest);
      firstDayData.add(firstLowest);
      firstDayData.add(firstLowIcon.replaceAll("d", "n"));
      firstDayData.add(firstLowState);
      firstDayData.add(firstPressure);

      secondDayData.add("Завтра");
      secondDayData.add("${second.day}.${second.month}");
      secondDayData.add(secondHighIcon.replaceAll("n", "d"));
      secondDayData.add(secondHighState);
      secondDayData.add(secondHighest);
      secondDayData.add(secondLowest);
      secondDayData.add(secondLowIcon.replaceAll("d", "n"));
      secondDayData.add(secondLowState);
      secondDayData.add(secondPressure);

      thirdDayData.add("${weekDay(third.weekday)}");
      thirdDayData.add("${third.day}.${third.month}");
      thirdDayData.add(thirdHighIcon.replaceAll("n", "d"));
      thirdDayData.add(thirdHighState);
      thirdDayData.add(thirdHighest);
      thirdDayData.add(thirdLowest);
      thirdDayData.add(thirdLowIcon.replaceAll("d", "n"));
      thirdDayData.add(thirdLowState);
      thirdDayData.add(thirdPressure);

      forthDayData.add("${weekDay(forth.weekday)}");
      forthDayData.add("${forth.day}.${forth.month}");
      forthDayData.add(forthHighIcon.replaceAll("n", "d"));
      forthDayData.add(forthHighState);
      forthDayData.add(forthHighest);
      forthDayData.add(forthLowest);
      forthDayData.add(forthLowIcon.replaceAll("d", "n"));
      forthDayData.add(forthLowState);
      forthDayData.add(forthPressure);

      fifthDayData.add("${weekDay(fifth.weekday)}");
      fifthDayData.add("${fifth.day}.${fifth.month}");
      fifthDayData.add(fifthHighIcon.replaceAll("n", "d"));
      fifthDayData.add(fifthHighState);
      fifthDayData.add(fifthHighest);
      fifthDayData.add(fifthLowest);
      fifthDayData.add(fifthLowIcon.replaceAll("d", "n"));
      fifthDayData.add(fifthLowState);
      fifthDayData.add(fifthPressure);

      print(fifthDayData);
    });
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
              //child: weatherForecast(_forecast),
              child: isLoading ?
              Container(alignment: Alignment(0.0,-1.0), padding: EdgeInsets.fromLTRB(0, 55, 0, 0), child: CircularProgressIndicator())
                  : forecastError? Container(height: 120, padding: EdgeInsets.fromLTRB(20, 10, 20, 0), child: errorCardForForecast())
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