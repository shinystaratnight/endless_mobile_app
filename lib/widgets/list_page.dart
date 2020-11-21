import 'package:flutter/material.dart';
import 'package:piiprent/screens/more_button.dart';
import 'package:piiprent/services/list_service.dart';

class ListPage<T> extends StatefulWidget {
  final Function action;
  final Map<String, dynamic> params;
  final Function getChild;
  final Stream updateStream;

  ListPage({
    @required this.action,
    @required this.getChild,
    this.params,
    this.updateStream,
  });

  @override
  _ListPageState<T> createState() => _ListPageState<T>();
}

class _ListPageState<T> extends State<ListPage<T>> {
  ListService _listService;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> params;

    if (widget.params == null) {
      params = Map();
    }

    _listService = ListService(action: widget.action, params: params);

    if (widget.updateStream != null) {
      widget.updateStream.listen((params) {
        _listService.updateParams(params, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_listService == null) {
      print('empty');
      return Container(
        width: 0,
        height: 0,
      );
    }

    return StreamBuilder(
      stream: _listService.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<T> data = snapshot.data;

          if (data.length == 0) {
            return Center(
              child: Text('No Data'),
            );
          }

          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == data.length) {
                return MoreButton(
                  isShow: _listService.canFetchMore,
                  stream: _listService.fetchStream,
                  onPressed: () => _listService.fetchMore(),
                );
              }

              T instance = data[index];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: widget.getChild(instance),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Container(
            child: Text('Something went wrong!'),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
