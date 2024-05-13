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
    incomePoints = makeDataPointList(Hive.box<Income>('income'), 'day');
    expendPoints = makeDataPointList(Hive.box<Expense>('expenses'), 'day');
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
                              letterSpacing: 2
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
        ),const Text('Income'), Center( child: AspectRatio( aspectRatio: 2.0,
          child:
            LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots:
                        createGraphPoints(incomePoints)
                    )
                  ],
                  titlesData: FlTitlesData (
                    topTitles: const AxisTitles(
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
        const Text('Expenses'), Center( child: AspectRatio( aspectRatio: 2.0,
            child:
            LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                        spots:
                        createGraphPoints(expendPoints)
                    )
                  ],
                  titlesData: FlTitlesData (
                      topTitles: const AxisTitles(
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

  List<Datapoint> makeDataPointList(Box<dynamic> box, String type) {
    List<Datapoint> pointList = [];

    for (var i = 0; i < box.length; i++) {
      final value = box.getAt(i);
      int day = value.date.day;
      int month = value.date.month;
      double year = value.date.year.toDouble();
      double amount = value.amount.toDouble();

      pointList = DatapointAdder(Datapoint(day, month, year, amount), pointList, type);
    }
    return pointList;
  }

  List<FlSpot> createGraphPoints(List<Datapoint> incomePointList) {
    List<FlSpot> flSpots = [];

    for (var datapoint in incomePointList) {
        DateTime dateTime = DateTime(
            datapoint.year.toInt(), datapoint.month, datapoint.day);
        double xValue = dateTime.millisecondsSinceEpoch / (1000 * 60 * 60 * 24);

        FlSpot flSpot = FlSpot(xValue, datapoint.amount);
        flSpots.add(flSpot);
    }

    return flSpots;
  }

  List<Datapoint> netWorth() {
    List<Datapoint> net = [];
    double netAmount = 0;

    int maxLength = incomePoints.length > expendPoints.length
        ? incomePoints.length
        : expendPoints.length;

    for (int i = 0; i < maxLength; i++) {
      if (i < incomePoints.length) {
        net.add(Datapoint(incomePoints[i].day, incomePoints[i].month,
            incomePoints[i].year, netAmount + incomePoints[i].amount));
        netAmount = netAmount + incomePoints[i].amount;
      } else if (i < expendPoints.length) {
        net.add(Datapoint(expendPoints[i].day, expendPoints[i].month,
            expendPoints[i].year, netAmount + (expendPoints[i].amount * -1)));
        netAmount = netAmount + (expendPoints[i].amount * -1);
      }

      if (i == expendPoints.length) {
        net.add(Datapoint(expendPoints[i].day, expendPoints[i].month,
            expendPoints[i].year, netAmount + (expendPoints[i].amount * -1)));
        netAmount = netAmount + (expendPoints[i].amount * -1);
      }

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
  int day;
  int month;
  double year;
  double amount;
  Datapoint(this.day, this.month, this.year, this.amount);
}