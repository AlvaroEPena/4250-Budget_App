import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive/transaction_box_model.dart';

class TotalAmounts extends StatelessWidget {
  const TotalAmounts({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          const Text(
            'Total Balance: ',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Builder(
            builder: (context) {
              final incomeBox = Hive.box<Income>('income');
              final expensesBox = Hive.box<Expense>('expenses');
              final total = frontPageAmounts(incomeBox) - frontPageAmounts(expensesBox);
              return Text(total.toStringAsFixed(2));
            },
          ),
          ElevatedButton(
            key: const Key('CloseAmountDialog'),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          )],
      ),
    );
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