
import 'package:flutter/material.dart';
AppBar buildAppBar(bool isIcon) {
  return AppBar(
    leading: isIcon ? Icon(Icons.arrow_back) : SizedBox.shrink(),
    actions: [
      Row(
        children: [
          Icon(Icons.add_alert_rounded,size: 20),
          SizedBox(width: 5),
          CircleAvatar(
            radius: 12,
            child: Text('A',style: TextStyle(fontSize: 8),),
          ),SizedBox(width: 5),
          Text('Admin',style: TextStyle(fontSize: 8,fontWeight: FontWeight.w600)),
          SizedBox(width: 5),
        ],
      )
    ],
  );
}