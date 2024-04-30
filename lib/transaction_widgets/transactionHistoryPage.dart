import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:budget_manager/transaction_widgets/transactionCards.dart';
import '../hive/transaction_box_model.dart';

class TransactionHistoryPage extends StatelessWidget {
  final String transactionType;

  const TransactionHistoryPage({
    super.key,
    required this.transactionType,
  });


  @override
  Widget build(BuildContext context) {
    final String title = getTitle(transactionType);

    return Scaffold(
      appBar: AppBar(
        title: Text('$title History'),
      ),
      body: buildTransactionList(),
    );
  }

  String getTitle(String transactionType) {
    switch (transactionType) {
      case 'income':
        return 'Income';
      case 'expenses':
        return 'Expenditures';
      default:
        return 'Unassigned';
    }
  }

  Box<dynamic> getSelectedTransactionBox() {
    switch (transactionType) {
      case 'income':
        return Hive.box<Income>('income');
      case 'expenses':
        return Hive.box<Expense>('expenses');
      default:
        throw ArgumentError('Invalid transaction type: $transactionType');
    }
  }

  Widget buildTransactionList() {
    final Box<dynamic> selectedTransactionBox = getSelectedTransactionBox();

    return ListView.builder(
      itemCount: selectedTransactionBox.length,
      itemBuilder: (context, index) {
        return createTransactionCard(selectedTransactionBox.getAt(index));
      },
    );
  }
}

