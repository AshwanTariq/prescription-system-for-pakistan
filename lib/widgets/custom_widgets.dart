import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mywidgets
{
  static PreferredSizeWidget getAppBar(String data)
  {
    return AppBar(
      title: Text(data),
    );
  }
}