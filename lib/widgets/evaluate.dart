import 'package:flutter/material.dart';

class Evaluate extends StatefulWidget {
  final int score;
  final bool active;
  final Function onChange;

  Evaluate({this.score, this.active, this.onChange});

  @override
  _EvaluateState createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  List<bool> _scoreMap = [];

  Widget _buildStar(bool active, int index) {
    return GestureDetector(
      onTap: widget.active ? () => widget.onChange(index + 1) : () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Icon(Icons.star,
            size: 22, color: active ? Colors.amber : Colors.grey),
      ),
    );
  }

  @override
  void initState() {
    print(widget.score);
    _scoreMap = [];
    for (var i = 0; i < 5; i++) {
      _scoreMap.add(i < widget.score);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Evaluate',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children:
                  _scoreMap.map((active) => _buildStar(active, 1)).toList(),
            ),
          )
        ],
      ),
    );
  }
}
