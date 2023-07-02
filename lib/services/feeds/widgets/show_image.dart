import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:twichat/consts/theme/app_color.dart';

class ShowCarousel extends StatefulWidget {
  final List<String> imageUrls;
  const ShowCarousel({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  State<ShowCarousel> createState() => _ShowCarouselState();
}

class _ShowCarouselState extends State<ShowCarousel> {
  int _currIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageUrls.map((image) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: Image.network(
                    image,
                    fit: BoxFit.fill,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                  height: 300,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.95,
                  onPageChanged: ((index, reason) {
                    setState(() {
                      _currIndex = index;
                    });
                  })),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageUrls.asMap().entries.map((e) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(left: 2, right: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor
                        .withOpacity(_currIndex == e.key ? 0.95 : 0.50),
                  ),
                );
              }).toList(),
            )
          ],
        )
      ],
    );
  }
}
