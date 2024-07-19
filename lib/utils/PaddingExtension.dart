import 'package:flutter/material.dart';

extension Paddingextension on Widget {
  Widget addPadding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }
}
