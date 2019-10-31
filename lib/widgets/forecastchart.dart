import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SelectionCallback extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SelectionCallback(this.seriesList, {this.animate});

  factory SelectionCallback.withSampleData(low, high, time) {
    return new SelectionCallback(
      _createSampleData(low, high, time),
      animate: false,
    );
  }


  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(low, high, time) {
    final us_data = [
      new TimeSeriesSales(time[0], low[0]),
      new TimeSeriesSales(time[1], low[1]),
      new TimeSeriesSales(time[2], low[2]),
      new TimeSeriesSales(time[3], low[3]),
      new TimeSeriesSales(time[4], low[4]),
    ];

    final uk_data = [
      new TimeSeriesSales(time[0], high[0]),
      new TimeSeriesSales(time[1], high[1]),
      new TimeSeriesSales(time[2], high[2]),
      new TimeSeriesSales(time[3], high[3]),
      new TimeSeriesSales(time[4], high[4]),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'температура ночью (°C)',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: us_data,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'температура днем (°C)',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: uk_data,
      )
    ];
  }
}

class _SelectionCallbackState extends State<SelectionCallback> {
  DateTime _time;
  Map<String, num> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      new SizedBox(
          height: 150.0,
          child: new charts.TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          )),
    ];

    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(_time.toString())));
    }
    _measures?.forEach((String series, num value) {
      children.add(new Text('${series}: ${value}'));
    });

    return new Column(children: children);
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}