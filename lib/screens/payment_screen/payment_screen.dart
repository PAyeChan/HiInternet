import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/payment_screen/payment_response.dart';
import 'package:hiinternet/screens/payment_screen/payment_bloc.dart';
import 'package:hiinternet/widgets/payment_item.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment_screen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  var allPayment = false;
  var paidPayment = false;
  var unPaidPayment = false;
  var userId;

  final _paymentBloc = PaymentBloc();

  @override
  void initState() {

    SharedPref.getData(key: SharedPref.user_id).then((value) {
        if (value != null && value.toString() != 'null') {
          userId = json.decode(value).toString();

          Map<String, String> map = {
            'user_id': userId,
            'app_version': app_version,
          };

         _paymentBloc.getPayment(map);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    allPayment = true;
    paidPayment = false;
    unPaidPayment = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Scaffold(
          body: paymentBar()
        ),
      ),
    );
  }

  Widget paymentBar() {
    return Column(
      children: [
        Container(
          height: 80,
          color: Colors.blueGrey,
          padding: EdgeInsets.all(20),
          child: GestureDetector(
            onTap: availablePaymentMethods,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment),
                    Text((SharedPref.IsSelectedEng()) ? StringsEN.btn_availablePayment : StringsMM.btn_availablePayment),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          //'Payment',
          (SharedPref.IsSelectedEng()) ? StringsEN.payment : StringsMM.payment,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ActionChip(
                  backgroundColor: allPayment ? Colors.blue : Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  label: Text(
                      (SharedPref.IsSelectedEng()) ? StringsEN.all : StringsMM.all,
                      style: TextStyle(fontSize: (SharedPref.IsSelectedEng()) ? 14 : 12, )
                  ),
                  onPressed: () {
                    setState(() {
                      allPayment = true;
                      paidPayment = false;
                      unPaidPayment = false;
                    });
                  }),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ActionChip(
                  backgroundColor: paidPayment ? Colors.blue : Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  label: Text(
                      (SharedPref.IsSelectedEng()) ? StringsEN.paid : StringsMM.paid,
                      style: TextStyle(fontSize: (SharedPref.IsSelectedEng()) ? 14 : 12, )
                  ),
                  onPressed: () {
                    setState(() {
                      allPayment = false;
                      paidPayment = true;
                      unPaidPayment = false;
                    });
                  }),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ActionChip(
                  backgroundColor: unPaidPayment ? Colors.blue : Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  label: Text(
                      (SharedPref.IsSelectedEng()) ? StringsEN.unpaid : StringsMM.unpaid,
                      style: TextStyle(fontSize: (SharedPref.IsSelectedEng()) ? 14 : 12, )
                  ),
                  onPressed: () {
                    setState(() {
                      allPayment = false;
                      paidPayment = false;
                      unPaidPayment = true;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        paymentItemsList(),
      ],
    );

  }

  Widget paymentItemsList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: StreamBuilder<ResponseVO>(
          builder: (context, snapshot) {
            ResponseVO resp = snapshot.data;
            if (resp.message == MsgState.loading) {
              return Center(
                child: Container(
                    margin: EdgeInsets.only(top: 10,),
                    child: CircularProgressIndicator()),
              );
            } else if (resp.message == MsgState.error) {
              return Center(
                child: Text((SharedPref.IsSelectedEng())
                    ? StringsEN.something_wrong
                    : StringsMM
                    .something_wrong), //'Something wrong,try again...'),
              );
            } else {
              List<PaymentVO> list = resp.data;
              return //Expanded(
                //child: Padding(
                //padding: const EdgeInsets.only(bottom: 100),
                //child: ListView.builder(
                Container(
                  margin: EdgeInsets.only(bottom: 40,),
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return PaymentItems(list
                        .where((element) =>
                    allPayment ? true : paidPayment
                        ? element.paidStatus == 'Paid'
                        : element.paidStatus == 'UnPaid')
                        .toList()[index]);
                  },
                  itemCount: list
                      .where((element) =>
                  allPayment ? true : paidPayment
                      ? element.paidStatus == 'Paid'
                      : element.paidStatus == 'UnPaid')
                      .toList()
                      .length,
                  //),
                  ),
                );
            }
          },
          stream: _paymentBloc.paymentStream(),
          initialData: ResponseVO(message: MsgState.loading),
        ),
      ),
    );

  }

  void availablePaymentMethods() {
    SharedPref.getData(key: SharedPref.payment_method_url).then((value) {
      value = value.replaceAll('"', '').trim();
      launch(value);
    });
  }

  @override
  void dispose() {
    _paymentBloc.dispose();
    super.dispose();
  }

}
