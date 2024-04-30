import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'transaction_box_model.g.dart';

@HiveType(typeId: 0)
abstract class Transaction extends HiveObject{
  @HiveField(0)
  String category;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String note;

  Transaction(this.category, this.amount, this.date, this.note);
}

// expense
@HiveType(typeId: 1)
class Expense extends Transaction{
  @HiveField(4)
  bool recurring;

  Expense(double amount, DateTime date, String note, {String category = 'Expense', required this.recurring}) : super(category, amount, date, note); // set default category
}

// scheduled expense, bills etc
@HiveType(typeId: 2)
class ScheduledExpense extends Transaction{
  @HiveField(4)
  DateTime dueDate;

  ScheduledExpense(double amount, DateTime date, String note, {String category = 'ScheduledExpense', required this.dueDate}) : super(category, amount, date, note); // set default category
}

// income
@HiveType(typeId: 3)
class Income extends Transaction{
  Income(double amount, DateTime date, String note, {String category = 'Income'}) : super(category, amount, date, note); // set default category
}

