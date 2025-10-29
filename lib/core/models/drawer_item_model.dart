import 'package:flutter/material.dart';

class DrawerItemModel {
  final String title;
  final IconData icon;
  final Widget? pageWidget;
  final Function()? onClick;

  DrawerItemModel({required this.title, required this.icon, this.pageWidget, this.onClick});
}