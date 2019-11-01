import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/forecasts.dart';
import 'package:weather/utils/utils.dart';
import 'package:weather/widgets/cards.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class WeatherBody extends StatefulWidget {

@override
createState() => new WeatherBodyState();
}

class WeatherBodyState extends State<WeatherBody> {
  var _weatherData = [];
  var _weatherGeoData = [];
  var _weatherSearchData = [];

  // Geolocation
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  // Flags
  bool isConnected = false;
  bool noFavoriteCache = false;
  bool isLoading = false;

  bool geoCallError = false;
  bool favoriteCallError = false;
  bool searchCallError = false;

  bool searchFlag = false;
  bool editFlag = false;

  // For search bar
  Widget _appBarTitle = new Text( 'Weather' );
  Icon _searchIcon = new Icon(Icons.add);
  final TextEditingController _filter = new TextEditingController();

  weatherCall(String url, List outputList, bool errorFlag) async {
    if (isConnected) {
      setState(() {
        isLoading = true;
      });
      try {
        Response response = await Dio().get(url);
        debugPrint("response ${response.statusCode}");
        if (response.statusCode == 200) {
          var data = response.data;

          if (url.contains("group")) {
            // for favorites
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('favoriteWeatherCache', json.encode(data));
            for (int i = 0; i < data["list"].length; i++) {
              outputList.add(data["list"][i]);
            }
            print(outputList);
          } else {
            outputList.add(data);
          }
          setState(() {
            errorFlag = false;
            isLoading = false;
          });
        }
        else {
          // 400 - "Некорректный запрос"
          // 404 - "Такого города не найдено"
          // 429 - "Исчерпан лимит запросов"
          // 500 - "Internal Server Error: ошибка соединения с сервером"
          // 503 - "Сервер недоступен"
          setState(() {
            errorFlag = true;
            isLoading = false;
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          errorFlag = true;
          isLoading = false;
        });
      }
    }
  }

  isInFavorites(String id){
    bool isIn = false;
    if(_weatherData.isNotEmpty) {
      for(int i = 0; i < _weatherData.length; i++){
        if (_weatherData[i]["id"] == id){
          isIn = true;
        }
      }
    }
    return isIn;
  }

  pressStarButtonSearch() {
    setState(() {
      if(isInFavorites(_weatherSearchData[0]["id"].toString())) deleteFromFavoritesUtilsNew(_weatherSearchData[0]["id"].toString(), _weatherData, getCached);
      else addCityToFavorite(_weatherSearchData[0]);
      isInFavorites(_weatherSearchData[0]["id"].toString());
    });
  }

  pressStarButton() {
    setState(() {
      if(isInFavorites(_weatherGeoData[0]["id"].toString())) {
        deleteFromFavoritesUtilsNew(_weatherGeoData[0]["id"].toString(), _weatherData, getCached);
        getCached();
      } else {
        addCityToFavorite(_weatherGeoData);
        getCached();
      }
      isInFavorites(_weatherGeoData[0]["id"].toString());
    });
  }

  searching(){
    setState(() {
      if (this._searchIcon.icon == Icons.add) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...',),
          onSubmitted: (value) {
            String city = value.trim().replaceAll(" ", "%20").replaceAll("\n", "");
            if(city.isNotEmpty) {
              String url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=7fe8b89a7579b408a6997d47eb97164c&units=metric";
              weatherCall(url, _weatherSearchData, searchCallError);
            }
          },
        );
      } else {
        if(!editFlag){
          this._searchIcon = new Icon(Icons.add);
          this._appBarTitle = new Text('Weather');
          searchFlag = false;
          _filter.clear();
          getCached();
        }
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
        //if(!isConnected) getCached();
      });
    }
  }

  getCachedWeather() async{
    var noData = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cache = (prefs.getString('favoriteWeatherCache') ?? {
      print("no cache"),
      noData = true,
    });
    if(!noData){
      var data = json.decode(cache);
      if(data["list"] != null){
        for (int i = 0; i < data["list"].length; i++){
          _weatherData.add(data["list"][i]);
          print("get all cached");
        }
      } else {
        print("get one first added");
        _weatherData.add(data);
      }
    }
    setState(() {
      if(noData) noFavoriteCache = true;
      else{
        noFavoriteCache = false;
        _weatherData = _weatherData;
      }
    });
  }

  getLocation(){
    geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      String url = "https://api.openweathermap.org/data/2.5/weather?lat=${ _currentPosition.latitude}&lon=${_currentPosition.longitude}&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c";
      weatherCall(url, _weatherGeoData, geoCallError);
    }).catchError((e) {
      print(e);
    });
  }

  getCached() async{
    if(checkInternet() != null) {
      if(!isConnected) {
        getCachedWeather();
      }
      else{
        getLocation();
        // call geo weather
        //// if error Container()
        getCachedWeather();
        if(_weatherData.isNotEmpty){
          String citiesID = "";
          for(int i = 0; i < _weatherData.length; i++){
            if(i == 0) citiesID = _weatherData[i]["id"].toString();
            else citiesID += ",${_weatherData[i]["id"].toString()}";
          }
          String url = "https://api.openweathermap.org/data/2.5/group?id=$citiesID&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c";
          weatherCall(url, _weatherData, favoriteCallError);
        }
        // call ids from cache
        //// if error/no cache Container()
        //// else call favorite weather
      }
    }
  }

  deleteCache() async{
    SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
    getDataPrefs.clear();
  }

  Future<bool> checkInternet() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      isConnected = true;
    } else {
      isConnected = false;
      Toast.show("Не удалось подключиться к сети", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
    return isConnected;
  }

  @override
  void initState() {
    if(checkInternet() != null) getCached();
    //isConnected = true;
    //getCached();
    //print(isConnected);
    //deleteCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0), child: Container(),),
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
                              itemCount: _weatherData.length,
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(child: searchCallError? errorCard(context, searchCallError) : weatherCard(context, _weatherSearchData, i, null, false, false, true, isInFavorites(_weatherSearchData[0]["id"].toString()), pressStarButtonSearch),),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastsBody(id: _weatherSearchData[0]["id"].toString(), city: _weatherSearchData[0]["name"].toString(), caching: false,))),
                                );
                              }),
                        ),
                      ),
                    ]) :
                // If we not searching, we must show favorite cards currentWeatherCard
                Column (
                    children: [
                      Expanded (
                        child: Container (
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child:
                              !isConnected ?
                                  noFavoriteCache? Container()
                                  : // Если нет соединения, но есть кэш фаворитов, показываем фаворитов
                                  ListView.builder(
                                      itemCount: _weatherData.length,
                                      itemBuilder: (context, i){
                                        return new ListTile(
                                          title: Container(
                                              child: weatherCard(context, _weatherData, i, getCached, false, false, false, null, null) // card of favs
                                          ),
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastsBody(id: _weatherData[0]["id"].toString(), city: _weatherData[0]["name"].toString(), caching: false,))),
                                          onLongPress: () => startEditing(),
                                        );
                              })
                                  : // Если есть соединение
                                  editFlag ? // edit
                                  _weatherData.isEmpty ? Container()
                                  :
                                  ListView.builder(
                                      itemCount: _weatherData.length,
                                      itemBuilder: (context, i){
                                        return new ListTile(
                                            title: Container(
                                                child:
                                                weatherCard(context, _weatherData, i, getCached, true, false, false, null, null)
                                            ),
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastsBody(id: _weatherData[0]["id"].toString(), city: _weatherData[0]["name"].toString(), caching: false,)))
                                        );
                                      })
                                  :
                                  _weatherGeoData.isNotEmpty && _weatherData.isNotEmpty ? Container() :
                              ListView.builder(
                                  itemCount: _weatherGeoData.isNotEmpty && _weatherData.isNotEmpty? _weatherGeoData.length + _weatherData.length
                                      : _weatherGeoData.isEmpty && _weatherData.isNotEmpty? _weatherData.length : _weatherGeoData.isNotEmpty && _weatherData.isEmpty? 1 : 0,
                                  itemBuilder: (context, i){
                                    return new ListTile(
                                        title: Container(
                                            child:
                                            geoCallError || _weatherGeoData.isEmpty ? !noFavoriteCache? weatherCard(context, _weatherData, i, getCached, false, false, false, null, null) : Container()
                                            : _weatherGeoData.isNotEmpty && i == 0 ? weatherCard(context, _weatherGeoData, 0, getCached, false, true, false, isInFavorites(_weatherGeoData[0]["id"].toString()), pressStarButton)
                                            : weatherCard(context, _weatherData, i-1, getCached, false, false, false, null, null)
                                        ),
                                          onTap: () => geoCallError ? Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastsBody(id: _weatherData[i]["id"].toString(), city: _weatherData[i]["name"].toString(), caching: true,)))
                                          : i == 0 ? Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastsBody(id: _weatherGeoData[0]["id"].toString(), city: _weatherGeoData[0]["name"].toString(), caching: false,)))
                                          : Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastsBody(id: _weatherData[i -1]["id"].toString(), city: _weatherData[i-1]["name"].toString(), caching: true,))),
                                        onLongPress: () => startEditing(),
                                    );
                                  })
                          ,))
                    ],
                )
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
            ),
          ],
        )
    );
  }
}