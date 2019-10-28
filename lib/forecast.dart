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

  bool isLoading = false;

  List<dynamic> firstDayData = [];
  List<dynamic> secondDayData = [];
  List<dynamic> thirdDayData = [];
  List<dynamic> forthDayData = [];
  List<dynamic> fifthDayData = [];

  weatherForecastCall(String id) async {
    print("forecast");
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get("https://api.openweathermap.org/data/2.5/forecast?id=$id&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c");
      debugPrint("forecast response ${response.statusCode}");
      if(response.statusCode == 200) {
        setState(() {
          _forecast = response.data;
          print("sobaka");
          forecastError = false;
          print("sobaka");
          forecastHandler();
          print("sobaka");
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
    print("sobaka");
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

    print("forecast handler");

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

    print("sobaka");

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

    print("sobaka");

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

    print("after first");

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

    print("after fors");


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

    print("after pressure");

    //print("1 day: ${first.day} ${weekDay(first.weekday)} 0 and list size ${firstList.length}");
    //print("2 day: ${second.day} ${weekDay(second.weekday)} $beginOfSecondDay and list size ${secondList.length}"
    //    "temp: $secondHighest/$secondLowest icons: $secondHighIcon/$secondLowIcon "
    //    "states: $secondHighState/$secondLowState pressure: $secondPressure");
    //print("3 day: ${third.day} ${weekDay(third.weekday)} $beginOfThirdDay and list size ${thirdList.length}"
    //    "temp: $thirdHighest/$thirdLowest icons: $thirdHighIcon/$thirdLowIcon "
    //    "states: $thirdHighState/$thirdLowState pressure: $thirdPressure");
    //print("4 day: ${forth.day} ${weekDay(forth.weekday)} $beginOfForthDay and list size ${forthList.length}"
    //    "temp: $forthHighest/$forthLowest icons: $forthHighIcon/$forthLowIcon "
    //    "states: $forthHighState/$forthLowState pressure: $forthPressure");
    //print("5 day: ${fifth.day} ${weekDay(fifth.weekday)} $beginOfFifthDay and list size ${fifthList.length}"
    //    "temp: $fifthHighest/$fifthLowest icons: $fifthHighIcon/$fifthLowIcon "
    //    "states: $fifthHighState/$fifthLowState pressure: $fifthPressure");

    //firstDayData[0] = "Сегодня";
    //firstDayData[1] = "${first.day}.${first.month}";
    //firstDayData[2] = firstHighIcon.replaceAll("d", "n");
    //firstDayData[3] = firstHighState;
    //firstDayData[4] = firstHighest;
    //firstDayData[5] = firstLowest;
    //firstDayData[6] = firstLowIcon.replaceAll("d", "n");
    //firstDayData[7] = firstLowState;
    //firstDayData[8] = firstPressure;
    //
    //secondDayData[0] = "Завтра";
    //secondDayData[1] = "${second.day}.${second.month}";
    //secondDayData[2] = secondHighIcon.replaceAll("d", "n");
    //secondDayData[3] = secondHighState;
    //secondDayData[4] = secondHighest;
    //secondDayData[5] = secondLowest;
    //secondDayData[6] = secondLowIcon.replaceAll("d", "n");
    //secondDayData[7] = secondLowState;
    //secondDayData[8] = secondPressure;
//
    //thirdDayData[0] = "${weekDay(third.weekday)}";
    //thirdDayData[1] = "${third.day}.${third.month}";
    //thirdDayData[2] = thirdHighIcon.replaceAll("d", "n");
    //thirdDayData[3] = thirdHighState;
    //thirdDayData[4] = thirdHighest;
    //thirdDayData[5] = thirdLowest;
    //thirdDayData[6] = thirdLowIcon.replaceAll("d", "n");
    //thirdDayData[7] = thirdLowState;
    //thirdDayData[8] = thirdPressure;
//
    //forthDayData[0] = "${weekDay(forth.weekday)}";
    //forthDayData[1] = "${forth.day}.${forth.month}";
    //forthDayData[2] = forthHighIcon.replaceAll("d", "n");
    //forthDayData[3] = forthHighState;
    //forthDayData[4] = forthHighest;
    //forthDayData[5] = forthLowest;
    //forthDayData[6] = forthLowIcon.replaceAll("d", "n");
    //forthDayData[7] = forthLowState;
    //forthDayData[8] = forthPressure;
//
    //fifthDayData[0] = "${weekDay(fifth.weekday)}";
    //fifthDayData[1] = "${fifth.day}.${fifth.month}";
    //fifthDayData[2] = fifthHighIcon.replaceAll("d", "n");
    //fifthDayData[3] = fifthHighState;
    //fifthDayData[4] = fifthHighest;
    //fifthDayData[5] = fifthLowest;
    //fifthDayData[6] = fifthLowIcon.replaceAll("d", "n");
    //fifthDayData[7] = fifthLowState;
    //fifthDayData[8] = fifthPressure;

    //secondDayData[0] = "${weekDay(first.weekday)}";

    //I/flutter ( 2535): 1 day: 28 Пн 0 and list size 4
    //I/flutter ( 2535): 2 day: 29 Вт 4 and list size 8temp: 8.73/4.7 icons: 04d/01n states: Clouds/Clear pressure: 1024
    //I/flutter ( 2535): 3 day: 30 Ср 12 and list size 8temp: 7.52/1.42 icons: 01d/01d states: Clear/Clear pressure: 1030
    //I/flutter ( 2535): 4 day: 31 Чт 20 and list size 8temp: 7.79/0.26 icons: 01d/01d states: Clear/Clear pressure: 1027
    //I/flutter ( 2535): 5 day: 1 Пт 28 and list size 8temp: 8.02/0.08 icons: 04d/04d states: Clouds/Clouds pressure: 1019

    setState(() {
      print("зыгружаем листы");
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
                  //: forecastError? errorCard(context)
                  : weatherForecast(firstDayData, secondDayData, thirdDayData, forthDayData, fifthDayData),
              //: Container()
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