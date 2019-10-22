import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherBody extends StatefulWidget {
@override
createState() => new WeatherBodyState();
}

class WeatherBodyState extends State<WeatherBody> {
  List _originalArray = [];
  List _filteredArray = [];

  // For search bar
  Widget _appBarTitle = new Text( 'Weather' );
  Icon _searchIcon = new Icon(Icons.search);
  final TextEditingController _filter = new TextEditingController();

  // Flags
  bool searchFlag = false;

  searching(){
    //getCached(); get list from cache or internet
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        searchFlag = true;
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
            controller: _filter,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...',),
            onChanged: (value) {
              List tempList = new List();
              _filteredArray = _originalArray;
              for (int i = 0; i < _filteredArray.length; i++) {
                if (_filteredArray[i]['city'].toLowerCase().contains(
                    value.trim().toLowerCase())) {
                  tempList.add(_filteredArray[i]);
                }
              }
              setState(() {_filteredArray = tempList;});
            }
            );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Weather');
        searchFlag = false;
        _filter.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: () {
              print("pressed");
              searching();
              },
          ),],
      ),
      body: Container(
          child: searchFlag ?
          // If we searching
          Column (
          children: [
            Expanded (
              child: Container (
                child:
                ListView.builder(
                    itemCount: 2,//_filteredArray.length,
                    itemBuilder: (context, i){
                      return new ListTile(
                        title: Container (
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
                                          children: [
                                            // Город и страна
                                            // Иконка
                                            // Градусы
                                            Container(
                                              alignment: Alignment(-1.0, -1.0),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                    text: TextSpan(
                                                        style: DefaultTextStyle.of(context).style,
                                                        children: [
                                                          TextSpan(
                                                          text: 'Название города',
                                                          style: TextStyle(
                                                            fontSize: 22
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                        style: DefaultTextStyle.of(context).style,
                                                        children: [
                                                          TextSpan(
                                                              text: 'Название страны',
                                                              style: TextStyle(
                                                                  fontSize: 14
                                                              )
                                                          )
                                                        ]
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment(1.0, -1.0),
                                              child: Icon(Icons.cloud),
                                            ),
                                            Container(
                                              alignment: Alignment(1.0, -1.0),
                                              child: Text("tC"),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text("дополнительные функции"),
                                    ],
                                  ),
                                )
                              ],
                            )
                            //Row(
                            //    children:[
                            //      Expanded(
                            //          child: Container(
                            //              child: Column (
                            //                crossAxisAlignment: CrossAxisAlignment.start,
                            //                children: [
                            //                  Container (
                            //                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            //                    child: RichText(
                            //                      text: TextSpan(
                            //                        style: DefaultTextStyle.of(context).style,
                            //                        children: <TextSpan>[
                            //                          TextSpan(text: 'Title: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            //                          TextSpan(text: "${_filteredArray[i]["title"]}"),
                            //                        ],
                            //                      ),
                            //                    ),
                            //                  ),
                            //                ],
                            //              )
                            //          )
                            //      ),
                            //    ]
                            //)
                        ),
                      );
                    }),
              ),
            ),
          ]) :
          // If we not searching, we must show favorite cards
          Container()
      )
    );
  }


}