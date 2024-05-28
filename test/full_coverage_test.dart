import 'package:budget_manager/billsDialog.dart';
import 'package:budget_manager/expenditureDialog.dart';
import 'package:budget_manager/getTotalAmounts.dart';
import 'package:budget_manager/hive/transaction_box_model.dart';
import 'package:budget_manager/hive/transaction_box_operations.dart';
import 'package:budget_manager/imageDialog.dart';
import 'package:budget_manager/incomeDialog.dart';
import 'package:budget_manager/main.dart';
import 'package:budget_manager/transaction_widgets/imageViewer.dart';
import 'package:budget_manager/transaction_widgets/transactionCards.dart';
import 'package:budget_manager/transaction_widgets/transactionHistoryPage.dart';
import 'package:budget_manager/visualizationsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  incomeDialogTests();
  historyTests();
  expenditureDialogTests();
  //visualizationsPageTests();
  imageViewerTests();
  imageDialogTests();
  billsDialogTests();
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
  testWidgets('Income History', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final incomeButtonFind = find.text('Income');
    expect(incomeButtonFind, findsOneWidget);
    await tester.tap(incomeButtonFind);
    await tester.pump();
    expect(find.byType(IncomeDialog), findsOneWidget);

    //Enter HistoryButton
    final historyButtonFind = find.byKey(const Key('HistoryButton'));
    await tester.tap(historyButtonFind);

  });

  testWidgets('Expenditures History', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final expendButtonFind = find.text('Expenditure');
    expect(expendButtonFind, findsOneWidget);
    await tester.tap(expendButtonFind);
    await tester.pump();
    expect(find.byType(ExpenditureDialog), findsOneWidget);

    //Enter HistoryButton
    final historyButtonFind = find.byKey(const Key('HistoryButton'));
    await tester.tap(historyButtonFind);
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

void visualizationsPageTests() {
  testWidgets('visualizationTest', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Setup the test environment and open necessary boxes
      await Hive.initFlutter();
      await Hive.openBox<Expense>('expenses');
      await Hive.openBox<ScheduledExpense>('scheduled_expenses');
      await Hive.openBox<Income>('income');

      // Build the visualizations page
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: visualizationsPage(),
        ),
      ));

      // Verify that the visualization page is displayed
      expect(find.text('Visualizations'), findsOneWidget);

      // Your other test assertions go here
    });
  });
}

void imageViewerTests() {
  testWidgets('ImageDialog displays image if imagePath exists', (WidgetTester tester) async {
    // Setup the test environment and create a test image file
    await tester.runAsync(() async {
      final tempDir = Directory.systemTemp.createTempSync();
      final imagePath = path.join(tempDir.path, 'test_image.png');
      final testImage = File(imagePath);
      await testImage.writeAsBytes(List<int>.generate(256, (index) => index % 256)); // Create a dummy image file

      // Build the ImageDialog widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageViewer(imagePath: imagePath),
          ),
        ),
      );

      // Verify that the image is displayed
      expect(find.byType(Image), findsOneWidget);

    });
  });

  testWidgets('ImageDialog displays no image message if imagePath is null or does not exist', (WidgetTester tester) async {
    // Build the ImageDialog widget with no image path
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ImageViewer(imagePath: null),
        ),
      ),
    );

    // Verify that the "No image available" message is displayed
    expect(find.text('No image available for this transaction'), findsOneWidget);
  });

  testWidgets('ImageDialog displays no image message if imagePath does not exist', (WidgetTester tester) async {
    // Build the ImageDialog widget with a non-existing image path
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ImageViewer(imagePath: '/non/existing/path.png'),
        ),
      ),
    );

    // Verify that the "No image available" message is displayed
    expect(find.text('No image available for this transaction'), findsOneWidget);
  });
}

void imageDialogTests() {
  testWidgets('ImagePickerDialog creation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Expenditure'));
    await tester.pump();

    await tester.tap(find.byKey(const Key('attachImageDialog')));
    await tester.pump();

    // Verify that the ImagePickerDialog is displayed
    expect(find.byType(ImagePickerDialog), findsOneWidget);

    final galleryButtonFinder = find.text('Attach Image from Gallery');
    expect(galleryButtonFinder, findsOneWidget);
    await tester.tap(galleryButtonFinder);
    await tester.pump();

    final captureButtonFinder = find.text('Capture Image');
    expect(captureButtonFinder, findsOneWidget);
    await tester.tap(captureButtonFinder);
    await tester.pump();

    await tester.tap(find.text('Close'));
    await tester.pump();

    // Verify that the dialog is closed
    expect(find.byType(ImagePickerDialog), findsNothing);
  });
}

void billsDialogTests() {
  testWidgets('billsDialog creation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Expenditure'));
    await tester.pump();

    await tester.tap(find.byKey(const Key('billsDialog')));
    await tester.pump();

    expect(find.byType(BillsDialog), findsOneWidget);

    final billMark = find.byKey(const Key('BillButton'));
    await tester.tap(billMark);

    final recurringMark = find.byKey(const Key('RecurringButton'));
    await tester.tap(recurringMark);

    final closeBill = find.byKey(const Key('closeBill'));
    await tester.tap(closeBill);




});
}


