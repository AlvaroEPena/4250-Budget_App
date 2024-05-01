import 'package:budget_manager/hive/transaction_box_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'expenditureDialog.dart';
import 'incomeDialog.dart';
import 'visualizationsPage.dart';
void main() async {
  await Hive.initFlutter(); // init hive, WidgetsFlutterBinding.ensureInitialized() called here already

  // register the adapters
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(ScheduledExpenseAdapter());
  Hive.registerAdapter(IncomeAdapter());
  // to reset database if we do any changes run this once on the specified db and then comment out again.
  // its being deleted and created each run right now for demonstration
  //await Hive.deleteBoxFromDisk('income');
  //await Hive.deleteBoxFromDisk('expenses');
  //await Hive.deleteBoxFromDisk('scheduled_expenses');

  // open each box at the start of the program. boxes are created once then stored to be opened at each startup the same way
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<ScheduledExpense>('scheduled_expenses');
  await Hive.openBox<Income>('income');

  runApp(const MyApp());

  final box = Hive.box<Income>('income');
  final box2 = Hive.box<Expense>('expenses');
  for(var income in box.values){
    print('category: ${income.category}, amount: ${income.amount}, date: ${income.date}, note: ${income.note}');
  }

  for(var expense in box2.values){
    print('category: ${expense.category}, amount: ${expense.amount}, date: ${expense.date}, note: ${expense.note}, recurring: ${expense.recurring}');
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
      home: const MyHomePage(title: 'Budget Tracker', expendCategories: ['Food & Dining', 'Auto & Transport','Leisure', 'Other'], incomeCategories: ['Job', 'Ebay', 'Gift']),
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
            Center(
              child: ButtonBar(
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
            )
          ],
        ),
      )
    );
  }
}
