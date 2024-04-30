import 'package:budget_manager/hive/transaction_box_operations.dart';
import 'package:budget_manager/transaction_widgets/transactionHistoryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenditureDialog extends StatefulWidget {
  final List<String> expendCategories;

  const ExpenditureDialog({super.key, required this.expendCategories});

  @override
  _ExpenditureDialogState createState() => _ExpenditureDialogState();
}

class _ExpenditureDialogState extends State<ExpenditureDialog> {
  String amount = '';
  String newCategory = '';
  String notes = '';
  String? selectedCategory;
  bool recurring = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to the start and end of the row
        children: [
          const Text('Expenditures'),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionHistoryPage(transactionType: 'expenses'),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                iconSize: 30,
              ),
              const Text(
                'History', // Caption for the button
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      amount = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true), // Allows decimal numbers
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (amount.isNotEmpty) {
                    saveExpenseLog(double.parse(amount), DateTime.now(), notes, selectedCategory, recurring);
                    Navigator.pop(context); // pop if not empty amount or else keep form there
                  }
                },
                child: const Text('Add'),
              ),
            ],),
            Column(
              children: widget.expendCategories.map((category) {
                return CheckboxListTile(
                  title: Text(category),
                  value: selectedCategory == category,
                  onChanged: (bool? value) {
                    setState(() {
                      selectedCategory = category;
                    }
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        newCategory = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Add Category',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newCategory.isNotEmpty) {
                      setState(() {
                        widget.expendCategories.add(newCategory);
                        newCategory = '';
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  notes = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Notes',
              ),
            )],
        ),
      ),
    );
  }
}