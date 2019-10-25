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
                                    //child: cachedImageLoader("sobaka"),
                                  ),
                                  Container(
                                    alignment: Alignment(1.0, -1.0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: greyTextView(context, '${map["main"]["temp"].round()}°C', 24),
                                    //child: greyTextView(context, "sobaka", 24),
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
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                        child: clickableGreyTextView(context, 'дополнительные функции', 14),
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
                        //onPressed: () => isInFavorites ? delete : add,),
                        onPressed: (){
                          pressButton();
                       //   pressButton();
                        },),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
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
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                      child: clickableGreyTextView(context, 'дополнительные функции', 14),
                    ),
                  ],
                ),
              )
            ],
          )
      )
  );
}

