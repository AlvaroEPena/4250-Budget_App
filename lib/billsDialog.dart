import 'package:flutter/material.dart';

class BillsDialog extends StatefulWidget {
  final Function onBillSelected;
  final Function onRecurringSelected;
  bool isBill;
  bool recurring;

  BillsDialog({
    super.key,
    required this.onBillSelected,
    required this.onRecurringSelected,
    required this.isBill,
    required this.recurring
  });

  @override
  _BillsDialogState createState() => _BillsDialogState();
}

class _BillsDialogState extends State<BillsDialog> {

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
            value: widget.isBill,
            onChanged: (bool? value) {
              setState(() {
                widget.isBill = value ?? false;
                widget.onBillSelected(widget.isBill);
              });
            },
          ),
          CheckboxListTile(
            key: const Key('RecurringButton'),
            title: const Text('Recurring'),
            value: widget.recurring,
            onChanged: (bool? value) {
              setState(() {
                widget.recurring = value ?? false;
                widget.onRecurringSelected(widget.recurring);
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
