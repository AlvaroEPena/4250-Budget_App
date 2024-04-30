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

  // Function to calculate the total amount asynchronously (in case of big db then it will not freeze and perhaps cache the results)
  Future<double> calculateTotalAmount(Box<dynamic> transactionBox) async {
    double totalAmount = 0;
    for (var i = 0; i < transactionBox.length; i++) {
      final transaction = await transactionBox.getAt(i); // grab transaction
      totalAmount += transaction.amount; // adding the amount
    }
    return totalAmount;
  }

  Widget buildTransactionList() {
    final Box<dynamic> selectedTransactionBox = getSelectedTransactionBox();

    return FutureBuilder(
      future: calculateTotalAmount(selectedTransactionBox),
      initialData: 0.0,
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while calculating
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // if any errors occurred during calculation
        } else {
          final double totalAmount = snapshot.data ?? 0; // if the data is null
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: selectedTransactionBox.length,
                  itemBuilder: (context, index) {
                    final transaction = selectedTransactionBox.getAt(index);
                    return createTransactionCard(transaction);
                  },
                ),
              ),
              ListTile(
                title: Text('Total Amount: $totalAmount'),
              ),
            ],
          );
        }
      },
    );
  }
}


