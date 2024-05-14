import 'package:budget_manager/hive/transaction_box_operations.dart';
import 'package:budget_manager/transaction_widgets/transactionHistoryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'billsDialog.dart';
import 'imageDialog.dart';
import 'dart:io';

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
  bool _recurring = false;
  File? _image;

  void parentSetState(){setState(() {}); return;}

  void _openImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerDialog(
          onImageSelected: (File? image) {
            setState(() {
              _image = image;
            });
          },
        );
      },
    );
  }

  void _openBillsDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BillsDialog(
          onBillSelected: (){
            setState(() {
              selectedCategory = 'Bill';
            });
          },
          onRecurringSelected: (bool recurring) {
            _recurring = recurring;
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to the start and end of the row
        children: [
              const Expanded(child: Text('Expenditure')),
              Flexible( child: Column(children: [IconButton(
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

      ))]),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: [
              Expanded(
                child: TextFormField(
                  key:const Key('amountField'),
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
              Flexible( child: ElevatedButton(
                key: const Key('addExpenditureButton'),
                onPressed: () {
                  if (amount.isNotEmpty) {
                    saveExpenseLog(double.parse(amount), DateTime.now(), notes, selectedCategory, _recurring);
                    Navigator.pop(context); // pop if not empty amount or else keep form there
                  }
                },
                child: const Text('Add'),
              ),
              )],),
            Column(
              children: widget.expendCategories.map((category) {
                return CheckboxListTile(
                  key: Key(category),
                  title: Text(category),
                  value: selectedCategory == category,
                  onChanged: (bool? value) {
                    setState(() {
                      selectedCategory = category;
                      _recurring = false;
                    }
                    );
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _openBillsDialog,
              child: const Text('Bills'),
            ),
            ElevatedButton(
              key: const Key('attachImageDialog'),
              onPressed: _openImagePickerDialog,
              child: const Text('Attach Image'),
            ),
            _image != null
                ? Image.file(_image!) // testing callback, have image here for later to store permanently
                : const Text('No image selected'),
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
                Flexible(child: ElevatedButton(
                  key: const Key('addCategoryButton'),
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
                )],
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
    );
  }
}