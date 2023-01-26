import 'package:flutter/material.dart';
class NextPageButton extends StatelessWidget {
  const NextPageButton({
    Key key,
    this.color,
    this.text,
    this.func
  }) : super(key: key);
 final Color color;
 final String text;
 final VoidCallback func;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: func,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
