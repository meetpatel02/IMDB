import 'package:flutter/material.dart';

class textfield extends StatelessWidget {
  var controller;
  var hintText;
  var textInputAction;
  var keyboardType;
  var inputFormatters;
  var validator;
  var readOnly;
  var maxLines;
  var fillColor;
  bool? obscuretext;
  Color? color;
  var suffixIcon;
  var decoration;
  textfield({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.textInputAction,
    required this.keyboardType,
     this.validator,
    this.inputFormatters,
    this.readOnly,
    this.maxLines,
    this.fillColor,
    this.obscuretext,
    this.color,
    this.suffixIcon,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? '',
      obscureText: obscuretext ?? false ,
      controller: controller,
      cursorColor: Colors.black,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          )),

    );
  }
}

