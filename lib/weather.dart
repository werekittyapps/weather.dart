import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/texts.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherBody extends StatefulWidget {

@override
createState() => new WeatherBodyState();
}

class WeatherBodyState extends State<WeatherBody> {
  //List _originalArray = [];
  //List _filteredArray = [];
  var _currentWeather;

  // For search bar
  Widget _appBarTitle = new Text( 'Weather' );
  Icon _searchIcon = new Icon(Icons.search);
  final TextEditingController _filter = new TextEditingController();

  // Flags
  bool searchFlag = false;
  bool curWeatherCallError = false;
  String curWeatherCallErrorMessage = "";

  //getCitiesId() async {
  //  String data = await DefaultAssetBundle.of(context).loadString("assets / cities / city . list . json");
  //  var cities = json.decode(data);
  //  print(cities.length);
  //  print(cities[1]);
  //  print(cities[1]["coord"]["lon"]);
  //}

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
        });
      }
      if(response.statusCode == 404) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Такого города не найдено";
        });
      }
      if(response.statusCode == 429) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Исчерпан лимит запросов";
        });
      }
      if(response.statusCode == 500) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Internal Server Error: ошибка соединения с сервером";
        });
      }
      if(response.statusCode == 503) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Сервер недоступен";
        });
      }
    } catch (e) {
      setState(() {
        curWeatherCallError = true;
        curWeatherCallErrorMessage = "Ошибка запроса: проверьте подключение";
      });
    }
  }

  searching(){
    //getCached(); get list from cache or internet
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        //searchFlag = true;
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
            controller: _filter,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...',),
          onSubmitted: (value) {
              String city = value.trim().replaceAll(" ", "%20").replaceAll("\n", "");
              if(city.isNotEmpty) currentWeather(city);
              },
            );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Weather');
        searchFlag = false;
        _filter.clear();
      }
    });
  }

  cachedImageLoader(String icon){
    return CachedNetworkImage(
      imageUrl: "https://openweathermap.org/img/wn/$icon@2x.png",
      width: 60.0, height: 60.0, fit: BoxFit.cover,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  @override
  void initState() {
    //getCitiesId();
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
                padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: searchFlag ?
                // If we searching
                Column (
                    children: [
                      Expanded (
                        child: Container (
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child:
                          ListView.builder(
                              itemCount: 1,//_filteredArray.length,
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey[400]
                                      ),
                                    ),
                                    child: curWeatherCallError?
                                    Container (
                                      // Белая карточка
                                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        height: 120,
                                        width: 400,
                                        color: Colors.white,
                                        child: Row (
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children:[
                                                  // Верхняя часть: Город, страна, иконка и градусы
                                                  // Нижняя часть: дополнительные фичи
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                                        )
                                    )
                                        :
                                    Container (
                                      // Белая карточка
                                      //padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                                    child: greyTextView(context, 'дополнительные функции', 14),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ]) :
                // If we not searching, we must show favorite cards
                Container()
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                title: _appBarTitle,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: _searchIcon,
                    color: Colors.grey[800],
                    onPressed: () {
                      print("pressed");
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