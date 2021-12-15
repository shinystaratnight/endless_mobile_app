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
  }) : super(key: key);

  final String label;
  final Function future;
  final Function onChange;
  final Function validator;
  final Function onSaved;

  @override
  _AsyncDropdownState createState() => _AsyncDropdownState();
}

class _AsyncDropdownState extends State<AsyncDropdown> {
  List _options;
  String _error;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownFormField(
        dropdownHeight: 180,
        dropdownItemFn: (
          dynamic item,
          int position,
          bool focused,
          bool selected,
          Function() onTap,
        ) =>
            ListTile(
          title: Text(item['name']),
          tileColor: focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
          onTap: onTap,
        ),
        validator: (dynamic val) {
          if (widget.validator != null) {
            var error = widget.validator(val);

            setState(() {
              _error = error;
            });

            return error;
          }

          return null;
        },
        displayItemFn: (dynamic item) => Text(
          (item ?? {})['name'] ?? '',
          style: TextStyle(fontSize: 16),
        ),
        onSaved: (dynamic val) {
          widget.onSaved(val);
        },
        onChanged: widget.onChange,
        filterFn: (dynamic item, str) =>
            item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
        findFn: (dynamic str) async {
          Scrollable.ensureVisible(context);

          return _options;
        },
        decoration: InputDecoration(
          errorText: _error,
          labelText:
              '${widget.label} ${widget.validator == requiredValidator ? '*' : ''}',
          border: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
}
