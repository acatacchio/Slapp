import 'package:flutter/material.dart';
import 'package:slapp/model/color_theme.dart';
import 'package:slapp/util/images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImage extends InkWell {
  ProfileImage({Key? key,
    required String urlString,
    required VoidCallback onPressed,
    required context,
    double imageSize = 20})
    : super(key: key,
      onTap: onPressed,
      child: CircleAvatar(
          backgroundColor: ColorTheme().background(),
          radius: imageSize,
          backgroundImage: (urlString != null && urlString != "")
              ? CachedNetworkImageProvider(urlString)
              : AssetImage(logoImage) as ImageProvider
      )
  );
}
