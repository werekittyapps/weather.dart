import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/widgets/texts.dart';

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
        //appBar:
        body: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: searchFlag ?
                // If we searching
                Column (
                    children: [
                      Expanded (
                        child: Container (
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child:
                          ListView.builder(
                              itemCount: 2,//_filteredArray.length,
                              itemBuilder: (context, i){
                                return new ListTile(
                                  title: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey[400]
                                      ),
                                    ),
                                    child: Container (
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
                                                              greyTextView(context, 'Название города', 22),
                                                              greyTextView(context, 'Cтранa', 14),
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
                                                                  child: Icon(Icons.cloud),
                                                                ),
                                                                Container(
                                                                  alignment: Alignment(1.0, -1.0),
                                                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                                  child: greyTextView(context, 'N°C', 24),
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