import 'package:flutter/material.dart';
import 'package:budget_manager/hive/transaction_box_model.dart';

Widget createTransactionCard(Transaction transaction) {
    if (transaction is Expense) {
      return ExpenseCard(transaction: transaction);
    } else if (transaction is ScheduledExpense) {
      return ScheduledExpenseCard(transaction: transaction);
    } else if (transaction is Income) {
      return IncomeCard(transaction: transaction);
    } else {
      throw ArgumentError('Unknown transaction type: $transaction');
    }
  }


class ExpenseCard extends StatelessWidget {
  final Expense transaction;

  const ExpenseCard({
    super.key,
    required this.transaction
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: const Text('Expense'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${transaction.category}'),
            Text('Amount: ${transaction.amount}'),
            Text('Date: ${transaction.date}'),
            Text('Note: ${transaction.note}'),
            Text('Recurring: ${transaction.recurring}'),
          ],
        ),
      ),
    );
  }
}

class ScheduledExpenseCard extends StatelessWidget {
  final ScheduledExpense transaction;

  const ScheduledExpenseCard({
    super.key,
    required this.transaction
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: const Text('Scheduled Expense'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${transaction.category}'),
            Text('Amount: ${transaction.amount}'),
            Text('Date: ${transaction.date}'),
            Text('Note: ${transaction.note}'),
            Text('Due Date: ${transaction.dueDate}'),
          ],
        ),
      ),
    );
  }
}

class IncomeCard extends StatelessWidget {
  final Income transaction;

  const IncomeCard({
    super.key,
    required this.transaction
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: const Text('Income'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${transaction.category}'),
            Text('Amount: ${transaction.amount}'),
            Text('Date: ${transaction.date}'),
            Text('Note: ${transaction.note}'),
          ],
        ),
      ),
    );
  }
}
