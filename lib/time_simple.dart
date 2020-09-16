// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:collection';

/// Timeseries chart example
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatefulWidget {
  final int max_chart_count = 10;
  List<charts.Series> seriesList;
  bool animate = false;
  //List<TimeSeriesSales> dataList;
  SimpleTimeSeriesChart(this.seriesList, {this.animate});
  List<TimeSeriesSales> qdata = List();

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  // factory SimpleTimeSeriesChart.withSampleData() {
  //   return new SimpleTimeSeriesChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory SimpleTimeSeriesChart.withRandomData() {
    return new SimpleTimeSeriesChart(_createRandomData());
  }

  // Create random data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createRandomData() {
    var data = [
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 70),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _update() {
    final random = new Random();
    //var time = DateTime(2017, 9, 19, 18, 30);
    var time = DateTime.now();

    print(time);
    if (!qdata.isEmpty && qdata.length > max_chart_count) qdata.removeAt(0);
    qdata.add(TimeSeriesSales(time, random.nextInt(100)));

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: qdata,
      )
    ];
  }

  @override
  _SimpleTimeSeriesChartState createState() => _SimpleTimeSeriesChartState();
}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  @override
  void initState() {
    var time = DateTime.now();
    var mtime = DateTime.now();

    Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //data[3] = TimeSeriesSales(time, random.nextInt(100));
      widget.seriesList = widget._update();
      setState(() {});
      //dataList.add(new TimeSeriesSales(time, random.nextInt(100)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      widget.seriesList,
      animate: false, //widget.animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
