import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:hiinternet/screens/home_screen/home_response.dart';
import 'package:video_player/video_player.dart';

class MiddleFeatureItems extends StatefulWidget {
  List<MiddleImagesVO> images;
  MiddleFeatureItems(this.images);

  @override
  _MiddleFeatureItemsState createState() => _MiddleFeatureItemsState(images);
}

class _MiddleFeatureItemsState extends State<MiddleFeatureItems> {

  List<MiddleImagesVO> images;
  Map<String, VideoPlayerController> videoPlayerCtrls = new Map.identity();

  _MiddleFeatureItemsState(this.images);

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
            CreateCarouselItem(imgData.image, imgData.videoUrl)).toList(),
        ),
      ),),
    );
  }

  @override
  void dispose() {
    videoPlayerCtrls.forEach((key, value) {
      value.dispose();
    });

    super.dispose();
  }

  Widget CreateCarouselItem(String imgUrl, String videoUrl) {
    if(imgUrl != null && imgUrl.isNotEmpty) {
      return Image.network(imgUrl);
    }

    if(videoUrl != null && videoUrl.isNotEmpty) {
      VideoPlayerController _controller = VideoPlayerController.network(
        videoUrl,
      );

      videoPlayerCtrls[videoUrl] = _controller;
      Future<void> _initializeVideoPlayerFuture = _controller.initialize();

      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            AspectRatio _ar = AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
            _controller.play();

            return _ar;
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );

    }

    return Container();

  }

}
