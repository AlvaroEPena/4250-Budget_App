import 'package:flutter/material.dart';

class IncomeDialog extends StatefulWidget {
  final List<String> incomeCategories;

  const IncomeDialog({super.key, required this.incomeCategories});

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
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (amount.isNotEmpty) {
                    setState(() {
                      // ADD AMOUNT, NOTE, CATEGORY, DATE TO DATABASE
                    });
                  }
                },
                child: const Text('Add'),
              ),
            ],),
            Column(
              children: widget.incomeCategories.map((category) {
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