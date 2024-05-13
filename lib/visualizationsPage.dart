import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';

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

  @override
  void initState() {
    super.initState();
    incomePoints = makeDataPointList(Hive.box<Income>('income'), 'day', 'income');
    expendPoints = makeDataPointList(Hive.box<Expense>('expenses'), 'day', 'expense');
    netPoints = netWorth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizations')),
      body: SingleChildScrollView( child: Column( children: [
        Center( child: AspectRatio( aspectRatio: 2.0,
            child: Padding(padding: const EdgeInsets.all(16.0) ,child:
            LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      color: Colors.red,
                        barWidth: 4,
                        spots:
                        createGraphPoints(netPoints)
                    )
                  ],
                  backgroundColor: Colors.red[50],
                  titlesData: FlTitlesData (
                      topTitles: const AxisTitles(
                        axisNameWidget: Text('NetWorth',
                            style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                              letterSpacing: 1
                        )),
                          axisNameSize: 30,
                          sideTitles: SideTitles(
                            showTitles: false,
                          )
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => bottomTilesWidgets(value, meta, 'day'),
                          )
                      )
                  ),

                ))
        )
        )
        ),Center( child: AspectRatio( aspectRatio: 2.0,
          child:
            LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                        color: Colors.red,
                        barWidth: 4,
                      spots:
                        createGraphPoints(incomePoints)
                    )
                  ],
                  titlesData: FlTitlesData (
                    topTitles: const AxisTitles(
                      axisNameWidget: Text('Income',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1
                          )), axisNameSize: 30,
                      sideTitles: SideTitles(
                        showTitles: false,
                      )
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => bottomTilesWidgets(value, meta, 'day'),
                      )
                    )
                  ),

          ))
      )
    ),
        Center( child: AspectRatio( aspectRatio: 2.0,
            child:
            LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                        color: Colors.red,
                        barWidth: 4,
                        spots:
                        createGraphPoints(expendPoints)
                    )
                  ],
                  titlesData: FlTitlesData (
                      topTitles: const AxisTitles(
                          axisNameWidget: Text('Expenditures',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1
                              )), axisNameSize: 30,
                          sideTitles: SideTitles(
                            showTitles: false,
                          )
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => bottomTilesWidgets(value, meta, 'day'),
                          )
                      )
                  ),

                ))
        )
        )
      ])));
  }

  Widget bottomTilesWidgets(double value, TitleMeta meta, String type) {
    if(value.toInt() == value) {
      if (type == 'day') {
        DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(
            (value * 1000 * 60 * 60 * 24).toInt());
        String time = '${dateTime.month}/${dateTime.day}';

      return Text(time);
      } else if (type == 'month') {
        DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(
            (value * 1000 * 60 * 60 * 24).toInt());
        String time = '${dateTime.month}';
        return Text(time);
      } else {
        return const Text('');
      }
    } else{
      return const Text('');
    }
  }

  List<Datapoint> makeDataPointList(Box<dynamic> box, String type, String transactionType) {
    List<Datapoint> pointList = [];

    for (var i = 0; i < box.length; i++) {
      final value = box.getAt(i);
      int day = value.date.day;
      int month = value.date.month;
      double year = value.date.year.toDouble();
      double amount = value.amount.toDouble();

      pointList = DatapointAdder(Datapoint(day, month, year, amount, DateTime(year.toInt(),month,day),transactionType), pointList, type);
    }
    return pointList;
  }

  List<FlSpot> createGraphPoints(List<Datapoint> incomePointList) {
    List<FlSpot> flSpots = [];

    for (var datapoint in incomePointList) {
        DateTime dateTime = DateTime(
            datapoint.year.toInt(), datapoint.month, datapoint.day);
        int xValue = dateTime.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24);

        FlSpot flSpot = FlSpot(xValue.toDouble() + 1, datapoint.amount);
        flSpots.add(flSpot);
    }

    return flSpots;
  }

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

    double netAmount = 0;
    for (var entry in dailyAmounts.entries) {
      netAmount += entry.value;
      net.add(Datapoint(entry.key.day, entry.key.month, entry.key.year.toDouble(),
          netAmount, entry.key, 'net'));
    }

    return net;
  }


  // Datapoint add method used create
  List<Datapoint> DatapointAdder(Datapoint point, List<Datapoint> oldList, String type) {

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
  Datapoint(this.day, this.month, this.year, this.amount, this.date, this.transactionType);
}