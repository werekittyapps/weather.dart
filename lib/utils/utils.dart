import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

deleteForecastFromCacheUtils(String id) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('forecastFor$id', null);
}

deleteFavoriteWeatherCache(int cityPosition) async{
  var noData = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var cache = (prefs.getString('favoriteWeatherCache') ?? {
    noData = true,
  });
  if(!noData){
    var cachedWeather = json.decode(cache);
    if (cachedWeather["cnt"] != null){
      print("up ${cachedWeather["cnt"]}");
      cachedWeather["cnt"] = cachedWeather["cnt"] - 1;
      print(cachedWeather["list"][cityPosition]["name"]);
      print(cachedWeather["cnt"]);
      cachedWeather["list"].remove(cityPosition);
      if(cachedWeather["cnt"]==0) {
        cachedWeather = null;
        prefs.setString('favoriteWeatherCache', null);
        print("cnt == 0");
      } else {
        prefs.setString('favoriteWeatherCache', json.encode(cachedWeather));
        print("cnt != 0");
      }
    } else {
      prefs.setString('favoriteWeatherCache', null);
    }
  }
}

addCityToFavorite(List data, Function function) async{
  var noData = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var cache = (prefs.getString('favoriteWeatherCache') ?? {
    noData = true,
  });
  if(!noData){
    print("!nodata");
    var cachedWeather = json.decode(cache);
    if(cachedWeather["list"] != null){
      cachedWeather["list"].add(data[0]);
      cachedWeather["cnt"] = cachedWeather["cnt"] + 1;
      prefs.setString('favoriteWeatherCache', json.encode(cachedWeather));
    } else {
      Map<String,dynamic> map = {"cnt": 0, "list":[]};
      map["cnt"] = 2;
      map["list"].add(cachedWeather);
      map["list"].add(data[0]);
      prefs.setString('favoriteWeatherCache', json.encode(map));
    }
  } else {
    print("nodata");
    prefs.setString('favoriteWeatherCache', json.encode(data[0]));
  }
  function();
}

deleteFromFavoritesUtils(String id, String citiesID, Function function, int cityPosition) async {
  SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
  if (citiesID.contains(",$id")) {
    citiesID = citiesID.replaceAll(",$id", "");
  }
  if (citiesID.contains("$id,")) {
    citiesID = citiesID.replaceAll("$id,", "");
  }
  if (citiesID.contains("$id")) {
    citiesID = citiesID.replaceAll("$id", "");
    if(citiesID == "") citiesID = null;
  }
  getDataPrefs.setString('favorites', citiesID);
  deleteForecastFromCacheUtils(id);
  deleteFavoriteWeatherCache(cityPosition);
  function();
}

deleteFromFavoritesUtilsNew(String id, List data, Function function) async {
  for (int i = 0; i< data.length; i++){
    if(data[i]["id"].toString() == id) {
      print(data[i]["id"]);
      data.remove(i);
      deleteFavoriteWeatherCache(i);
      deleteForecastFromCacheUtils(id);
    }
  }
  function();
}

String dealWithDuplicated(String id){
  var list = [];
  var ids = id;
  if (id != ""){
    list = id.split(",").toList();
    if(list.length != 1 ){
      ids = "";
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

String dealWithCommas(String id){
  var ids = id;
  if (id != ""){
    if(ids[0] == ","){
      ids = ids.replaceFirst(",", "");
    }
  }
  return ids;
}


