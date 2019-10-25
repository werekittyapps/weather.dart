import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/images.dart';
import 'package:weather/widgets/texts.dart';

errorCard(BuildContext context) {
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
  );
}

currentWeatherSearchCard(BuildContext context, Map<String, dynamic> map) {
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
                    // Верхняя часть: Город, страна, иконка и градусы
                    // Нижняя часть: дополнительные фичи
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            clickableGreyTextView(context, 'Влажность ${map["main"]["humidity"].round()}% | '
                                '${map["wind"]["deg"] > 337.5 || map["wind"]["deg"] < 22.5 ? "С"
                                : map["wind"]["deg"] > 22.5 && map["wind"]["deg"] < 67.5 ? "СВ"
                                : map["wind"]["deg"] > 67.5 && map["wind"]["deg"] < 112.5 ? "В"
                                : map["wind"]["deg"] > 112.5 && map["wind"]["deg"] < 157.5 ? "ЮВ"
                                : map["wind"]["deg"] > 157.5 && map["wind"]["deg"] < 202.5 ? "Ю"
                                : map["wind"]["deg"] > 202.5 && map["wind"]["deg"] < 247.5 ? "ЮЗ"
                                : map["wind"]["deg"] > 247.5 && map["wind"]["deg"] < 292.5 ? "З"
                                : "СЗ"} | ${map["wind"]["speed"].round() * 3.6} км/ч', 14),
                            clickableGreyTextView(context, '${map["main"]["temp_max"].round()}/${map["main"]["temp_min"].round()}°C', 14),
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

currentWeatherFavoriteCard(BuildContext context, Map<String, dynamic> map, int i) {
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
                      // Верхняя часть: Город, страна, иконка и градусы
                      // Нижняя часть: дополнительные фичи
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
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
                              clickableGreyTextView(context, 'Влажность ${map["list"][i]["main"]["humidity"].round()}% | '
                                  '${map["list"][i]["wind"]["deg"] > 337.5 || map["list"][i]["wind"]["deg"] < 22.5 ? "С"
                                  : map["list"][i]["wind"]["deg"] > 22.5 && map["list"][i]["wind"]["deg"] < 67.5 ? "СВ"
                                  : map["list"][i]["wind"]["deg"] > 67.5 && map["list"][i]["wind"]["deg"] < 112.5 ? "В"
                                  : map["list"][i]["wind"]["deg"] > 112.5 && map["list"][i]["wind"]["deg"] < 157.5 ? "ЮВ"
                                  : map["list"][i]["wind"]["deg"] > 157.5 && map["list"][i]["wind"]["deg"] < 202.5 ? "Ю"
                                  : map["list"][i]["wind"]["deg"] > 202.5 && map["list"][i]["wind"]["deg"] < 247.5 ? "ЮЗ"
                                  : map["list"][i]["wind"]["deg"] > 247.5 && map["list"][i]["wind"]["deg"] < 292.5 ? "З"
                                  : "СЗ"} | ${map["list"][i]["wind"]["speed"].round() * 3.6} км/ч', 14),
                              clickableGreyTextView(context, '${map["list"][i]["main"]["temp_max"].round()}/${map["list"][i]["main"]["temp_min"].round()}°C', 14),
                            ],
                          )
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
  );
}

currentWeatherSearchCardWithBtn(BuildContext context, Map<String, dynamic> map, bool isInFavorites, Function pressButton) {
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
                            clickableGreyTextView(context, 'Влажность ${map["main"]["humidity"].round()}% | '
                                '${map["wind"]["deg"] > 337.5 || map["wind"]["deg"] < 22.5 ? "С"
                                : map["wind"]["deg"] > 22.5 && map["wind"]["deg"] < 67.5 ? "СВ"
                                : map["wind"]["deg"] > 67.5 && map["wind"]["deg"] < 112.5 ? "В"
                                : map["wind"]["deg"] > 112.5 && map["wind"]["deg"] < 157.5 ? "ЮВ"
                                : map["wind"]["deg"] > 157.5 && map["wind"]["deg"] < 202.5 ? "Ю"
                                : map["wind"]["deg"] > 202.5 && map["wind"]["deg"] < 247.5 ? "ЮЗ"
                                : map["wind"]["deg"] > 247.5 && map["wind"]["deg"] < 292.5 ? "З"
                                : "СЗ"} | ${map["wind"]["speed"].round() * 3.6} км/ч', 14),
                            clickableGreyTextView(context, '${map["main"]["temp_max"].round()}/${map["main"]["temp_min"].round()}°C', 14),
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

weatherForecast(Map<String, dynamic> map){
  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
          child: Container (
            // Белая карточка
            color: Colors.white,
            child: Row (
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                forecastColumn(map, 0),
                forecastColumn(map, 10),
                forecastColumn(map, 20),
                forecastColumn(map, 30),
                forecastColumn(map, 40)
              ],
            )
          )
      )
  );
}

forecastColumn(Map<String, dynamic> map, int Index){
  return Container(
      height: 500,
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
                        Container(padding: EdgeInsets.only(bottom: 5), child: greyTextViewForForecast("Day", 14)),
                        Container(child: greyTextViewForForecast("Date", 14)),
                      ],
                    )
                ),
                Divider(thickness: 1, height: 0, color: Colors.grey[400]),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(padding: EdgeInsets.only(bottom: 10), child: cachedImageLoader("url"),),
                      Container(child: greyTextViewForForecast("state", 14)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 90),
                  child: greyTextViewForForecast("N", 14),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                  child: greyTextViewForForecast("N", 14),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(padding: EdgeInsets.only(bottom: 10), child: cachedImageLoader("url"),),
                      Container(padding: EdgeInsets.only(bottom: 5), child: greyTextViewForForecast("state", 14)),
                      Container(child: greyTextViewForForecast("wind dir", 14)),
                      Container(child: greyTextViewForForecast("speed", 14)),
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

