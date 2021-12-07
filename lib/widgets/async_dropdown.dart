import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';

class AsyncDropdown extends StatefulWidget {
  const AsyncDropdown({
    Key key,
    this.label,
    this.future,
    this.onChange,
  }) : super(key: key);

  final String label;
  final Function future;
  final Function onChange;

  @override
  _AsyncDropdownState createState() => _AsyncDropdownState();
}

class _AsyncDropdownState extends State<AsyncDropdown> {
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
        displayItemFn: (dynamic item) => Text(
          (item ?? {})['name'] ?? '',
          style: TextStyle(fontSize: 16),
        ),
        onSaved: (dynamic str) {},
        onChanged: widget.onChange,
        filterFn: (dynamic item, str) =>
            item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
        findFn: (dynamic str) async {
          List list = await widget.future();

          return list.map((e) {
            return {'id': e.id, 'name': e.name};
          }).toList();
        },
        decoration: InputDecoration(
          labelText: widget.label,
          border: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
}
