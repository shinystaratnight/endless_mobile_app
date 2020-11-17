import 'package:flutter/material.dart';

class FormSelect extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final int columns;
  final bool multiple;
  final Function onSave;
  final Function onChanged;
  final String title;

  FormSelect({
    this.options,
    this.columns,
    @required this.multiple,
    this.onSave,
    this.title,
    this.onChanged,
  });

  @override
  _FormSelectState createState() => _FormSelectState();
}

class _FormSelectState extends State<FormSelect> {
  List<Option> _multipleValue = [];
  Option _value;

  List<List<Option>> _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<List<Option>> data = [];
    int row = 0;
    if (widget.options != null) {
      for (int i = 0; i < widget.options.length; i++) {
        Option option = Option(
          label: widget.options[i]['label'],
          value: widget.options[i]['value'],
        );

        if (i % widget.columns == 0) {
          data.add([option]);

          if (i != 0) {
            row++;
          }
        } else {
          data.elementAt(row).add(option);
        }
      }
    }

    _data = data;
  }

  _selectOption(Option option) {
    if (widget.multiple) {
      if (_multipleValue.contains(option)) {
        _multipleValue.remove(option);
      } else {
        _multipleValue.add(option);
      }
    } else {
      _value = option;
    }

    setState(() {
      _value = _value;
    });

    if (widget.onChanged != null) {
      if (widget.multiple) {
        widget.onChanged(
            _multipleValue.map((Option option) => option.value).toList());
      } else {
        widget.onChanged(_value.value);
      }
    }
  }

  _buildOption(Option option) {
    return GestureDetector(
      onTap: () => _selectOption(option),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _value == option || _multipleValue.contains(option)
              ? Colors.blue
              : Colors.white,
          border: Border.all(
            color: _value == option || _multipleValue.contains(option)
                ? Colors.blue
                : Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                option.label,
                style: TextStyle(
                  fontSize: 16.0,
                  color: _value == option || _multipleValue.contains(option)
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _data.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: e.map((e) {
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: _buildOption(e),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class Option {
  final dynamic value;
  final String label;

  Option({
    this.value,
    this.label,
  });
}
