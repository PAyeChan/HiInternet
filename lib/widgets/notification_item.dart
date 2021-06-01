import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          child: Icon(
            Icons.notifications,
            color: Colors.blueAccent,
          ),
        ),
        title: Text(
          'Invoice Noti',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        subtitle: Text(
          'Invoice NotiInvoice NotiInvoice NotiInvoice NotiInvoice NotiInvoice'
          ' NotiInvoice NotiInvoice NotiInvoice NotiInvoice Noti',
          style: TextStyle(fontSize: 13, color: Colors.black45),
        ),
        trailing: Text('19/Jan/2020'),
      ),
    );
  }
}
