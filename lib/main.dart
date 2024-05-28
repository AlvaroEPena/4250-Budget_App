import 'package:budget_manager/hive/transaction_box_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'expenditureDialog.dart';
import 'incomeDialog.dart';
import 'visualizationsPage.dart';
import 'getTotalAmounts.dart';

void main() async {
  await Hive.initFlutter(); // init hive, WidgetsFlutterBinding.ensureInitialized() called here already

  // register the adapters
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(ScheduledExpenseAdapter());
  Hive.registerAdapter(IncomeAdapter());
  // to reset database if we do any changes run this once on the specified db and then comment out again.
  // its being deleted and created each run right now for demonstration
  // uncommented delete for graph demonstrations
  await Hive.deleteBoxFromDisk('income');
  await Hive.deleteBoxFromDisk('expenses');
  await Hive.deleteBoxFromDisk('scheduled_expenses');

  // open each box at the start of the program. boxes are created once then stored to be opened at each startup the same way
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<ScheduledExpense>('scheduled_expenses');
  await Hive.openBox<Income>('income');

  runApp(const MyApp());

  final box = Hive.box<Income>('income');
  final box2 = Hive.box<Expense>('expenses');

  List<Income> testIncome = [
    Income(1.0, DateTime(2024, 2, 1), 'Income Note 1', null, category: 'Gift'),
    Income(20.0, DateTime(2024, 2, 20), 'Income Note 2', null, category: 'Job'),
    Income(250.0, DateTime(2024, 3, 10), 'Income Note 3', null, category: 'Ebay'),
    Income(25.0, DateTime(2024, 3, 20), 'Income Note 4', null, category: 'Job'),
    Income(260.0, DateTime(2024, 4, 1), 'Income Note 5', null, category: 'Gift'),
    Income(265.0, DateTime(2024, 4, 10), 'Income Note 6', null, category: 'Ebay'),
    Income(27.0, DateTime(2024, 4, 20), 'Income Note 7', null, category: 'Job'),
    Income(27.0, DateTime(2024, 5, 1), 'Income Note 8', null, category: 'Job'),
    Income(28.0, DateTime(2024, 5, 10), 'Income Note 9', null, category: 'Gift'),
    Income(28.0, DateTime(2024, 5, 20), 'Income Note 10', null, category: 'Ebay'),
    Income(29.0, DateTime(2024, 6, 1), 'Income Note 11', null, category: 'Job'),
    Income(29.0, DateTime(2024, 6, 2), 'Income Note 12', null, category: 'Gift'),
    Income(29.0, DateTime(2024, 6, 3), 'Income Note 13', null, category: 'Ebay'),
    Income(29.0, DateTime(2024, 6, 4), 'Income Note 14', null, category: 'Job'),
    Income(29.0, DateTime(2024, 6, 5), 'Income Note 15', null, category: 'Gift'),
    Income(29.0, DateTime(2024, 6, 6), 'Income Note 16', null, category: 'Ebay'),
    Income(29.0, DateTime(2024, 6, 7), 'Income Note 17', null, category: 'Job'),
  ];

  List<Expense> testExpense = [
  Expense(150.0, DateTime(2024, 2, 1), 'Test Expense 1', null, recurring: false, category: 'Food & Dining'),
  Expense(20.0, DateTime(2024, 2, 20), 'Test Expense 2', null, recurring: true, category: 'Auto & Transport'),
  Expense(250.0, DateTime(2024, 3, 10), 'Test Expense 3', null, recurring: false, category: 'Leisure'),
  Expense(25.0, DateTime(2024, 3, 20), 'Test Expense 4', null, recurring: true, category: 'Other'),
  Expense(260.0, DateTime(2024, 4, 1), 'Test Expense 5', null, recurring: false, category: 'Food & Dining'),
  Expense(265.0, DateTime(2024, 4, 10), 'Test Expense 6', null, recurring: true, category: 'Auto & Transport'),
  Expense(27.0, DateTime(2024, 4, 20), 'Test Expense 7', null, recurring: false, category: 'Leisure'),
  Expense(27.0, DateTime(2024, 5, 1), 'Test Expense 8', null, recurring: true, category: 'Other'),
  Expense(28.0, DateTime(2024, 5, 10), 'Test Expense 9', null, recurring: false, category: 'Food & Dining'),
  Expense(28.0, DateTime(2024, 5, 20), 'Test Expense 10', null, recurring: true, category: 'Auto & Transport'),
  Expense(29.0, DateTime(2024, 6, 1), 'Test Expense 11', null, recurring: false, category: 'Leisure'),
  Expense(29.0, DateTime(2024, 6, 2), 'Test Expense 12', null, recurring: true, category: 'Other'),
  Expense(29.0, DateTime(2024, 6, 3), 'Test Expense 13', null, recurring: false, category: 'Food & Dining'),
  Expense(29.0, DateTime(2024, 6, 4), 'Test Expense 14', null, recurring: true, category: 'Auto & Transport'),
  Expense(29.0, DateTime(2024, 6, 5), 'Test Expense 15', null, recurring: false, category: 'Leisure'),
  Expense(29.0, DateTime(2024, 6, 6), 'Test Expense 16', null, recurring: true, category: 'Other'),
  Expense(29.0, DateTime(2024, 6, 7), 'Test Expense 17', null, recurring: false, category: 'Food & Dining'),
  ];

  // Add testIncome into incomeBox
  for (var income in testIncome) {
    box.add(income);
  }

  // Add testExpense into expenseBox
  for (var expense in testExpense) {
    box2.add(expense);
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Budget Tracker', expendCategories: ['Food & Dining', 'Auto & Transport','Leisure', 'Other'], incomeCategories: ['Job', 'Ebay', 'Gift']),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.expendCategories, required this.incomeCategories});

  final String title;

  final List<String> expendCategories;
  final List<String> incomeCategories;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          TextButton( onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const visualizationsPage(),
                ),
                );},
              child: const Text('Finance Visualization'))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text('Net Worth'),
                              content: TotalAmounts()
                            );
                        }
                    );
                  },
                  child: const Text('Net Worth')
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return IncomeDialog(incomeCategories: widget.incomeCategories);
                        },
                      );
                    },
                    child: const Text('Income'),
                  ),ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ExpenditureDialog(expendCategories: widget.expendCategories);
                        },
                      );
                    },
                    child: const Text('Expenditure'),
                  )],
              ),
          ],
        ),
      )
    );
  }
}
