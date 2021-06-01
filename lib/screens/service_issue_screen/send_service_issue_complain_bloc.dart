import 'dart:convert';
import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/service_issue_screen/service_complain_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hiinternet/helpers/shared_pref.dart';


class SendServiceComplainBloc extends BaseNetwork{


  // ignore: close_sinks
  PublishSubject<ResponseVO> sendComplainController = PublishSubject();

  Stream<ResponseVO> serviceComplainStream() => sendComplainController.stream;


  sendServiceComplain(Map<String,String> map){

    ResponseVO resp = ResponseVO(message: MsgState.loading);
    sendComplainController.sink.add(resp);

    SharedPref.getData(key: SharedPref.token).then((value) {
      if(value != null) {

        postReq(SAVE_SERVICE_TICKET_URL, params: map, token: json.decode(value), onDataCallBack:(ResponseVO resp) {

          print(resp.data.toString());
          resp.data = ServiceComplainResponseVO.fromJson(resp.data);
          ServiceComplainResponseVO serviceComplainVO = resp.data;
          print(serviceComplainVO.status);

          if (resp.data['status'] == 'Success') {
            resp = ResponseVO(message: MsgState.success);//payment list
          }
          else if (resp.data['status'] == 'Fail') {
            resp = ResponseVO(message: MsgState.error);//payment list
          }

          sendComplainController.sink.add(resp);

        }, onErrorCallBack: (ResponseVO resp) {
          sendComplainController.sink.add(resp);
        });
      }
    });

  }

  dispose(){
    sendComplainController.close();
  }

}

