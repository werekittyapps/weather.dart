import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/widgets/images.dart';
import 'package:weather/widgets/texts.dart';

errorCard(BuildContext context, bool curWeatherCallError) {
  return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]),),
      child: Container (
        // Белая карточка
        color: Colors.white,
        child:
        Row (
          children: [
            Expanded(
              child: Column(
                children:[
                  SizedBox(height: 48),
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
                              curWeatherCallError ? greyTextView(context, "Error", 22) : greyTextViewForForecast("Error", 22),
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
                  curWeatherCallError ?
                  Container(padding: EdgeInsets.fromLTRB(5, 0, 5, 10), child: greyTextView(context, 'город не найден', 14),)
                      : Container(padding: EdgeInsets.fromLTRB(5, 0, 5, 10), child: greyTextViewForForecast('Что-то пошло не так', 14),),
                ],
              ),
            )
          ],
        ),
      )
  );
}

currentWeatherSearchCard(BuildContext context, Map<String, dynamic> map, bool isInFavorites, Function pressButton) {
  return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]),),
      child:
      Container (
        // Белая карточка
          color: Colors.white,
          child: Row (
            children: [
              Expanded(
                child: Column(
                  children:[
                    Container(
                      alignment: Alignment(-1.0, -1.0),
                      child: IconButton(
                        icon: Icon(isInFavorites ? Icons.star : Icons.star_border),
                        onPressed: (){pressButton();},),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Город и страна
                          // Иконка
                          // Градусы
                          Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                greyTextView(context, map["name"], 22),
                                greyTextView(context, map["sys"]["country"], 12),
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
                                    child: cachedImageLoader(map["weather"][0]["icon"]),
                                  ),
                                  Container(
                                    alignment: Alignment(1.0, -1.0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: greyTextView(context, '${map["main"]["temp"].round()}°C', 24),
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
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            greyTextView(context, 'Влажность ${map["main"]["humidity"].round()}% | '
                                '${map["wind"]["deg"] == null ? "?"
                                : map["wind"]["deg"] > 337.5 || map["wind"]["deg"] < 22.5 ? "С"
                                : map["wind"]["deg"] > 22.5 && map["wind"]["deg"] < 67.5 ? "СВ"
                                : map["wind"]["deg"] > 67.5 && map["wind"]["deg"] < 112.5 ? "В"
                                : map["wind"]["deg"] > 112.5 && map["wind"]["deg"] < 157.5 ? "ЮВ"
                                : map["wind"]["deg"] > 157.5 && map["wind"]["deg"] < 202.5 ? "Ю"
                                : map["wind"]["deg"] > 202.5 && map["wind"]["deg"] < 247.5 ? "ЮЗ"
                                : map["wind"]["deg"] > 247.5 && map["wind"]["deg"] < 292.5 ? "З"
                                : "СЗ"} | ${map["wind"]["speed"].round() * 3.6} км/ч', 14),
                            greyTextView(context, '${map["main"]["temp_max"].round()}/${map["main"]["temp_min"].round()}°C', 14),
                          ],
                        )
                    ),
                  ],
                ),
              )
            ],
          )
      )
  );
}

currentWeatherFavoriteCard(BuildContext context, Map<String, dynamic> map, int i, String citiesID, Function function, bool editFlag) {

  deleteFromFavorites(String id) async {
    print("!!!!delete from favorites in card");
    print("!!!!ID $id");
    SharedPreferences getDataPrefs = await SharedPreferences.getInstance();
    if (citiesID.contains(",$id")) {
      citiesID = citiesID.replaceAll(",$id", "");
      getDataPrefs.setString('favorites', citiesID);
    } else {
      citiesID = citiesID.replaceAll("$id", "");
      if(citiesID == "") citiesID = null;
      getDataPrefs.setString('favorites', citiesID);
    }
    print("!!!!citiesID $citiesID");
    function();
  }

  press(String id){
    print("????????????press id $id");
    deleteFromFavorites(id);
  }

  return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]),),
      child:
      Container (
        // Белая карточка
          color: Colors.white,
          child: Row (
            children: [
              Expanded(
                child: Column(
                  children:[
                    editFlag ? Container(
                      alignment: Alignment(1.0, -1.0),
                      child: IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: (){press(map["list"][i]["id"].toString());},),
                    ) : SizedBox(height: 48),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Город и страна
                          // Иконка
                          // Градусы
                          Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                greyTextView(context, map["list"][i]["name"], 22),
                                greyTextView(context, map["list"][i]["sys"]["country"], 12),
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
                                    child: cachedImageLoader(map["list"][i]["weather"][0]["icon"]),
                                  ),
                                  Container(
                                    alignment: Alignment(1.0, -1.0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: greyTextView(context, '${map["list"][i]["main"]["temp"].round()}°C', 24),
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
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            greyTextView(context, 'Влажность ${map["list"][i]["main"]["humidity"].round()}% | '
                                '${map["list"][i]["wind"]["deg"] == null ? "?"
                                : map["list"][i]["wind"]["deg"] > 337.5 || map["list"][i]["wind"]["deg"] < 22.5 ? "С"
                                : map["list"][i]["wind"]["deg"] > 22.5 && map["list"][i]["wind"]["deg"] < 67.5 ? "СВ"
                                : map["list"][i]["wind"]["deg"] > 67.5 && map["list"][i]["wind"]["deg"] < 112.5 ? "В"
                                : map["list"][i]["wind"]["deg"] > 112.5 && map["list"][i]["wind"]["deg"] < 157.5 ? "ЮВ"
                                : map["list"][i]["wind"]["deg"] > 157.5 && map["list"][i]["wind"]["deg"] < 202.5 ? "Ю"
                                : map["list"][i]["wind"]["deg"] > 202.5 && map["list"][i]["wind"]["deg"] < 247.5 ? "ЮЗ"
                                : map["list"][i]["wind"]["deg"] > 247.5 && map["list"][i]["wind"]["deg"] < 292.5 ? "З"
                                : "СЗ"} | ${map["list"][i]["wind"]["speed"].round() * 3.6} км/ч', 14),
                            greyTextView(context, '${map["list"][i]["main"]["temp_max"].round()}/${map["list"][i]["main"]["temp_min"].round()}°C', 14),
                          ],
                        )
                    ),
                  ],
                ),
              )
            ],
          )
      )
  );
}

//weatherForecast(Map<String, dynamic> map){
weatherForecast(List<dynamic> first, List<dynamic> second, List<dynamic> third,
    List<dynamic> forth, List<dynamic> fifth){

  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
          child: Container (
            // Белая карточка
            color: Colors.white,
            child: Row (
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                forecastColumn(first),
                forecastColumn(second),
                forecastColumn(third),
                forecastColumn(forth),
                forecastColumn(fifth)
              ],
            )
          )
      )
  );
}

//forecastColumn(Map<String, dynamic> map, int Index){
forecastColumn(List<dynamic> list){
  return Container(
      height: 520,
      width: 80,
      child: Row(
        children: <Widget>[
          Expanded(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(child: Divider(thickness: 1, height: 1, color: Colors.grey[400],)),
                Container(
                    child: Column(
                      children: <Widget>[
                        Container(padding: EdgeInsets.fromLTRB(0, 10, 0, 5), child: greyTextViewForForecast(list[0].toString(), 14)),
                        Container(padding: EdgeInsets.only(bottom: 10), child: greyTextViewForForecast(list[1].toString(), 14)),
                      ],
                    )
                ),
                Divider(thickness: 1, height: 0, color: Colors.grey[400]),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(padding: EdgeInsets.only(bottom: 10), child: cachedImageLoader(list[2].toString()),),
                      Container(child: greyTextViewForForecast(list[3].toString().toString(), 14)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 90),
                  child: greyTextViewForForecast("${list[4]}°C", 28),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                  child: greyTextViewForForecast("${list[5]}°C", 28),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(child: cachedImageLoader(list[6].toString()),),
                      Container(padding: EdgeInsets.only(bottom: 10), child: greyTextViewForForecast(list[7].toString(), 14)),
                      Container(child: greyTextViewForForecast("давление", 14)),
                      Container(padding: EdgeInsets.only(bottom: 10), child: greyTextViewForForecast(list[8].toString(), 14)),
                    ],
                  ),
                ),
                Divider(thickness: 1, height: 0, color: Colors.grey[400])
              ],
            ),
          )
        ],
      )
  );
}

