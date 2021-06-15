import 'package:flutter/material.dart';
import 'package:hiinternet/widgets/notification_item.dart';

import 'package:hiinternet/data/database_util.dart';
import 'package:hiinternet/data/notification_model.dart';

class NotificationScreen extends StatefulWidget {

  static const routeName = '/notification_screen';

  @override
  _NotificationScreenScreenState createState() => _NotificationScreenScreenState();
}

class _NotificationScreenScreenState extends State<NotificationScreen> {

  bool bDataRetrievedLately = false;
  List<NotiModel> SavedNotiModels;

  @override
  void initState() {
    super.initState();

    Future<List<NotiModel>> notimodels = DatabaseUtil().getAllNotiModels();
    notimodels.then((value) {
      SavedNotiModels = value;
      setState(() {
        bDataRetrievedLately = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(bDataRetrievedLately) {
      bDataRetrievedLately = false;

      return Scaffold(
        body: ListView.builder(
          itemCount: SavedNotiModels.length,
          itemBuilder: (ctx,index){
            return NotificationItem(SavedNotiModels[index]);
          },
        ),
      );
    }

    return Container();
  }


}
