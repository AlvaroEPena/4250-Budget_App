// ignore_for_file: unused_import
import 'package:budget_manager/expenditureDialog.dart';
import 'package:budget_manager/hive/transaction_box_model.dart';
import 'package:budget_manager/hive/transaction_box_operations.dart';
import 'package:budget_manager/incomeDialog.dart';
import 'package:budget_manager/main.dart';
import 'package:budget_manager/visualizationsPage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('IncomeDialog creation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final incomeButtonFind = find.text('Income');
    expect(incomeButtonFind, findsOneWidget);
    await tester.tap(incomeButtonFind);
    await tester.pump();
    expect(find.byType(IncomeDialog), findsOneWidget);
  });
}