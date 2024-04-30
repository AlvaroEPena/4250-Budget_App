import 'package:budget_manager/hive/transaction_box_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncomeDialog extends StatefulWidget {
  final List<String> incomeCategories;

  IncomeDialog({super.key, required this.incomeCategories});

  @override
  _IncomeDialogState createState() => _IncomeDialogState();
}

class _IncomeDialogState extends State<IncomeDialog> {
  String amount = '';
  String newCategory = '';
  String notes = '';
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Income'),
      content: SingleChildScrollView( child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: [
              Expanded(
                child: TextFormField(
                  key: const Key('amountField'),
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
                    saveIncomeLog(double.parse(amount), DateTime.now(), notes, selectedCategory);
                    Navigator.pop(context); // pop if not empty amount or else keep form there
                  }
                },
                child: const Text('Add'),
              ),
            ],),
            Column(
              children: widget.incomeCategories.map((category) {
                return CheckboxListTile(
                  key: Key(category),
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
                    key: const Key('addCategoryField'),
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
                  key: const Key('addCategoryButton'),
                  onPressed: () {
                    if (newCategory.isNotEmpty) {
                      setState(() {
                        widget.incomeCategories.add(newCategory);
                        newCategory = '';
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          TextFormField(
            key: const Key('notesTextField'),
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
    ));
  }
}