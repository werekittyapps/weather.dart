import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/forecast.dart';
import 'package:weather/utils/utils.dart';
import 'package:weather/widgets/cards.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WeatherBody extends StatefulWidget {

@override
createState() => new WeatherBodyState();
}

class WeatherBodyState extends State<WeatherBody> {
  var _currentWeather; // for search
  var _currentWeatherForFavorites; // for life
  String citiesID = "";
  int cityPosition;

  // For search bar
  Widget _appBarTitle = new Text( 'Weather' );
  Icon _searchIcon = new Icon(Icons.add);
  final TextEditingController _filter = new TextEditingController();

  // Flags
  bool noFavorites = true;
  bool searchFlag = false;
  bool inSearchFlag = false;
  bool isLoading = false;
  bool editFlag = false;
  bool curWeatherCallError = false;
  bool curWeatherCallErrorForFavorites = false;

  weatherCall(String cities, bool inSearchFlag) async {
    print("wheater call");
    setState(() {
      isLoading = true;
    });
    try {
      Response response;
      if(inSearchFlag){
        response = await Dio().get("https://api.openweathermap.org/data/2.5/weather?q=$cities&appid=7fe8b89a7579b408a6997d47eb97164c&units=metric");
      } else {
        response = await Dio().get("https://api.openweathermap.org/data/2.5/group?id=$cities&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c");
      }
      debugPrint("response ${response.statusCode}");
      if(response.statusCode == 200) {
        if(inSearchFlag) {
          setState(() {
            _currentWeather = response.data;
            curWeatherCallError = false;
            searchFlag = true;
            isLoading = false;
          });
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var data = response.data;
          prefs.setString('favoriteWeatherCache', json.encode(data));
          setState(() {
            _currentWeatherForFavorites = response.data;
            curWeatherCallErrorForFavorites = false;
            isLoading = false;
          });
        }
      }
      if(response.statusCode == 400 || response.statusCode == 404 ||
          response.statusCode == 429 || response.statusCode == 500 ||
          response.statusCode == 503) {
        // 400 - "Некорректный запрос"
        // 404 - "Такого города не найдено"
        // 429 - "Исчерпан лимит запросов"
        // 500 - "Internal Server Error: ошибка соединения с сервером"
        // 503 - "Сервер недоступен"
        setState(() {
          if(inSearchFlag) {
            curWeatherCallError = true;
            searchFlag = true;
          } else {
            getCachedWeather();
          }
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        if(inSearchFlag) {
          curWeatherCallError = true;
          searchFlag = true;
        } else {
          getCachedWeather();
        }
        isLoading = false;
      });
    }
  }

  getCachedWeather() async{
    var noData = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cache = (prefs.getString('favoriteWeatherCache') ?? {
      curWeatherCallErrorForFavorites = true,
      print("No cached favorite weather"),
      noData = true,
    });
    if(!noData){
      setState(() {
        _currentWeatherForFavorites = json.decode(cache);
      });
    }
    setState(() {
      curWeatherCallErrorForFavorites = curWeatherCallErrorForFavorites;
    });
  }

  getCached() async{
    print("get cached");
    var noData = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorsID = (prefs.getString('favorites') ?? {
      citiesID = null,
      print("No favorites"),
      noFavorites = true,
      noData = true,
    });
    if(!noData){
      noFavorites = false;
      citiesID = favorsID;
      citiesID = dealWithCommas(citiesID);
      citiesID = dealWithDuplicated(citiesID);
      prefs.setString('favorites', citiesID);
      print("citiesID: $citiesID");
      weatherCall(citiesID, inSearchFlag);
    }
    print(noData);
    setState(() {
      noFavorites = noFavorites;
    });
  }

  searching(){
    setState(() {
      if (this._searchIcon.icon == Icons.add) {
        inSearchFlag = true;
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
            controller: _filter,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...',),
          onSubmitted: (value) {
              String city = value.trim().replaceAll(" ", "%20").replaceAll("\n", "");
              if(city.isNotEmpty) weatherCall(city, inSearchFlag);
              },
            );
      } else {
        this._searchIcon = new Icon(Icons.add);
        this._appBarTitle = new Text('Weather');
        inSearchFlag = false;
        searchFlag = false;
        _filter.clear();
        getCached();
      }
    });
  }

  startEditing(){
    setState(() {
      editFlag = true;
      this._searchIcon = new Icon(Icons.close);
      this._appBarTitle = new Text( 'Editing...' );
    });
  }

  closeEditing(){
    if (editFlag) {
      setState(() {
        this._searchIcon = new Icon(Icons.add);
        this._appBarTitle = new Text('Weather');
        editFlag = false;
        getCached();
      });
    }
  }
  
  isInFavorites(String id){
    bool isIn = false;
    if(citiesID != null) {
      List list = [];
      list = citiesID.split(",").toList();
      for(int i = 0; i < list.length; i++){
        if (list[i] == id){
          cityPosition = i;
          isIn = true;
        }
      }
    }
    return isIn;
  }

  //isInFavorites(String id){
  //  if (citiesID != null && citiesID.contains("$id")) return true;
  //  return false;
  //}

  pressButton() {
    setState(() {
      if(isInFavorites(_currentWeather["id"].toString())) deleteFromFavoritesUtils(_currentWeather["id"].toString(), citiesID, getCached, cityPosition);
      else addToFavorites(_currentWeather["id"].toString());
      isInFavorites(_currentWeather["id"].toString());
    });
  }

  addToFavorites(String id) async {
    if(citiesID==null) citiesID = "";
    print("add to favorites");
    SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
    if (citiesID != ""){
      citiesID += ",$id";
      getDataPrefs.setString('favorites', citiesID);
    } else {
      citiesID = "$id";
      getDataPrefs.setString('favorites', citiesID);
    }
  }

  deleteCache() async{
    SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
    getDataPrefs.clear();
  }

  @override
  void initState() {
    getCached();
    //deleteCache();
    //getLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
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
                              child: isLoading ?
                              Container(alignment: Alignment(0.0,-1.0), padding: EdgeInsets.fromLTRB(0, 55, 0, 0), child: CircularProgressIndicator(),)
                                  :
                              ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(child: curWeatherCallError? errorCard(context, curWeatherCallError) : currentWeatherSearchCard(context, _currentWeather, isInFavorites(_currentWeather["id"].toString()), pressButton),),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastBody(id: _currentWeather["id"].toString(), city: _currentWeather["name"].toString(), caching: false,))),
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
                          noFavorites ?
                          Container() // Если нет избранных карт показываем пустой контейнер
                              :
                          isLoading ?
                          Container(alignment: Alignment(0.0,-1.0), padding: EdgeInsets.fromLTRB(0, 55, 0, 0), child: CircularProgressIndicator(),)
                              :
                          ListView.builder(
                              itemCount: _currentWeatherForFavorites["cnt"],
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(child: curWeatherCallErrorForFavorites? errorCard(context, curWeatherCallError): currentWeatherFavoriteCard(context,_currentWeatherForFavorites, i, citiesID, getCached,  editFlag)),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastBody(id: _currentWeatherForFavorites["list"][i]["id"].toString(), city: _currentWeatherForFavorites["list"][i]["name"].toString(), caching: true,))),
                                  onLongPress: () => startEditing(),
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
                      closeEditing();
                      },
                  ),],
              ),
            )
          ],
        )
    );
  }
}