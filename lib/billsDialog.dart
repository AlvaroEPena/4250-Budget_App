import 'package:flutter/material.dart';

class BillsDialog extends StatefulWidget {
  final Function onBillSelected;
  final Function onRecurringSelected;

  const BillsDialog({
    super.key,
    required this.onBillSelected,
    required this.onRecurringSelected,
  });

  @override
  _BillsDialogState createState() => _BillsDialogState();
}

class _BillsDialogState extends State<BillsDialog> {
  bool isBill = false;
  bool recurring = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bills'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            key: const Key('BillButton'),
            title: const Text('Mark as Bill'),
            value: isBill,
            onChanged: (bool? value) {
              setState(() {
                isBill = value ?? false;
                if (isBill) {
                  widget.onBillSelected();
                }
              });
            },
          ),
          CheckboxListTile(
            key: const Key('RecurringButton'),
            title: const Text('Recurring'),
            value: recurring,
            onChanged: (bool? value) {
              setState(() {
                recurring = value ?? false;
                widget.onRecurringSelected(recurring);
              });
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          key: const Key('closeBill'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
