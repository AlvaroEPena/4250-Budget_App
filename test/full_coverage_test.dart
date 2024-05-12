// ignore_for_file: unused_import
import 'package:budget_manager/expenditureDialog.dart';
import 'package:budget_manager/hive/transaction_box_model.dart';
import 'package:budget_manager/hive/transaction_box_operations.dart';
import 'package:budget_manager/incomeDialog.dart';
import 'package:budget_manager/main.dart';
import 'package:budget_manager/transaction_widgets/transactionCards.dart';
import 'package:budget_manager/transaction_widgets/transactionHistoryPage.dart';
import 'package:budget_manager/visualizationsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  incomeDialogTests();
  historyTests();
  expenditureDialogTests();
  visualizationsPageTests();

  }

incomeDialogTests() {
  testWidgets('IncomeDialog creation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final incomeButtonFind = find.text('Income');
    expect(incomeButtonFind, findsOneWidget);
    await tester.tap(incomeButtonFind);
    await tester.pump();
    expect(find.byType(IncomeDialog), findsOneWidget);

    //Enter Amount in TextField
    final amountboxfind = find.byKey(const Key('amountField'));
    await tester.tap(amountboxfind);
    await tester.enterText(amountboxfind, '500');
    expect(find.text('500'),findsOneWidget);

    //Enter Category in TextField
    final categoryAddFind = find.byKey(const Key('addCategoryField'));
    await tester.tap(categoryAddFind);
    await tester.enterText(categoryAddFind, 'TestAddIncome');
    expect(find.text('TestAddIncome'),findsOneWidget);

    //Add Category with Button and Selects the Checkbox
    final categoryAddButtonFind = find.byKey(const Key('addCategoryButton'));
    await tester.tap(categoryAddButtonFind);
    await tester.pump();
    final findCheckbox = find.byKey(const Key('TestAddIncome'));
    await tester.tap(findCheckbox);

    // Write in Notes TextField
    final notesFind = find.byKey(const Key('notesTextField'));
    await tester.tap(notesFind);
    await tester.enterText(notesFind, 'Testing Notes');

    //Submit new income
    final submitIncome = find.byKey(const Key('addIncomeButton'));
    await tester.tap(submitIncome);


});
}

historyTests() {
  testWidgets('History', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final incomeButtonFind = find.text('Income');
    expect(incomeButtonFind, findsOneWidget);
    await tester.tap(incomeButtonFind);
    await tester.pump();
    expect(find.byType(IncomeDialog), findsOneWidget);

    //Enter HistoryButton
    final historyButtonfind = find.byKey(const Key('HistoryButton'));
    await tester.tap(historyButtonfind);

  });
}

expenditureDialogTests() {
  testWidgets('ExpenditureDialog creation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final expenditureButtonFind = find.text('Expenditure');
    expect(expenditureButtonFind, findsOneWidget);
    await tester.tap(expenditureButtonFind);
    await tester.pump();
    expect(find.byType(ExpenditureDialog), findsOneWidget);

    //Enter Amount in TextField
    final amountboxfind = find.byKey(const Key('amountField'));
    await tester.tap(amountboxfind);
    await tester.enterText(amountboxfind, '500');
    expect(find.text('500'),findsOneWidget);

    //Enter Category in TextField
    final categoryAddFind = find.byKey(const Key('addCategoryField'));
    await tester.tap(categoryAddFind);
    await tester.enterText(categoryAddFind, 'TestAddExpenditure');
    expect(find.text('TestAddExpenditure'),findsOneWidget);

    //Add Category with Button and Selects the Checkbox
    final categoryAddButtonFind = find.byKey(const Key('addCategoryButton'));
    await tester.tap(categoryAddButtonFind);
    await tester.pump();
    final findCheckbox = find.byKey(const Key('TestAddExpenditure'));
    await tester.tap(findCheckbox);

    // Write in Notes TextField
    final notesFind = find.byKey(const Key('notesTextField'));
    await tester.tap(notesFind);
    await tester.enterText(notesFind, 'Testing Notes');
    await tester.pump();
  });
}

visualizationsPageTests() {
  testWidgets('visualizationTest', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final visualizationsPageButtonFind = find.text('Finance Visualization');
    expect(visualizationsPageButtonFind, findsOneWidget);
    await tester.tap(visualizationsPageButtonFind);
  });
}

