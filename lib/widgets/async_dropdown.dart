import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:piiprent/helpers/validator.dart';

class AsyncDropdown extends StatefulWidget {
  const AsyncDropdown({
    Key key,
    this.label,
    this.future,
    this.onChange,
    this.validator,
    this.onSaved,
    this.multiple,
  }) : super(key: key);

  final String label;
  final Function future;
  final Function onChange;
  final Function validator;
  final Function onSaved;
  final bool multiple;

  @override
  _AsyncDropdownState createState() => _AsyncDropdownState();
}

class _AsyncDropdownState extends State<AsyncDropdown> {
  List _options;
  String _error;
  List<dynamic> _multipleValue;

  _fetchOptions() async {
    try {
      List list = await widget.future();

      setState(() {
        _options = list.map((e) => ({'id': e.id, 'name': e.name})).toList();
      });
    } catch (e) {
      _options = [];
    }
  }

  @override
  void initState() {
    _fetchOptions();
    if (widget.multiple == true) {
      _multipleValue = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownFormField(
            dropdownItemFn: (
              dynamic item,
              int position,
              bool focused,
              bool selected,
              Function() onTap,
            ) {
              return ListTile(
                title: Text(
                  item['name'],
                  style: TextStyle(
                    color: selected ? Colors.blueAccent : Colors.grey[900],
                  ),
                ),
                tileColor:
                    focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
                onTap: widget.multiple != true
                    ? onTap
                    : () {
                        setState(() {
                          _multipleValue.add(item);
                        });
                        onTap();
                      },
              );
            },
            validator: (dynamic val) {
              if (widget.validator != null) {
                var error;

                if (widget.multiple == true) {
                  error = emptyValidator(_multipleValue);
                } else {
                  error = widget.validator(val);
                }

                setState(() {
                  _error = error;
                });

                return error;
              }

              return null;
            },
            displayItemFn: (dynamic item) {
              if (widget.multiple == true) {
                return Text('');
              } else {
                return Text(
                  (item ?? {})['name'] ?? '',
                  style: TextStyle(fontSize: 16),
                );
              }
            },
            onSaved: (dynamic val) {
              if (widget.multiple == true) {
                widget.onSaved(_multipleValue);
              } else {
                widget.onSaved(val);
              }
            },
            onChanged: widget.onChange,
            filterFn: (dynamic item, str) =>
                item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            findFn: (dynamic str) async {
              await Scrollable.ensureVisible(context);

              return _options;
            },
            selectedFn: widget.multiple == true
                ? (dynamic _, dynamic val) {
                    return _multipleValue
                        .where((element) => element['id'] == val['id'])
                        .isNotEmpty;
                  }
                : null,
            decoration: InputDecoration(
              errorText: _error,
              labelText:
                  '${widget.label} ${widget.validator == requiredValidator ? '*' : ''}',
              border: UnderlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
          ),
        ),
        if (_multipleValue != null && _multipleValue.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ..._multipleValue
                    .map(
                      (dynamic item) => Container(
                        padding: EdgeInsets.all(4.0),
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[600]),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['name']),
                            IconButton(
                              constraints: BoxConstraints.loose(Size(30, 30)),
                              padding: EdgeInsets.all(4.0),
                              splashRadius: 20.0,
                              onPressed: () {
                                setState(() {
                                  _multipleValue = _multipleValue
                                      .where((element) =>
                                          element['id'] != item['id'])
                                      .toList();
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                size: 20.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          )
      ],
    );
  }
}
