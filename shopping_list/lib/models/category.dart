import 'package:flutter/material.dart';
enum Categories{
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}
class Category {
  const Category(this.identifier, this.color);
  final String identifier;
  final Color color;
}