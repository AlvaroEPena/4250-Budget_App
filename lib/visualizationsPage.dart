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

  @override
  void initState() {
    super.initState();
    incomePoints = makeDataPointList(Hive.box<Income>('income'));
    expendPoints = makeDataPointList(Hive.box<Expense>('expenses'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizations')),
      body: SingleChildScrollView( child: Column( children: [const Text('Income'), Center( child: AspectRatio( aspectRatio: 2.0,
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
                        getTitlesWidget: bottomTilesWidgets,
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
                            getTitlesWidget: bottomTilesWidgets,
                          )
                      )
                  ),

                ))
        )
        )
      ])));
  }

  Widget bottomTilesWidgets(double value, TitleMeta meta) {
    if(value.toInt() == value) {
      DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(
          (value * 1000 * 60 * 60 * 24).toInt());
      String time = '${dateTime.month}/${dateTime.day}';
      return Text(time);
    } else{
      return const Text('');
    }
  }

  List<Datapoint> makeDataPointList(Box<dynamic> incomeBox) {
    List<Datapoint> incomePointList = [];

    for (var i = 0; i < incomeBox.length; i++) {
      final incomeTuple = incomeBox.getAt(i);
      int day = incomeTuple.date.day;
      int month = incomeTuple.date.month;
      double year = incomeTuple.date.year.toDouble();
      double amount = incomeTuple.amount.toDouble();

      incomePointList.add(Datapoint(day, month, year, amount));
    }
    return incomePointList;
  }

  List<FlSpot> createGraphPoints(List<Datapoint> incomePointList) {
    List<FlSpot> flSpots = [];

    for (var datapoint in incomePointList) {
      DateTime dateTime = DateTime(datapoint.year.toInt(), datapoint.month, datapoint.day);
      double xValue = dateTime.millisecondsSinceEpoch / (1000 * 60 * 60 * 24);

      FlSpot flSpot = FlSpot(xValue, datapoint.amount);
      flSpots.add(flSpot);
    }

    return flSpots;
  }

}

class Datapoint {
  int day;
  int month;
  double year;
  double amount;
  Datapoint(this.day, this.month, this.year, this.amount);
}