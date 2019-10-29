import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/forecast.dart';
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

  // For search bar
  Widget _appBarTitle = new Text( 'Weather' );
  Icon _searchIcon = new Icon(Icons.add);
  final TextEditingController _filter = new TextEditingController();

  // Flags
  bool noFavorites = true;
  bool searchFlag = false;
  bool isLoading = false;
  bool editFlag = false;
  bool curWeatherCallError = false;
  bool curWeatherCallErrorForFavorites = false;
  String curWeatherCallErrorMessage = "";
  String curWeatherCallErrorMessageForFavorites = "";


  currentWeather(String city) async {
    print("current wheater");
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=7fe8b89a7579b408a6997d47eb97164c&units=metric");
      debugPrint("current weather response ${response.statusCode}");
      if(response.statusCode == 200) {
        _currentWeather = response.data;
        setState(() {
          curWeatherCallError = false;
          searchFlag = true;
          isLoading = false;
        });
      }
      if(response.statusCode == 400) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Некорректный запрос";
          searchFlag = true;
          isLoading = false;
        });
      }
      if(response.statusCode == 404) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Такого города не найдено";
          searchFlag = true;
          isLoading = false;
        });
      }
      if(response.statusCode == 429) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Исчерпан лимит запросов";
          searchFlag = true;
          isLoading = false;
        });
      }
      if(response.statusCode == 500) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Internal Server Error: ошибка соединения с сервером";
          searchFlag = true;
          isLoading = false;
        });
      }
      if(response.statusCode == 503) {
        setState(() {
          curWeatherCallError = true;
          curWeatherCallErrorMessage = "Сервер недоступен";
          searchFlag = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        curWeatherCallError = true;
        curWeatherCallErrorMessage = "Ошибка запроса: проверьте подключение";
        searchFlag = true;
        isLoading = false;
      });
    }
  }

  currentWeatherForFavorites(String listOfID) async {
    print("current wheater for favorites");
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get("https://api.openweathermap.org/data/2.5/group?id=$listOfID&units=metric&appid=7fe8b89a7579b408a6997d47eb97164c");
      debugPrint("favorites weather response ${response.statusCode}");
      if(response.statusCode == 200) {
        setState(() {
          _currentWeatherForFavorites = response.data;
          print(_currentWeatherForFavorites["cnt"]);
          curWeatherCallErrorForFavorites = false;
          isLoading = false;
        });
      }
      if(response.statusCode == 400) {
        setState(() {
          curWeatherCallErrorForFavorites = true;
          curWeatherCallErrorMessageForFavorites = "Некорректный запрос";
          isLoading = false;
        });
      }
      if(response.statusCode == 404) {
        setState(() {
          curWeatherCallErrorForFavorites = true;
          curWeatherCallErrorMessageForFavorites = "Такого города не найдено";
          isLoading = false;
        });
      }
      if(response.statusCode == 429) {
        setState(() {
          curWeatherCallErrorForFavorites = true;
          curWeatherCallErrorMessageForFavorites = "Исчерпан лимит запросов";
          isLoading = false;
        });
      }
      if(response.statusCode == 500) {
        setState(() {
          curWeatherCallErrorForFavorites = true;
          curWeatherCallErrorMessageForFavorites = "Internal Server Error: ошибка соединения с сервером";
          isLoading = false;
        });
      }
      if(response.statusCode == 503) {
        setState(() {
          curWeatherCallErrorForFavorites = true;
          curWeatherCallErrorMessageForFavorites = "Сервер недоступен";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        curWeatherCallErrorForFavorites = true;
        curWeatherCallErrorMessageForFavorites = "Ошибка запроса: проверьте подключение";
        isLoading = false;
      });
    }
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
      citiesID = dealWithDuplicated(citiesID);
      prefs.setString('favorites', citiesID);
      print("citiesID: $citiesID");
      currentWeatherForFavorites(citiesID);
    }
    print(noData);
    setState(() {
      noFavorites = noFavorites;
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

  deleteFromFavorites(String id) async {
    print("delete from favorites");
    SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
    if (citiesID.contains("$id,")) {
      citiesID = citiesID.replaceAll("$id,", "");
      getDataPrefs.setString('favorites', citiesID);
    } else {
      citiesID = null;
      getDataPrefs.setString('favorites', citiesID);
      print(citiesID);
    }
  }
  
  isInFavorites(String id){
    if (citiesID != null && citiesID.contains("$id")) return true;
    return false;
  }

  pressButton() {
    setState(() {
      if(isInFavorites(_currentWeather["id"].toString())) deleteFromFavorites(_currentWeather["id"].toString());
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

  String dealWithDuplicated(String id){
    print("deal with dublicated");
    var list = [];
    var ids = id;
    if (id != ""){
      list = id.split(",").toList();
      if(list.length != 1 ){
        ids = "";
        print(ids);
        for(int i = 0; i < list.length - 1; i++) {
          for (int j = i + 1; j < list.length; j++) {
            if (list[i] == list[j]) {
              list.removeAt(j);
              j = j - 1;
            }
          }
        }
      }
    }
    if(id != "" && list != null && list.length != 1){
      for(int i = 0; i < list.length; i++) {
        if(list.length - i > 1){
          ids += "${list[i]},";
        } else {
          ids += list[i];
        }
      }
    }
    return ids;
  }

  deleteCache() async{
    SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
    getDataPrefs.clear();
  }


  @override
  void initState() {
    //getCached();
    deleteCache();

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
                              child: isLoading ?
                              Container(alignment: Alignment(0.0,-1.0), padding: EdgeInsets.fromLTRB(0, 55, 0, 0), child: CircularProgressIndicator(),)
                                  :
                              ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(child: curWeatherCallError? errorCard(context) : currentWeatherSearchCardWithBtn(context, _currentWeather, isInFavorites(_currentWeather["id"].toString()), pressButton),),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastBody(id: _currentWeather["id"].toString(), city: _currentWeather["name"].toString()))),
                                //)
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
                                  title: Container(child: curWeatherCallErrorForFavorites? errorCard(context): editFlag ? currentWeatherSearchCardWithDeleteBtn(context,_currentWeatherForFavorites, i, citiesID, getCached) : currentWeatherFavoriteCard(context,_currentWeatherForFavorites, i)),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastBody(id: _currentWeatherForFavorites["list"][i]["id"].toString(), city: _currentWeatherForFavorites["list"][i]["name"].toString()))),
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