

import 'package:flutter/material.dart';

void showSnackBar(context,content){

  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(content)));
}