import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/images.dart';
import 'package:weather/widgets/texts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WeatherBody extends StatefulWidget {

@override
createState() => new WeatherBodyState();
}

class WeatherBodyState extends State<WeatherBody> {
  var _currentWeather;
  var _currentWeatherForFavorits;
  List<String> favCities = [];
  String citiesID = "";

  // For search bar
  Widget _appBarTitle = new Text( 'Weather' );
  Icon _searchIcon = new Icon(Icons.add);
  final TextEditingController _filter = new TextEditingController();

  // Flags
  bool searchFlag = false;
  bool isLoading = false;
  bool curWeatherCallError = false;
  bool curWeatherCallErrorForFavorits = false;
  String curWeatherCallErrorMessage = "";
  String curWeatherCallErrorMessageForFavorits = "";

  currentWeather(String city) async {
    try {
      Response response = await Dio().get("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=7fe8b89a7579b408a6997d47eb97164c&units=metric");
      debugPrint("current weather response ${response.statusCode}");
      if(response.statusCode == 200) {
        _currentWeather = response.data;
        setState(() {
          curWeatherCallError = false;
          searchFlag = true;
        });
      }
      if(response.statusCode == 400) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Некорректный запрос";
          searchFlag = true;
        });
      }
      if(response.statusCode == 404) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Такого города не найдено";
          searchFlag = true;
        });
      }
      if(response.statusCode == 429) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Исчерпан лимит запросов";
          searchFlag = true;
        });
      }
      if(response.statusCode == 500) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Internal Server Error: ошибка соединения с сервером";
          searchFlag = true;
        });
      }
      if(response.statusCode == 503) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Сервер недоступен";
          searchFlag = true;
        });
      }
    } catch (e) {
      setState(() {
        curWeatherCallError = true;
        curWeatherCallErrorMessage = "Ошибка запроса: проверьте подключение";
        searchFlag = true;
      });
    }
  }

  currentWeatherForFavorits(String listOfID) async {
    //String listOfID = "";
    //for(int i = 0; i < favCities.length; i++){
    //  if (i != favCities.length){
    //    listOfID += "${favCities[i]},";
    //  } else {
    //    listOfID += "${favCities[i]}";
    //  }
    //}
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get("https://api.openweathermap.org/data/2.5/group?id=$listOfID&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c");
      debugPrint("favorits weather response ${response.statusCode}");
      if(response.statusCode == 200) {
        setState(() {
          _currentWeatherForFavorits = response.data;
          curWeatherCallErrorForFavorits = false;
          isLoading = false;
        });
      }
      if(response.statusCode == 400) {
        setState(() {
          curWeatherCallErrorForFavorits = true;
          curWeatherCallErrorMessageForFavorits = "Некорректный запрос";
          isLoading = false;
        });
      }
      if(response.statusCode == 404) {
        setState(() {
          curWeatherCallErrorForFavorits = true;
          curWeatherCallErrorMessageForFavorits = "Такого города не найдено";
          isLoading = false;
        });
      }
      if(response.statusCode == 429) {
        setState(() {
          curWeatherCallErrorForFavorits = true;
          curWeatherCallErrorMessageForFavorits = "Исчерпан лимит запросов";
          isLoading = false;
        });
      }
      if(response.statusCode == 500) {
        setState(() {
          curWeatherCallErrorForFavorits = true;
          curWeatherCallErrorMessageForFavorits = "Internal Server Error: ошибка соединения с сервером";
          isLoading = false;
        });
      }
      if(response.statusCode == 503) {
        setState(() {
          curWeatherCallErrorForFavorits = true;
          curWeatherCallErrorMessageForFavorits = "Сервер недоступен";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        curWeatherCallErrorForFavorits = true;
        curWeatherCallErrorMessageForFavorits = "Ошибка запроса: проверьте подключение";
        isLoading = false;
      });
    }
  }

  getCached() async{
    var noData = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorsID = (prefs.getString('favorits') ?? {
      print("No favorites"),
      noData = true
    });
    if(!noData){
      citiesID = favorsID;
      print(citiesID);
      currentWeatherForFavorits(citiesID);
    }
  }

  searching(){
    setState(() {
      if (this._searchIcon.icon == Icons.add) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
            controller: _filter,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.add),
              hintText: 'Search...',),
          onSubmitted: (value) {
              String city = value.trim().replaceAll(" ", "%20").replaceAll("\n", "");
              if(city.isNotEmpty) currentWeather(city);
              },
            );
      } else {
        this._searchIcon = new Icon(Icons.add);
        this._appBarTitle = new Text('Weather');
        searchFlag = false;
        _filter.clear();
        getCached();
      }
    });
  }

  addToFavorits(String id) async {
    SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
    print(id);
    if (citiesID != ""){
      citiesID += ",$id";
      getDataPrefs.setString('favorits', citiesID);
    } else {
      citiesID = "$id";
      getDataPrefs.setString('favorits', citiesID);
    }
    //favCities.add(id);
    //getDataPrefs.setStringList('favorits', favCities);

  }

  deleteCache() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print('deleted');
  }

  @override
  void initState() {
    getCached();
    //deleteCache();
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
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child:
                searchFlag ? // Если сделали запрос и пришло [200]
                Column (
                    children: [
                      Expanded (
                        child: Container (
                              child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]),),
                                    child:
                                    curWeatherCallError? // Если сделали запрос и пришла ошибка
                                    Container (
                                      // Белая карточка
                                        color: Colors.white,
                                        child:
                                        Row (
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children:[
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment(-1.0, -1.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              greyTextView(context, "Error", 22),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                    child: Divider(
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                                    child: greyTextView(context, 'город не найден', 14),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                    )
                                        :
                                    Container (
                                      // Белая карточка
                                        color: Colors.white,
                                        child: Row (
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children:[
                                                  // Верхняя часть: Город, страна, иконка и градусы
                                                  // Нижняя часть: дополнительные фичи
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        // Город и страна
                                                        // Иконка
                                                        // Градусы
                                                        Container(
                                                          alignment: Alignment(-1.0, -1.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              greyTextView(context, _currentWeather["name"], 22),
                                                              greyTextView(context, _currentWeather["sys"]["country"], 12),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <Widget>[
                                                                Container(
                                                                  alignment: Alignment(1.0, -1.0),
                                                                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                                                                  //child: Icon(Icons.cloud),
                                                                  child: cachedImageLoader(_currentWeather["weather"][0]["icon"]),
                                                                ),
                                                                Container(
                                                                  alignment: Alignment(1.0, -1.0),
                                                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                                  child: greyTextView(context, '${_currentWeather["main"]["temp"].round()}°C', 24),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                    child: Divider(
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                                    child: clickableGreyTextView(context, 'дополнительные функции', 14),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                  onTap: curWeatherCallError? null : () =>  addToFavorits(_currentWeather["id"].toString()),
                                );
                              }),
                        ),
                      ),
                    ]) :
                // If we not searching, we must show favorite cards
                Column (
                    children: [
                      Expanded (
                        child: Container (
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child:
                          _currentWeatherForFavorits == null ? Container() :
                          isLoading ?
                          Container(
                            alignment: Alignment(0.0,-1.0),
                            padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
                            child: CircularProgressIndicator(),
                          )
                              :
                          ListView.builder(
                              itemCount: _currentWeatherForFavorits["cnt"],
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]),),
                                    child:
                                    curWeatherCallErrorForFavorits? // Если сделали запрос и пришла ошибка
                                    Container (
                                      // Белая карточка
                                      color: Colors.white,
                                      child:
                                      Row (
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children:[
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment(-1.0, -1.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            greyTextView(context, "Error", 22),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                  child: Divider(
                                                    thickness: 1,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                                  child: greyTextView(context, 'город не найден', 14),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                        :
                                    Container (
                                      // Белая карточка
                                        color: Colors.white,
                                        child: Row (
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children:[
                                                  // Верхняя часть: Город, страна, иконка и градусы
                                                  // Нижняя часть: дополнительные фичи
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        // Город и страна
                                                        // Иконка
                                                        // Градусы
                                                        Container(
                                                          alignment: Alignment(-1.0, -1.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              greyTextView(context, _currentWeatherForFavorits["list"][i]["name"], 22),
                                                              greyTextView(context, _currentWeatherForFavorits["list"][i]["sys"]["country"], 12),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <Widget>[
                                                                Container(
                                                                  alignment: Alignment(1.0, -1.0),
                                                                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                                                                  //child: Icon(Icons.cloud),
                                                                  child: cachedImageLoader(_currentWeatherForFavorits["list"][i]["weather"][0]["icon"]),
                                                                ),
                                                                Container(
                                                                  alignment: Alignment(1.0, -1.0),
                                                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                                  child: greyTextView(context, '${_currentWeatherForFavorits["list"][i]["main"]["temp"].round()}°C', 24),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                    child: Divider(
                                                      thickness: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                                    child: clickableGreyTextView(context, 'дополнительные функции', 14),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                  //onTap: curWeatherCallError? null : () =>  addToFavorits(_currentWeather["id"]),
                                );
                              }),
                        ),
                      ),
                    ])
            ),
            new Positioned(
              top: 0.0, left: 0.0, right: 0.0,
              child: AppBar(
                title: _appBarTitle,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: _searchIcon,
                    color: Colors.grey[800],
                    onPressed: () {
                      searching();
                      },
                  ),],
              ),
            )
          ],
        )
    );
  }
}