import 'package:flutter/material.dart';

class YearPickerWidget extends StatefulWidget {
  final int pickerYear;
  final Function(int) onYearChanged;
  final VoidCallback onYearTapped;
  final List<Widget> Function() generateMonths;

  const YearPickerWidget({
    super.key,
    required this.pickerYear,
    required this.onYearChanged,
    required this.onYearTapped,
    required this.generateMonths,
  });

  @override
  _YearPickerWidgetState createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  late int _pickerYear;

  @override
  void initState() {
    super.initState();
    _pickerYear = widget.pickerYear;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _pickerYear = _pickerYear - 1;
                        widget.onYearChanged(_pickerYear);
                      });
                    },
                    icon: const Icon(Icons.navigate_before_rounded),
                  ),
                  Expanded(
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.onYearTapped();
                          });
                        },
                        child: Text(_pickerYear.toString()),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _pickerYear = _pickerYear + 1;
                        widget.onYearChanged(_pickerYear);
                      });
                    },
                    icon: const Icon(Icons.navigate_next_rounded),
                  ),
                ],
              ),
              ...widget.generateMonths(),
            ],
          ),
    );
  }
}