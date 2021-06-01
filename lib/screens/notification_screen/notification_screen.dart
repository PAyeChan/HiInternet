import 'package:flutter/material.dart';
import 'package:hiinternet/widgets/notification_item.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';

class NotificationScreen extends StatelessWidget {

  static const routeName = '/notification_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        toolbarHeight: 110,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                width: 100,

                child: Image.asset('assets/images/hi_internet_logo.png',fit: BoxFit.fill,),
              ),
            ),
          ],
        ),

      ),*/
      body: ListView.builder(itemBuilder: (ctx,index){
        return NotificationItems();
      },itemCount: 5,),
    );
  }
}
