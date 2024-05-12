import 'package:budget_manager/transaction_widgets/transactionHistoryPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive/transaction_box_model.dart';

class totalAmounts extends StatefulWidget {

  const totalAmounts({super.key});

  @override
  _totalAmounts createState() => _totalAmounts();
}

class _totalAmounts extends State<totalAmounts> {

  @override
  Widget build(BuildContext context) {
    return Center( child: Column(
        children: [
          const Text('Total Balance: ',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold
          )),
          Text(
            (frontPageAmounts(Hive.box<Income>('income')) -
                frontPageAmounts(Hive.box<Expense>('expenses')))
                .toString(),
          ),

        ]));
  }

  double frontPageAmounts(Box<dynamic> transactionBox) {
    double totalAmount = 0;
    for (var i = 0; i < transactionBox.length; i++) {
      final transaction = transactionBox.getAt(i); // grab transaction
      totalAmount += transaction.amount; // adding the amount
    }
    return totalAmount;
  }
}