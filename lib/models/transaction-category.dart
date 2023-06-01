import 'package:flutter/material.dart';

class Category{
  String name;
  IconData icon;
  Color color;

  Category(this.name, this.icon, this.color);
}

final List<Category> categoryList = [
  Category("Salary", Icons.attach_money, Colors.lime),
  Category("Personal", Icons.person, Colors.red),
  Category("House-hold", Icons.home, Colors.yellow),
  Category("Family", Icons.family_restroom, Colors.lightGreenAccent),
  Category("Friends", Icons.group, Colors.orangeAccent),
  Category("Medical", Icons.healing, Colors.yellowAccent),
  Category("Food", Icons.fastfood, Colors.purpleAccent),
  Category("Clothing", Icons.checkroom, Colors.indigoAccent),
  Category("Education", Icons.school, Colors.cyanAccent),
  Category("Entertainment", Icons.theater_comedy, Colors.redAccent),
  Category("Travel", Icons.airplanemode_active, Colors.pinkAccent),
  Category("Other", Icons.shuffle, Colors.green),
];