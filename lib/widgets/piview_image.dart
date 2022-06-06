import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  final String image;

  const PreviewImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
          child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: const AssetImage('assets/images/placeHolder2.jpg'),
              image: NetworkImage(image))),
    );
  }
}
