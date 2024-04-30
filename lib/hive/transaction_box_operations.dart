// TODO: create operations file were we make custom functions to do things for our database (retrieve certain info etc)

import 'package:hive/hive.dart';
import 'package:budget_manager/hive/transaction_box_model.dart';

// function to save income log into database
void saveIncomeLog(double amount, DateTime date, String note, String? category) {
  final box = Hive.box<Income>('income'); // open box
  if (category != null) {
    box.add(Income(amount, date, note, category: category)); // create income object and add it to the database (auto increments)
  } else {
    box.add(Income(amount, date, note)); // create income object without category and add it to the database (auto increments)
  }
}

// function to save expense log into database
void saveExpenseLog(double amount, DateTime date, String note, String? category, bool recurring) {
  final box = Hive.box<Expense>('expenses'); // open box
  if (category != null) {
    box.add(Expense(amount, date, note, category: category, recurring: recurring)); // create expense object and add it to the database (auto increments)
  } else {
    box.add(Expense(amount, date, note, recurring: recurring)); // create expense object without category and add it to the database (auto increments)
  }
}