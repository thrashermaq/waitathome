import 'package:flutter/material.dart';

class MarkerData {
  String shopName;
  int peopleCount;
  int queueCount;
  Color statusColor;
  bool isFavourite;

  MarkerData(
      {this.shopName,
      this.peopleCount,
      this.queueCount,
      this.statusColor,
      this.isFavourite});
}
