import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final double height;
  final List<String> imageUrls;

  const ImageCarousel({Key? key, required this.imageUrls, this.height = 100.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> images = imageUrls.map((url) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              url,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }).toList();
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: images,
        ),
      ),
    );
  }
}
