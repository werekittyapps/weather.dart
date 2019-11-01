import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/utils/utils.dart';
import 'package:weather/widgets/forecastchart.dart';
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

currentWeatherCard(BuildContext context, Map<String, dynamic> map, int index, String citiesID, Function function, bool editFlag, bool isItGeoCard, bool searchFlag, bool isInFavorites, Function pressButton) {
var tempList = ["С", "СВ", "В", "ЮВ", "Ю", "ЮЗ", "З", "СЗ"];
  press(String id){
    deleteFromFavoritesUtils(id, citiesID, function, index);
  }

  getText(double val){
    if(val > 337.5 ||val < 22.5) return tempList[0];
    if(val > 22.5 &&val < 67.5 ) return tempList[1];
    if(val > 67.5 &&val < 112.5) return tempList[2];
    if(val > 112.5 &&val < 157.5) return tempList[3];
    if(val > 157.5 &&val < 202.5) return tempList[4];
    if(val > 202.5 &&val < 247.5) return tempList[5];
    if(val > 247.5 &&val < 292.5) return tempList[6];
    return tempList[7];
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
                    searchFlag ?
                    Container(
                      alignment: Alignment(-1.0, -1.0),
                      child: IconButton(
                        icon: Icon(isInFavorites ? Icons.star : Icons.star_border),
                        onPressed: (){pressButton();},),
                    ) :
                    editFlag ?
                    Container(
                      alignment: Alignment(1.0, -1.0),
                      child: IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: (){press(map["list"][index]["id"].toString());},),
                    ) : isItGeoCard ?
                    Container(
                        alignment: Alignment(-1.0, -1.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(isInFavorites ? Icons.star : Icons.star_border),
                              onPressed: (){pressButton();},),
                            greyTextView(context, "Текущее местоположение", 14)
                          ],
                        )
                    )
                        : SizedBox(height: 48),
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
                                isItGeoCard ?
                                Container(
                                  width: 150,
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: greyAutoSizedTextView(context, map["name"], 18),
                                      ),
                                      Icon(Icons.place, color: Colors.grey[800]),
                                    ],
                                  ),
                                )
                                    : searchFlag ? Container(width: 140, child: greyAutoSizedTextView(context, map["name"], 18))
                                    : Container(width: 140, child: greyAutoSizedTextView(context, map["list"][index]["name"], 18)),
                                isItGeoCard ? map["sys"] == null ? greyTextView(context, "empty", 12) : greyTextView(context, map["sys"]["country"], 12)
                                    : searchFlag? greyTextView(context, map["sys"]["country"], 12)
                                    : greyTextView(context, map["list"][index]["sys"]["country"], 12),
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
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: isItGeoCard || searchFlag ? cachedImageLoader(map["weather"][0]["icon"], 60.0)
                                        : cachedImageLoader(map["list"][index]["weather"][0]["icon"], 60.0),
                                  ),
                                  Container(
                                    alignment: Alignment(1.0, -1.0),
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: isItGeoCard || searchFlag ? greyTextView(context, '${map["main"]["temp"].round()}°C', 24)
                                        : greyTextView(context, '${map["list"][index]["main"]["temp"].round()}°C', 24),
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
                        child:
                        isItGeoCard || searchFlag ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            greyTextView(context, 'Влажность ${map["main"]["humidity"].round()}% | '
                                '${map["wind"]["deg"] == null ? "?" : getText(map["wind"]["deg"])} | ${map["wind"]["speed"].round() * 3.6} км/ч', 14),
                            greyTextView(context, '${map["main"]["temp_max"].round()}/${map["main"]["temp_min"].round()}°C', 14),
                          ],
                        ) :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            greyTextView(context, 'Влажность ${map["list"][index]["main"]["humidity"].round()}% | '
                                '${map["list"][index]["wind"]["deg"] == null ? "?"
                                : map["list"][index]["wind"]["deg"] > 337.5 || map["list"][index]["wind"]["deg"] < 22.5 ? "С"
                                : map["list"][index]["wind"]["deg"] > 22.5 && map["list"][index]["wind"]["deg"] < 67.5 ? "СВ"
                                : map["list"][index]["wind"]["deg"] > 67.5 && map["list"][index]["wind"]["deg"] < 112.5 ? "В"
                                : map["list"][index]["wind"]["deg"] > 112.5 && map["list"][index]["wind"]["deg"] < 157.5 ? "ЮВ"
                                : map["list"][index]["wind"]["deg"] > 157.5 && map["list"][index]["wind"]["deg"] < 202.5 ? "Ю"
                                : map["list"][index]["wind"]["deg"] > 202.5 && map["list"][index]["wind"]["deg"] < 247.5 ? "ЮЗ"
                                : map["list"][index]["wind"]["deg"] > 247.5 && map["list"][index]["wind"]["deg"] < 292.5 ? "З"
                                : "СЗ"} | ${map["list"][index]["wind"]["speed"].round() * 3.6} км/ч', 14),
                            greyTextView(context, '${map["list"][index]["main"]["temp_max"].round()}/${map["list"][index]["main"]["temp_min"].round()}°C', 14),
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

weatherCard(BuildContext context, List data, int index, Function function, bool editFlag, bool geoCard, bool searchCard, bool isInFavorites, Function pressButton) {

  press(String id){
    deleteFromFavoritesUtilsNew(id, data, function);
  }
  var tempList = ["С", "СВ", "В", "ЮВ", "Ю", "ЮЗ", "З", "СЗ"];
  getWind(int val){
    if(val > 337.5 ||val < 22.5) return tempList[0];
    if(val > 22.5 &&val < 67.5 ) return tempList[1];
    if(val > 67.5 &&val < 112.5) return tempList[2];
    if(val > 112.5 &&val < 157.5) return tempList[3];
    if(val > 157.5 &&val < 202.5) return tempList[4];
    if(val > 202.5 &&val < 247.5) return tempList[5];
    if(val > 247.5 &&val < 292.5) return tempList[6];
    return tempList[7];
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
                    searchCard?
                    Container(
                      alignment: Alignment(-1.0, -1.0),
                      child: IconButton(
                        icon: Icon(isInFavorites ? Icons.star : Icons.star_border),
                        onPressed: (){pressButton();},),
                    ) :
                    editFlag ?
                    Container(
                      alignment: Alignment(1.0, -1.0),
                      child: IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: (){press(data[index]["id"].toString());},),
                    ) :
                    geoCard ?
                    Container(
                        alignment: Alignment(-1.0, -1.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(isInFavorites ? Icons.star : Icons.star_border),
                              onPressed: (){pressButton();},),
                            greyTextView(context, "Текущее местоположение", 14)
                          ],
                        )
                    )
                        :
                    SizedBox(height: 48),
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
                                geoCard ?
                                Container(
                                  width: 150,
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: greyAutoSizedTextView(context, data[index]["name"], 18),
                                      ),
                                      Icon(Icons.place, color: Colors.grey[800]),
                                    ],
                                  ),
                                )
                                    : Container(width: 140, child: greyAutoSizedTextView(context, data[index]["name"], 18)),
                                geoCard ? data[index]["sys"] == null ? greyTextView(context, "empty", 12) : greyTextView(context, data[index]["sys"]["country"], 12)
                                    : greyTextView(context, data[index]["sys"]["country"], 12),
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
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: cachedImageLoader(data[index]["weather"][0]["icon"], 60.0),
                                  ),
                                  Container(
                                    alignment: Alignment(1.0, -1.0),
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: greyTextView(context, '${data[index]["main"]["temp"].round()}°C', 24),
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
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            greyTextView(context, 'Влажность ${data[index]["main"]["humidity"].round()}% | '
                                '${data[index]["wind"]["deg"] == null ? "?" : getWind(data[index]["wind"]["deg"].round())} | ${data[index]["wind"]["speed"].round() * 3.6} км/ч', 14),
                            greyTextView(context, '${data[index]["main"]["temp_max"].round()}/${data[index]["main"]["temp_min"].round()}°C', 14),
                          ],
                        )
                    )
                  ],
                )
              ),
            ],
          ),
      )
  );
}

weatherForecast(List<dynamic> first, List<dynamic> second, List<dynamic> third,
    List<dynamic> forth, List<dynamic> fifth, List<int> Lows, List<int> Highs, List<DateTime> Times) {

  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Container (
              // Белая карточка
                height: 580,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        forecastHighColumn(first),
                        forecastHighColumn(second),
                        forecastHighColumn(third),
                        forecastHighColumn(forth),
                        forecastHighColumn(fifth),
                      ],
                    ),
                    Container(padding: EdgeInsets.fromLTRB(10, 0, 10, 0), height: 220, width: 400, child: SelectionCallback.withSampleData(Lows, Highs, Times)),
                    Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        forecastLowColumn(first),
                        forecastLowColumn(second),
                        forecastLowColumn(third),
                        forecastLowColumn(forth),
                        forecastLowColumn(fifth),
                      ],
                    )
                  ],
                )
            )
        ),
      )
  );
}

forecastHighColumn(List<dynamic> list){
  return Container(
      height: 190,
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
                      Container(padding: EdgeInsets.only(bottom: 10), child: cachedImageLoader(list[2].toString(), 50.0),),
                      Container(child: greyTextViewForForecast(list[3].toString().toString(), 14)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: greyTextViewForForecast("${list[4]}°C", 28),
                ),
              ],
            ),
          )
        ],
      )
  );
}

forecastLowColumn(List<dynamic> list){
  return Container(
      height: 170,
      width: 80,
      child: Row(
        children: <Widget>[
          Expanded(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: greyTextViewForForecast("${list[5]}°C", 28),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(child: cachedImageLoader(list[6].toString(), 50.0),),
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

