import 'package:budget_manager/hive/transaction_box_model.dart';
import 'package:flutter/cupertino.dart';
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
  await Hive.deleteBoxFromDisk('income'); // to reset database if we do any changes run this once on the specified db and then comment out again.
  // its being deleted and created each run right now for demonstration

  // open each box at the start of the program. boxes are created once then stored to be opened at each startup the same way
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<ScheduledExpense>('scheduled_expenses');
  await Hive.openBox<Income>('income');

  // example:
  final box = Hive.box<Income>('income'); // can open already opened box (that was opened in main) anywhere else in the code with .box
  final exampleIncome = Income("Job", 2500, DateTime.now(), "monthly income");

  box.add(exampleIncome); // add object to add to next available spot, no key needed and is auto incremented index 0..1..2 etc
  // since our objects extend with hive object we can also do exampleIncome.save(). Each object is saved only once so we can apply changes like that if you change
  // an object member variable then call .save()
  // box.put("key",exampleIncome); using put we can specify our own keys too. but since we can only store each object uniquely running this wont work.

  print(box.values); // we can get lists with toList or iterate through values with a for loop as well

  for(var income in box.values){
    print('category: ${income.category}, amount: ${income.amount}, date: ${income.date}, note: ${income.note}');
  }

  runApp(const MyApp());
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
            const visualizationsPage();
          },
              child: const Text('Finance Visualization'))
        ],
      ),
      body: Column(
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
    );
  }
}
