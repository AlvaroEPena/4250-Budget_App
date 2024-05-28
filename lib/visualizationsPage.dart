import 'package:budget_manager/visualizationTimeScalePicker.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'hive/transaction_box_model.dart';

class visualizationsPage extends StatefulWidget {


  const visualizationsPage({super.key});

  @override
  _visualizationsPage createState() => _visualizationsPage();
}

class _visualizationsPage extends State<visualizationsPage> {
  late List<Datapoint>incomePoints;
  late List<Datapoint>expendPoints;
  late List<Datapoint>netPoints;
  late String displayedGraph = 'income';
  late String timeSpan = 'day';
  late double total = 0;


  @override
  void initState() {
    super.initState();
    _initializePoints();
  }

  _initializePoints() {
    incomePoints = makeDataPointList(Hive.box<Income>('income'),'income');
    expendPoints = makeDataPointList(Hive.box<Expense>('expenses'),'expense');
    netPoints = netWorth();
  }


  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;


  int? pickedMonth = DateTime.now().month;
  int?pickedYear = DateTime.now().year;

  dynamic _pickerOpen = false;

  void switchTimePicker() {
    setState(() {
      total = 0;
      if(_pickerOpen) {
        _pickerOpen= false;
      } else {
        _pickerOpen = true;
      }
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      months.add(
        TextButton(
          onPressed: () {
            setState(() {
              pickedYear = _pickerYear;
              pickedMonth = i;
              timeSpan = 'day';
              switchTimePicker();

            });
          },
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: Text(
            DateFormat('MMM').format(dateTime),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12),
      ),
    ];
  }

  void _selectedGraph(SampleItem option) {
    setState(() {
      switch(option) {
        case SampleItem.income:
          displayedGraph = 'income';
          total = 0;
          break;
        case SampleItem.expense:
          displayedGraph = 'expenditures';
          total = 0;
          break;
        case SampleItem.netWorth:
          displayedGraph = 'netWorth';
          total = 0;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _initializePoints();
    return Scaffold(
        appBar: AppBar(title: const Text('Visualizations')),
        body: SingleChildScrollView( child: Column( children: [
          Center( child: Column( children: [Center( child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [SizedBox(
              width: 175,
              child: Material(
                color: Colors.red.shade200,
                shape: const StadiumBorder(),
                child: PopupMenuButton<SampleItem>(
                  initialValue: SampleItem.income,
                  position: PopupMenuPosition.under,
                  icon: Text(style: const TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.bold ),displayedGraph[0].toUpperCase() + displayedGraph.substring(1)),
                  onSelected: _selectedGraph,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.income,
                      child: SizedBox(width: 120,child: Text('Income')),
                    ),
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.expense,
                      child: SizedBox(width: 120,child: Text('Expenditures')),
                    ),
                    const PopupMenuItem<SampleItem>(
                      value: SampleItem.netWorth,
                      child: SizedBox(width: 120,child: Text('NetWorth')),
                    )
                  ],
                ),
              ),
            )
              ,SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: switchTimePicker,
                  child: Text(
                    (pickedMonth != null ?
                    '$pickedMonth/' : '') + pickedYear.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
          ])),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            SizedBox(
              height: _pickerOpen ? null : 0.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  YearPickerWidget(
                    pickerYear: _pickerYear,
                    onYearChanged: (year) {
                      setState(() {
                        _pickerYear = year;
                        pickedYear = year;
                        total = 0;
                      });
                    },
                    onYearTapped: () {
                      setState(() {
                        pickedMonth = null;
                        pickedYear = _pickerYear;
                        timeSpan = 'month';
                        total = 0;
                        switchTimePicker();
                      });
                    },
                    generateMonths: generateMonths,
                  ),
                ],
              ),
    )],
          ),Center( child: AspectRatio( aspectRatio: 2.0,
              child: displayedGraph == 'income' ?
              Padding( padding: const EdgeInsets.only(right: 15), child: buildLineChart(incomePoints, 'Income')) :
              displayedGraph == 'expenditures' ?
              Padding( padding: const EdgeInsets.only(right: 15), child: buildLineChart(expendPoints, 'Expense')) :
              Padding( padding: const EdgeInsets.only(right: 15), child: buildLineChart(netPoints, 'Net Worth'))
          ),
          )
          ,
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox( height: 50, width:50, child: Dialog(
                      child:
                      PieChart(
                          PieChartData(
                              centerSpaceRadius: 0,
                              sections: displayedGraph == 'income' ? getSections(pieChartReadData(pieChartGetData(incomePoints, pickedMonth, pickedYear))) :
                              displayedGraph == 'expenditures' ? getSections(pieChartReadData(pieChartGetData(expendPoints, pickedMonth, pickedYear))) :
                              getSections(pieChartReadData(pieChartGetData(netPoints, pickedMonth, pickedYear)))

                          )
                      )));
                },
              );
            },
            child: const Text('Categories'),
          )
        ])));
  }

  //generates LineChart from user selected time-span of  DataPointLists
  LineChart buildLineChart(List<Datapoint> points, String title) {
    return LineChart(
      LineChartData(
        minX: () {
          if (timeSpan == 'month') {
            return 2.0;
          } else {
            return ((DateTime(pickedYear!, pickedMonth!, 1 + 1)).millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24)).toDouble();
          }
        }()
        ,
        maxX: () {
          if (timeSpan == 'month') {
            return 13.0;
          } else {
            return ((DateTime(pickedYear!, pickedMonth! + 1, 1).subtract(const Duration(days: 1))).millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24)).toDouble();
          }
        }(),
        lineBarsData: [
          LineChartBarData(
            color: Colors.red,
            barWidth: 4,
            spots: createGraphPoints(dataTimeFilter(points, pickedMonth, pickedYear), timeSpan),
          ),
        ],
        backgroundColor: Colors.red[50],
        titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: timeSpan == 'day' ? 5.0 : null,
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    bottomTilesWidgets(value, meta, timeSpan),
              ),
            ),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
            ),
            leftTitles:  AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 35,
                  showTitles: true,
                  getTitlesWidget: (value,meta) {
                    return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12,),);
                  },
                )
            )
        ),
      ),
    );
  }


  // creates bottom axis labels depending on the time-scale of the graph
  Widget bottomTilesWidgets(double value, TitleMeta meta, String type) {
    if(value.toInt() == value) {
      if (type == 'day') {
        DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(
            (value * 1000 * 60 * 60 * 24).toInt());
        String time = '${dateTime.day}';

        return Text(time);
      } else if (type == 'month') {
        DateTime date = DateTime(0,value.toInt() - 1);
        return Text(DateFormat.MMM().format(date),style: const TextStyle(fontSize: 12,));
      } else {
        return const Text('');
      }
    } else{
      return const Text('');
    }
  }

  // Makes DataPoint objects from database
  List<Datapoint> makeDataPointList(Box<dynamic> box,String transactionType) {
    List<Datapoint> pointList = [];

    for (var i = 0; i < box.length; i++) {
      final value = box.getAt(i);
      int day = value.date.day;
      int month = value.date.month;
      double year = value.date.year.toDouble();
      double amount = value.amount.toDouble();
      String category = value.category;

      pointList.add(Datapoint(day, month, year, amount, DateTime(year.toInt(),month,day),transactionType, category));
    }
    return pointList;
  }

  //groups dataPoints by calling the DatapointAdder function
  List<Datapoint> groupDataList(List<Datapoint> dataList, String type) {
    List<Datapoint> newList = [];
    for (var i = 0; i < dataList.length; i ++) {
      newList = datapointAdder(dataList[i], newList, type);
    }
    return newList;
  }

  //filters to datapoints by timeframe, while adding previous amounts 'till timeframe
  List<Datapoint> dataTimeFilter(List<Datapoint> dataList, int? month, int? year) {

    List<Datapoint> newList = [];

    for (var datapoint in dataList) {
      if (month == null) {
        if (datapoint.year == year) {
          newList.add(datapoint);
        } else if (datapoint.year < year!){
          total = total + datapoint.amount;
        }
      } else {
        if (datapoint.month == month && datapoint.year == year) {
          newList.add(datapoint);
        } else {
          if (datapoint.year < year! || (datapoint.year == year && datapoint.month < month)) {
            total = total + datapoint.amount;
          }
        }
      }
    }
    return groupDataList(newList, timeSpan);
  }


  // creates the FlSpots(x-axis positions) for the points to be positioned on graph according to time-scale
  List<FlSpot> createGraphPoints(List<Datapoint> incomePointList, String scale) {
    List<FlSpot> flSpots = [];
    int previousAmount = 0;

    for (var datapoint in incomePointList) {
      int xValue;
      if (scale == 'day') {
        xValue = datapoint.date.millisecondsSinceEpoch ~/
            (1000 * 60 * 60 * 24);
      } else {
        xValue = datapoint.month;
      }
      FlSpot flSpot = FlSpot(xValue.toDouble() + 1, datapoint.amount + total + previousAmount);
      flSpots.add(flSpot);
      total += datapoint.amount;
    }
    if (incomePointList.isNotEmpty && scale == 'day' && incomePointList.last.month < DateTime.now().month) {
      flSpots.add(FlSpot(((DateTime(pickedYear!, pickedMonth! + 1, 1).subtract(const Duration(days: 1))).millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24)).toDouble(),flSpots.last.y));
    }

    return flSpots;
  }


  //calculates the net profit of the cumulative amounts of income and expenditures
  List<Datapoint> netWorth() {
    List<Datapoint> net = [];
    Map<DateTime, double> dailyAmounts = {};

    List<Datapoint> allPoints = [];
    allPoints.addAll(incomePoints);
    allPoints.addAll(expendPoints);

    allPoints.sort((a, b) => a.date.compareTo(b.date));

    for (var point in allPoints) {
      DateTime date = DateTime(point.year.toInt(), point.month, point.day);
      if (point.transactionType == 'income') {
        dailyAmounts.update(date, (value) => value + point.amount,
            ifAbsent: () => point.amount);
      } else {
        dailyAmounts.update(date, (value) => value - point.amount,
            ifAbsent: () => -point.amount);
      }
    }

    //double netAmount = 0;
    for (var entry in dailyAmounts.entries) {
      //netAmount += entry.value;
      net.add(Datapoint(entry.key.day, entry.key.month, entry.key.year.toDouble(),
          entry.value, entry.key, 'net', ''));
    }

    return net;
  }


  // Groups/adds datapoints that occur on the same moment according to time-scale
  List<Datapoint> datapointAdder(Datapoint point, List<Datapoint> oldList, String type) {

    for(int i = 0; i < oldList.length; i++) {
      if (type == 'day') {
        if (point.day == oldList[i].day && point.month == oldList[i].month &&
            point.year == oldList[i].year) {
          oldList[i].amount = oldList[i].amount + point.amount;
          return oldList;
        }
      } else if (type == 'month') {
        if (point.month == oldList[i].month && point.year == oldList[i].year) {
          oldList[i].amount = oldList[i].amount + point.amount;
          return oldList;
        }
      }  else if (type == 'year') {
        if (point.year == oldList[i].year) {
          oldList[i].amount = oldList[i].amount + point.amount;
          return oldList;
        }
      }
    }
    oldList.add(point);

    return oldList;
  }

}

class Datapoint {
  DateTime date;
  int day;
  int month;
  double year;
  double amount;
  String transactionType;
  String category;
  Datapoint(this.day, this.month, this.year, this.amount, this.date, this.transactionType, this.category);
}


enum SampleItem { income, expense, netWorth}

List<Datapoint> pieChartGetData(List<Datapoint> dataList, int? month, int? year) {
  List<Datapoint> newList = [];

  for (var datapoint in dataList) {
    if (month == null) {
      if (datapoint.year == year) {
        newList.add(datapoint);
      }
    } else {
      if (datapoint.month == month && datapoint.year == year) {
        newList.add(datapoint);
      }
    }

  }
  return newList;
}

Map<String, double> pieChartReadData(List<Datapoint> mapData) {
  Map<String, double> categories = {};

  for (var datapoint in mapData) {
    if (categories.containsKey(datapoint.category)) {
      categories[datapoint.category] = categories[datapoint.category]! + datapoint.amount;
    } else {
      categories[datapoint.category] = datapoint.amount;
    }

  }
  return categories;
}






List<PieChartSectionData> getSections(Map<String, double> pieChartData) {
  double total = pieChartData.values.fold(0, (sum, value) => sum + value);

  return List.generate(pieChartData.length, (index) {
    String key = pieChartData.keys.elementAt(index);
    double value = pieChartData[key] ?? 0;
    double percentage = (value / total) * 100;

    return PieChartSectionData(
      color: Colors.red,
      value: value,
      title: '$key (${percentage.toStringAsFixed(1)}%)',
      radius: 100,
      titleStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  });
}