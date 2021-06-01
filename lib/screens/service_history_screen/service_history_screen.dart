import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/providers/service_history_ticket.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_bloc.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_response.dart';
import 'package:hiinternet/screens/service_issue_screen/service_issue_screen.dart';
import 'package:hiinternet/widgets/service_history_item.dart';
import 'package:provider/provider.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';

class ServiceHistoryScreen extends StatefulWidget {
  static const routeName = '/service_history';

  @override
  _ServiceHistoryScreenState createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {

  final _serviceHistoryBloc = ServiceHistoryBloc();
  var userId;

  int changePageIndex = 0;

  @override
  void initState() {

    changePageIndex = 0;

    SharedPref.getData(key: SharedPref.user_id).then((value) {
      if (value != null && value.toString() != 'null') {
        userId = json.decode(value).toString();
        Map<String, String> map = {
          'user_id': userId,
          'app_version': app_version,
        };
        _serviceHistoryBloc.getServiceHistory(map);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  changePageIndex == 1 ? ServiceIssueScreen() : Scaffold(
      /*
        appBar: AppBar(
        title: Text(
          'My Complain',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),*/
      body: StreamBuilder<ResponseVO>(
        stream: _serviceHistoryBloc.serviceHistoryStream(),
        initialData: ResponseVO(message: MsgState.loading),
        builder: (context, snapshot) {
          ResponseVO resp = snapshot.data;
          if (resp.message == MsgState.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(resp.message == MsgState.error){
            return Center(
              //child: Text('Something wrong,try again...'),
              child: Text((SharedPref.IsSelectedEng()) ? StringsEN.something_wrong : StringsMM.something_wrong),
            );
          }
          else {
            List<ServiceHistoryVO> list = resp.data;
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return ServiceHistoryItems(
                  list[index],
                );
              },
              itemCount: list.length,
              //scrollDirection:Axis.horizontal,
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        //heroTag: 'service issue',
        heroTag: (SharedPref.IsSelectedEng()) ? StringsEN.service_issue : StringsMM.service_issue,
        backgroundColor: Colors.indigo,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          //Navigator.pushReplacementNamed(context, ServiceIssueScreen.routeName);
          setState(() {
            changePageIndex = 1;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _serviceHistoryBloc.dispose();
    super.dispose();
  }
}
