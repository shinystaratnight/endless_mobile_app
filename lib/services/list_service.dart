import 'dart:async';

import 'package:piiprent/constants.dart';

class ListService {
  final Function action;
  Map<String, dynamic> params;

  int _limit = listLimit;
  int _offset = 0;
  int _count = 0;
  List<dynamic> _data;

  get canFetchMore {
    return _offset < _count;
  }

  StreamController _streamController = StreamController();
  StreamController _fetchStreamController = StreamController.broadcast();

  get stream {
    return _streamController.stream;
  }

  get fetchStream {
    return _fetchStreamController.stream;
  }

  ListService({
    this.action,
    this.params = const <String, dynamic>{},
  }) {
    start();
    _fetchStreamController.add(false);
  }

  start() async {
    try {
      var data = await action({
        ...params,
        "limit": _limit.toString(),
        "offset": _offset.toString(),
      });
      _count = data['count'];
      _offset = _offset + data['list'].length;
      _data = data['list'];
      _streamController.add(_data);
    } catch (e) {
      print(e);
    }
  }

  fetchMore() async {
    _fetchStreamController.add(true);

    try {
      var data = await action(params);
      _data = [..._data, ...data['list']];
      _offset = _offset + data['list'].length;
      _streamController.add(data['list']);
    } catch (e) {
      print(e);
    }
  }
}
