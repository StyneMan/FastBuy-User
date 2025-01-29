import 'dart:async';

import 'package:customer/models/vendor_model.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:flutter/material.dart';

class RestaurantImageView extends StatefulWidget {
  final images;
  const RestaurantImageView({
    super.key,
    required this.images,
  });

  @override
  State<RestaurantImageView> createState() => _RestaurantImageViewState();
}

class _RestaurantImageViewState extends State<RestaurantImageView> {
  int currentPage = 0;

  PageController pageController = PageController(initialPage: 1);

  @override
  void initState() {
    // animateSlider();
    super.initState();
  }

  void animateSlider() {
    if (widget.images != null && widget.images!.isNotEmpty) {
      if (widget.images!.length > 1) {
        Timer.periodic(const Duration(seconds: 2), (Timer timer) {
          if (currentPage < widget.images!.length - 1) {
            currentPage++;
          } else {
            currentPage = 0;
          }

          if (pageController.hasClients) {
            pageController.animateToPage(
              currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Responsive.height(20, context),
        child:
            // widget.images == null || widget.images!.isEmpty
            // ?
            NetworkImageWidget(
          imageUrl: "${widget.images}",
          fit: BoxFit.cover,
          height: Responsive.height(20, context),
          width: Responsive.width(100, context),
          errorWidget: const Icon(
            Icons.photo_size_select_actual_rounded,
            size: 100,
          ),
        )
        // : PageView.builder(
        //     physics: const BouncingScrollPhysics(),
        //     controller: pageController,
        //     scrollDirection: Axis.horizontal,
        //     allowImplicitScrolling: true,
        //     itemCount: widget.images!.length,
        //     padEnds: false,
        //     pageSnapping: true,
        //     itemBuilder: (BuildContext context, int index) {
        //       String image = widget.images;
        //       return NetworkImageWidget(
        //         imageUrl: image.toString(),
        //         fit: BoxFit.cover,
        //         height: Responsive.height(20, context),
        //         width: Responsive.width(100, context),
        //       );
        //     },
        //   ),
        );
  }
}
