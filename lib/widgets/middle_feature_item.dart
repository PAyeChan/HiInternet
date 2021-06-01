import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:hiinternet/screens/home_screen/home_response.dart';

// ignore: must_be_immutable
class MiddleFeatureItems extends StatelessWidget {

  List<MiddleImagesVO> images;

  MiddleFeatureItems(this.images);
  @override
  Widget build(BuildContext context) {
    print(images[0].image);

    return Container(
      margin: EdgeInsets.all(10),
      child: Center(child: SizedBox(
        height: 190.0,
        width: MediaQuery.of(context).size.width,
        child: Carousel(
          boxFit: BoxFit.fill,
          autoplay: false,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 800),
          dotSize: 6.0,
          dotIncreasedColor: Color(0xFFFF335C),
          dotBgColor: Colors.transparent,
          dotColor: Colors.grey,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 10.0,
          showIndicator: true,
          indicatorBgPadding: 7.0,
          images: images.map((imgData) =>
            NetworkImage((imgData.image != null) ? imgData.image : imgData.videoUrl)).toList(),
        ),
      ),),
    );
  }
}
