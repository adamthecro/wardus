import 'package:flutter/material.dart';

class ftext extends StatelessWidget {
  String _text;
  double _size;
  Color _color;
  FontWeight _weight;

  ftext(this._text, this._size, this._color, this._weight);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Text(
      _text,
      style: TextStyle(
        fontSize: width * _size / 500,
        color: _color,
        fontWeight: _weight,
      ),
    );
  }
}
