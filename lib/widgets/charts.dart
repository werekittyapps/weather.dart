import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SelectionCallbackExample extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SelectionCallbackExample(this.seriesList, {this.animate});

  /// Creates a [charts.TimeSeriesChart] with sample data and no transition.
  factory SelectionCallbackExample.withSampleData(test) {
    return new SelectionCallbackExample(
      _createSampleData(test),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(test) {
    final us_data = [
      new TimeSeriesSales(DateTime.parse(test["list"][0]["dt_txt"]), test["list"][0]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][1]["dt_txt"]), test["list"][1]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][2]["dt_txt"]), test["list"][2]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][3]["dt_txt"]), test["list"][3]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][4]["dt_txt"]), test["list"][4]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][5]["dt_txt"]), test["list"][5]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][6]["dt_txt"]), test["list"][6]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][7]["dt_txt"]), test["list"][7]["main"]["temp"].round()),
      new TimeSeriesSales(DateTime.parse(test["list"][8]["dt_txt"]), test["list"][8]["main"]["temp"].round()),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'температура (°C)',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: us_data,
      ),
    ];
  }
}

class _SelectionCallbackState extends State<SelectionCallbackExample> {
  DateTime _time;
  Map<String, num> _measures;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
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
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: 350.0,
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

    // If there is a selection, then include the details.
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

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
