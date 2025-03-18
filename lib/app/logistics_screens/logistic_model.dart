import 'package:customer/app/logistics_screens/check_rates.dart';
import 'package:customer/app/logistics_screens/create_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogisticModel {
  final String title;
  final Widget icon;
  final Widget component;

  LogisticModel({
    required this.component,
    required this.icon,
    required this.title,
  });
}

List<LogisticModel> logisticActions = [
  LogisticModel(
    component: const CreateParcelOrder(),
    icon: const Icon(CupertinoIcons.add_circled),
    title: "Create Order",
  ),
  LogisticModel(
    component: CheckParcelRates(),
    icon: const Icon(CupertinoIcons.doc_text_search),
    title: "Check Rates",
  ),
];

  // LogisticModel(
  //   component: const SizedBox(),
  //   icon: const Icon(Icons.help_outline_rounded),
  //   title: "Help Center",
  // ),

  // LogisticModel(
  //   component: const SizedBox(),
  //   icon: const Icon(Icons.track_changes_rounded),
  //   title: "Track Order",
  // ),
