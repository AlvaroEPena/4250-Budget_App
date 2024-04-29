import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Expenditure'),
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